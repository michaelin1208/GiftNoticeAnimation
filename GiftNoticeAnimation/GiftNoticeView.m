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
#import "FireworkAnimation.h"
#import "Car.h"
#import "BannerView.h"
#import "MessageView.h"

#define kGapHeight 10
#define kGiftLinesQty 4
#define kMessageLinesQty 2
#define kValidPeriod 5
#define kGiftNoticeCellViewWidth 202
#define kGiftNoticeCellViewHeight 34
#define kBannerViewWidth 202
#define kBannerViewHeight 34

@interface GiftNoticeView ()


@end

@implementation GiftNoticeView {
    UIView* backgroundView;
    NSMutableArray* cells;
    NSMutableArray* messageCells;
    NSMutableArray* waitingGiftNotices;
    NSMutableArray* activeGiftNotices;
    
    NSMutableArray* waitingBanners;
    NSMutableArray* waitingMessages;
    
    BannerView* bannerView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cells = [[NSMutableArray alloc] init];
        messageCells = [[NSMutableArray alloc] init];
        waitingGiftNotices = [[NSMutableArray alloc] init];
        activeGiftNotices = [[NSMutableArray alloc] init];
        
        waitingBanners = [[NSMutableArray alloc] init];
        waitingMessages = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blueColor];
//        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        
        bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kBannerViewWidth, kBannerViewHeight)];
        bannerView.hidden = YES;
        [self addSubview:bannerView];
        
        
        for(int i=0; i<kMessageLinesQty; i ++){
            
            MessageView *tempCell = [[MessageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - (i+1) * (kGiftNoticeCellViewHeight + kGapHeight)), kGiftNoticeCellViewWidth, kGiftNoticeCellViewHeight)];
            tempCell.cellID = i;
            tempCell.giftNameLabel.text = [NSString stringWithFormat:@"line %d", i];
            tempCell.giftSenderLabel.text = [NSString stringWithFormat:@"line %d", i];
            
            [self addSubview:tempCell];
            [messageCells addObject:tempCell];
            tempCell.hidden = YES;
        }
        
        for(int i=0; i<kGiftLinesQty; i ++){
            int endHeight = self.frame.size.height;
            if(messageCells.count >0){
                MessageView *tempMessageCell = [messageCells objectAtIndex:messageCells.count - 1];
                endHeight = tempMessageCell.layer.position.y;
            }
            
            GiftNoticeCellView *tempCell = [[GiftNoticeCellView alloc] initWithFrame:CGRectMake(0, (endHeight - (i+1) * (kGiftNoticeCellViewHeight + kGapHeight)), kGiftNoticeCellViewWidth, kGiftNoticeCellViewHeight)];
            tempCell.cellID = i;
            tempCell.giftNameLabel.text = [NSString stringWithFormat:@"line %d", i];
            tempCell.giftSenderLabel.text = [NSString stringWithFormat:@"line %d", i];
            
            [tempCell initAnimations];
            
            [self addSubview:tempCell];
            [cells addObject:tempCell];
            tempCell.hidden = YES;
        }
        
        
//        // 计算背景页面大小 似乎无所谓大小
//        if (cells.count > 0){
//            GiftNoticeCellView *tempCell = [cells objectAtIndex:0];
//            
//            self.frame = CGRectMake(0, 0, tempCell.frame.size.width, cells.count * (tempCell.frame.size.height + kGapHeight));
//            [self reloadInputViews];
//        }
        
        for(int i=0; i<cells.count; i ++){
            NSLog(@"%d x %f y %f", i, [[cells objectAtIndex:i] frame].origin.x, [[cells objectAtIndex:i] frame].origin.y);
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsWaiting:) name:@"IAmWaiting" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellWantToDisappear:) name:@"IWantToDisappear" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsDisappeared:) name:@"IAmDisappeared" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ABannerFinish:) name:@"BannerFinished" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AMessageFinish:) name:@"MessageFinished" object:nil];
        
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

