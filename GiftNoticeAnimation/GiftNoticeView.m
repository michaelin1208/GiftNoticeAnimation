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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wantDisappearActionMethod:) name:@"WantDisappearMyself" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callNextNotice:) name:@"CallNextNotice" object:nil];
    }
    return self;
}

//- (void)addActiveGiftNoticeSender:(NSString *)sender Gift:(NSString *)gift {
//
//    ActiveGiftNotice *tempActiveGiftNotice = [[ActiveGiftNotice alloc] initWithCell:[cells objectAtIndex:0] Sender:@"aaaaaaaa" Gift:@"bbbbbbbbbb"];
//    [tempActiveGiftNotice increaseCount:5 withCell:[cells objectAtIndex:2]];
//    
//}

- (void)wantDisappearActionMethod:(NSNotification *)notification {
    NSLog(@"disappearMethod");
    //    GiftNoticeView
    
    
    [self checkNextGiftNotice:((NSNumber *)(notification.object)).intValue];
    
}

//- (Boolean)checkNextNotic:(GiftNoticeCellView *)noticeCellView{
//    
//}

- (void)callNextNotice:(NSNotification *)notification {
    NSLog(@"callNextNotice");
    //    GiftNoticeView
    NSLog(@"cell id %d",((NSNumber *)(notification.object)).intValue);
    int tempCellID = ((NSNumber *)(notification.object)).intValue;
    [self startNextGiftNotice:tempCellID];
    //    [self solveNextNoticeInCell:((NSNumber *)(notification.object)).intValue];
    
}

- (void)insertWaitingGiftNoticesWithSender:(NSString *)sender Gift: (NSString *)gift Count:(NSString *)count{
    [waitingGiftNotices addObject:[NSDictionary dictionaryWithObjectsAndKeys:sender, @"sender", gift, @"gift", count, @"count", nil]];
    int feasibleCell = [self findFeasibleCell];
    if(feasibleCell>=0){
        [self startNextGiftNotice:feasibleCell];
    }
}

- (void)checkNextGiftNotice:(int)cellID{
    if(waitingGiftNotices.count == 0){
        GiftNoticeCellView *tempCell = [cells objectAtIndex:cellID];
        [tempCell startToDisappear];
        NSLog(@"ALL DONE");
    }else{
        NSDictionary *nextGiftNoticeDic = [waitingGiftNotices objectAtIndex:0];
        
        NSString *tempSender = [nextGiftNoticeDic objectForKey:@"sender"];
        NSString *tempGift = [nextGiftNoticeDic objectForKey:@"gift"];
        NSString *tempCount = [nextGiftNoticeDic objectForKey:@"count"];
        
        GiftNoticeCellView *tempCell = [self findSameCell:tempSender Gift:tempGift];
        
        if (tempCell != nil) {
            if (tempCell.isUsable) {
                ActiveGiftNotice *tempNotice = [self findActiveGiftNoticeBySender:tempSender Gift: tempGift];
                if (tempNotice != nil) {
                    NSLog(@"aaaaaaaaaa");
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                }else{
                    NSLog(@"bbbbbbbbbb");
                    tempNotice = [[ActiveGiftNotice alloc] initWithCell:tempCell Sender:tempSender Gift: tempGift];
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                    [activeGiftNotices addObject:tempNotice];
                }
                [waitingGiftNotices removeObjectAtIndex:0];
                [self checkNextGiftNotice:cellID];
            }
        }
        
    }
}

- (void) startNextGiftNotice:(int)cellID{
    if(waitingGiftNotices.count == 0){
        NSLog(@"ALL DONE");
    }else{
        NSDictionary *nextGiftNoticeDic = [waitingGiftNotices objectAtIndex:0];
        NSString *tempSender = [nextGiftNoticeDic objectForKey:@"sender"];
        NSString *tempGift = [nextGiftNoticeDic objectForKey:@"gift"];
        NSString *tempCount = [nextGiftNoticeDic objectForKey:@"count"];
        
        GiftNoticeCellView *tempCell = [self findSameCell:tempSender Gift:tempGift];
        
        if (tempCell != nil) {
            if (tempCell.isUsable) {
                ActiveGiftNotice *tempNotice = [self findActiveGiftNoticeBySender:tempSender Gift: tempGift];
                if (tempNotice != nil) {
                    NSLog(@"aaaaaaaaaa");
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                }else{
                    NSLog(@"bbbbbbbbbb");
                    tempNotice = [[ActiveGiftNotice alloc] initWithCell:tempCell Sender:tempSender Gift: tempGift];
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                    [activeGiftNotices addObject:tempNotice];
                }
                [waitingGiftNotices removeObjectAtIndex:0];
                [self checkNextGiftNotice:cellID];
            }
        }else{
            tempCell = [cells objectAtIndex:cellID];
            if (tempCell.isUsable) {
                ActiveGiftNotice *tempNotice = [self findActiveGiftNoticeBySender:tempSender Gift: tempGift];
                if (tempNotice != nil) {
                    NSLog(@"aaaaaaaaaa");
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                }else{
                    NSLog(@"bbbbbbbbbb");
                    tempNotice = [[ActiveGiftNotice alloc] initWithCell:tempCell Sender:tempSender Gift: tempGift];
                    [tempNotice increaseCount:[tempCount intValue] withCell:tempCell];
                    [activeGiftNotices addObject:tempNotice];
                }
                [waitingGiftNotices removeObjectAtIndex:0];
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

- (GiftNoticeCellView *)findSameCell:(NSString *)sender Gift:(NSString *)gift{
    for(GiftNoticeCellView* tempCell in cells){
        if ([tempCell.senderName isEqualToString:sender] && [tempCell.giftName isEqualToString:gift]){
            return tempCell;
        }
    }
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