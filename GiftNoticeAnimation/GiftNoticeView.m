//
//  GiftNoticeView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftNoticeView.h"
#import "GiftNoticeCellView.h"
#import "ActiveGiftNotice.h"

#define kGapHeight 5
#define kGiftLinesQty 3

@interface GiftNoticeView ()


@end

@implementation GiftNoticeView {
    UIView* backgroundView;
    NSMutableArray* cells;
    NSMutableArray* waitingGiftNotices;
    NSMutableArray* activeGiftNotices;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cells = [[NSMutableArray alloc] init];
        waitingGiftNotices = [[NSMutableArray alloc] init];
        activeGiftNotices = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blueColor];
        
        for(int i=0; i<kGiftLinesQty; i ++){
            
            GiftNoticeCellView *tempCell = [[GiftNoticeCellView alloc] init];
            
            tempCell.frame = CGRectMake(0, (kGiftLinesQty - i - 1) * (tempCell.frame.size.height + kGapHeight), tempCell.frame.size.width, tempCell.frame.size.height);
            tempCell.cellID = i;
            tempCell.giftNameLabel.text = [NSString stringWithFormat:@"line %d", i];
            tempCell.giftSenderLabel.text = [NSString stringWithFormat:@"line %d", i];
            
            [tempCell initAnimations];
//            NSLog(@"w %f h %f", tempCell.frame.size.width, tempCell.frame.size.height);
            
            [self addSubview:tempCell];
            [cells addObject:tempCell];
            tempCell.hidden = YES;
        }
        
        if (cells.count > 0){
            GiftNoticeCellView *tempCell = [cells objectAtIndex:0];
            
            self.frame = CGRectMake(0, 0, tempCell.frame.size.width, cells.count * (tempCell.frame.size.height + kGapHeight));
            [self reloadInputViews];
        }
        
        for(int i=0; i<cells.count; i ++){
            NSLog(@"%d x %f y %f", i, [[cells objectAtIndex:i] frame].origin.x, [[cells objectAtIndex:i] frame].origin.y);
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsWaiting:) name:@"IAmWaiting" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellWantToDisappear:) name:@"IWantToDisappear" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsDisappeared:) name:@"IAmDisappeared" object:nil];
        
    }
    return self;
}

- (void)ACellIsWaiting:(NSNotification *)notification{
    [self checkWaitingGiftNotices];
    GiftNoticeCellView *tempCell = [cells objectAtIndex:((NSNumber *)(notification.object)).intValue];
    if (tempCell.canKeepWaiting) {
        [tempCell startToWait];
    }
}

- (void)ACellWantToDisappear:(NSNotification *)notification{
    [self checkWaitingGiftNotices];
    GiftNoticeCellView *tempCell = [cells objectAtIndex:((NSNumber *)(notification.object)).intValue];
    if (tempCell.canDisappear) {
        [tempCell disappearAnimation];
    }
}

- (void)ACellIsDisappeared:(NSNotification *)notification{
    [self checkWaitingGiftNotices];
    
}



- (void)insertWaitingGiftNoticesWithSender:(NSString *)sender Gift: (NSString *)gift Count:(NSString *)count{
    @synchronized (waitingGiftNotices) {
        NSMutableDictionary *lastDictionary = [waitingGiftNotices lastObject];
        if (lastDictionary == nil) {
            [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:sender, @"sender", gift, @"gift", count, @"count", nil]];
        }else{
            if ([[lastDictionary objectForKey:@"sender"] isEqualToString:sender]&&[[lastDictionary objectForKey:@"gift"] isEqualToString: gift]) {
                NSLog(@"add count");
                [lastDictionary setValue:[NSString stringWithFormat:@"%d",([[lastDictionary objectForKey:@"count"] intValue] + [count intValue])] forKey:@"count"];
            }else{
                [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:sender, @"sender", gift, @"gift", count, @"count", nil]];
            }
        }
        
        [self checkWaitingGiftNotices];
    }
}

- (void)checkWaitingGiftNotices{
    @synchronized (waitingGiftNotices) {
        if (waitingGiftNotices.count > 0) {
            NSMutableDictionary *nextGiftNoticeDic = [waitingGiftNotices objectAtIndex:0];
            NSString *tempSender = [nextGiftNoticeDic objectForKey:@"sender"];
            NSString *tempGift = [nextGiftNoticeDic objectForKey:@"gift"];
            NSString *tempCount = [nextGiftNoticeDic objectForKey:@"count"];
            
            GiftNoticeCellView *tempGiftNoticeCellView = [self findFeasibleCellBySender:tempSender Gift:tempGift];
            if (tempGiftNoticeCellView != nil) {
                
                tempGiftNoticeCellView.canDisappear = NO;
                tempGiftNoticeCellView.canKeepWaiting = NO;
                
                ActiveGiftNotice *tempActiveGiftNotice = [self findActiveGiftNoticeBySender:tempSender Gift:tempGift];
                if (tempActiveGiftNotice == nil) {
                    tempActiveGiftNotice = [[ActiveGiftNotice alloc] initWithSender:tempSender Gift:tempGift];
                    [activeGiftNotices addObject:tempActiveGiftNotice];
                }
                
                [tempActiveGiftNotice increaseCount:[tempCount intValue] withCell:tempGiftNoticeCellView];
                NSLog(@"cellid %d %@ %@ increaseCount %d", tempGiftNoticeCellView.cellID, tempSender, tempGift, [tempCount intValue]);
                [waitingGiftNotices removeObjectAtIndex:0];
                
                //keep finding
                [self checkWaitingGiftNotices];
                
            }
        }
    }
}


- (int)findFeasibleCell{
    for(GiftNoticeCellView* tempCell in cells){
        if (tempCell.isHidden == YES) {
            return tempCell.cellID;
        }
    }
    return -1;
}

- (GiftNoticeCellView *)findFeasibleCellBySender:(NSString *)sender Gift:(NSString *)gift{
    NSLog(@"findFeasibleCellBySender");
    for(GiftNoticeCellView* tempCell in cells){
        if ([tempCell.senderName isEqualToString:sender] && [tempCell.giftName isEqualToString:gift] && !tempCell.isDisappear){
            NSLog(@"reuse return %d",tempCell.cellID);
            return tempCell;
        }
    }
    
    for(GiftNoticeCellView* tempCell in cells){
        NSLog(@"cell id %d %d %d",tempCell.cellID, tempCell.isDisappear, tempCell.isUsable);
        if(tempCell.isDisappear && tempCell.isUsable){
            NSLog(@"new return %d",tempCell.cellID);
            return tempCell;
        }
    }
    NSLog(@"findFeasibleCellBySender");
    return nil;
}


- (ActiveGiftNotice *)findActiveGiftNoticeBySender:(NSString *)sender Gift:(NSString *)gift{
    for(ActiveGiftNotice *tempNotice in activeGiftNotices){
        if ([tempNotice.senderName isEqualToString:sender] && [tempNotice.giftName isEqualToString:gift]){
            return tempNotice;
        }
    }
    return nil;
}



@end