- (void)ABannerFinish:(NSNotification *)notification{
    [self checkWaitingBanners];
    
}
- (void)AMessageFinish:(NSNotification *)notification{
    [self checkWaitingMessages];
    
}

- (void)insertWaitingMessagesWithSenderID:(NSString *)senderID Name: (NSString *)senderName ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName Content:(NSString *) content{
    @synchronized (waitingGiftNotices) {
            [waitingMessages addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", receiverID, @"receiverID", receiverName, @"receiverName", content, @"content", nil]];
            [self checkWaitingMessages];
        
    }
}


- (void)insertWaitingGiftNoticesWithSenderID:(NSString *)senderID Name: (NSString *)senderName ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName GiftID: (NSString *)giftID Name:(NSString *)giftName Count:(NSString *)count{
    @synchronized (waitingGiftNotices) {
        if ([giftID isEqualToString:@"3333"]||[giftID isEqualToString:@"4444"]) {
            [waitingBanners addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", count, @"count", nil]];
            [self checkWaitingBanners];
        }else{
            NSMutableDictionary *lastDictionary = [waitingGiftNotices lastObject];
            if (lastDictionary == nil) {
                [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", count, @"count", nil]];
            }else{
                if ([[lastDictionary objectForKey:@"senderID"] isEqualToString:senderID]&&[[lastDictionary objectForKey:@"giftID"] isEqualToString: giftID]) {
                    NSLog(@"add count");
                    [lastDictionary setValue:[NSString stringWithFormat:@"%d",([[lastDictionary objectForKey:@"count"] intValue] + [count intValue])] forKey:@"count"];
                }else{
                    [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", count, @"count", nil]];
                }
            }
            [self checkWaitingGiftNotices];
        }
    }
}

- (void)checkWaitingGiftNotices{
    @synchronized (waitingGiftNotices) {
        if (waitingGiftNotices.count > 0) {
            NSMutableDictionary *nextGiftNoticeDic = [waitingGiftNotices objectAtIndex:0];
            NSString *tempSenderID = [nextGiftNoticeDic objectForKey:@"senderID"];
            NSString *tempSenderName = [nextGiftNoticeDic objectForKey:@"senderName"];
            NSString *tempReceiverID = [nextGiftNoticeDic objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextGiftNoticeDic objectForKey:@"receiverName"];
            NSString *tempGiftID = [nextGiftNoticeDic objectForKey:@"giftID"];
            NSString *tempGiftName = [nextGiftNoticeDic objectForKey:@"giftName"];
            NSString *tempCount = [nextGiftNoticeDic objectForKey:@"count"];
            
            GiftNoticeCellView *tempGiftNoticeCellView = [self findFeasibleCellBySender:tempSenderID Gift:tempGiftID];
            if (tempGiftNoticeCellView != nil) {
                
                tempGiftNoticeCellView.canDisappear = NO;
                tempGiftNoticeCellView.canKeepWaiting = NO;
                
                ActiveGiftNotice *tempActiveGiftNotice = [self findActiveGiftNoticeBySender:tempSenderID Gift:tempGiftID];
                if (tempActiveGiftNotice == nil) {
                    tempActiveGiftNotice = [[ActiveGiftNotice alloc] initWithSenderID:tempSenderID Name:tempSenderName GiftID:tempGiftID Name:tempGiftName];
                    [activeGiftNotices addObject:tempActiveGiftNotice];
                }
                
                [tempActiveGiftNotice increaseCount:[tempCount intValue] withCell:tempGiftNoticeCellView];
                
                // BannerView test
//                [bannerView startAnimationWithSenderName:tempSenderName ReceiverName:@"test" GiftName:tempGiftName Count:tempCount InReceiver:YES];
                // BannerView test
                
                
//                NSLog(@"cellid %d %@ %@ increaseCount %d", tempGiftNoticeCellView.cellID, tempSender, tempGift, [tempCount intValue]);
                [waitingGiftNotices removeObjectAtIndex:0];
                
                //keep finding
                [self checkWaitingGiftNotices];
                
            }
        }
    }
}

- (void)checkWaitingMessages{
    @synchronized (waitingMessages) {
        if (waitingMessages.count > 0) {
            NSMutableDictionary *nextWaitingMessage = [waitingMessages objectAtIndex:0];
            NSString *tempSenderID = [nextWaitingMessage objectForKey:@"senderID"];
            NSString *tempSenderName = [nextWaitingMessage objectForKey:@"senderName"];
            NSString *tempReceiverID = [nextWaitingMessage objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextWaitingMessage objectForKey:@"receiverName"];
            NSString *tempContent = [nextWaitingMessage objectForKey:@"content"];
            
            MessageView *tempMessageCell = [self findFeasibleMessageCell];
            if (tempMessageCell != nil) {
                if (tempMessageCell.isHidden) {
                    NSLog(@"send next");
                    //test test bannerView startAnimationWithSenderName
                    [tempMessageCell startAnimationWithSenderName:tempSenderName ReceiverName:tempReceiverName Content:tempContent];
                    [waitingMessages removeObject:0];
                }
            }
            
        }
    }
}


- (void)checkWaitingBanners{
    NSLog(@"checkWaitingBanners");
    @synchronized (waitingBanners) {
        if (waitingBanners.count > 0) {
            NSMutableDictionary *nextWaitingBanner = [waitingBanners objectAtIndex:0];
            NSString *tempSenderID = [nextWaitingBanner objectForKey:@"senderID"];
            NSString *tempSenderName = [nextWaitingBanner objectForKey:@"senderName"];
            NSString *tempReceiverID = [nextWaitingBanner objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextWaitingBanner objectForKey:@"receiverName"];
            NSString *tempGiftID = [nextWaitingBanner objectForKey:@"giftID"];
            NSString *tempGiftName = [nextWaitingBanner objectForKey:@"giftName"];
            NSString *tempCount = [nextWaitingBanner objectForKey:@"count"];
            
            if (bannerView.isHidden) {
                NSLog(@"send next");
                //test test bannerView startAnimationWithSenderName
                [bannerView startAnimationWithSenderName:tempSenderName ReceiverName:tempReceiverName GiftName:tempGiftName Count:tempCount InReceiver:YES];
                [waitingBanners removeObject:0];
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

- (GiftNoticeCellView *)findFeasibleCellBySender:(NSString *)senderID Gift:(NSString *)giftID{
    NSLog(@"findFeasibleCellBySender");
    for(GiftNoticeCellView* tempCell in cells){
        if ([tempCell.senderID isEqualToString:senderID] && [tempCell.giftID isEqualToString:giftID] && !tempCell.isDisappear){
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

- (MessageView *)findFeasibleMessageCell{
//    NSLog(@"findFeasibleCellBySender");
    for(MessageView* tempCell in messageCells){
        if (tempCell.isHidden) {
            return tempCell;
        }
        
    }
    return nil;
}

- (ActiveGiftNotice *)findActiveGiftNoticeBySender:(NSString *)senderID Gift:(NSString *)giftID{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    long now = [[NSDate date] timeIntervalSince1970];
    ActiveGiftNotice *returnNotice = nil;
    @synchronized (activeGiftNotices) {
        for(ActiveGiftNotice *tempNotice in activeGiftNotices){
//            if (now - tempNotice.updateTime < kValidPeriod) {
                [tempArray addObject:tempNotice];
                if ([tempNotice.senderID isEqualToString:senderID] && [tempNotice.giftID isEqualToString:giftID]){
                    returnNotice = tempNotice;
                }
//            }
        }
        activeGiftNotices = tempArray;
    }
    
    return returnNotice;
}



@end