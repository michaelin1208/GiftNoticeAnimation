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

#define kGapHeight 10       //跑道间间隔
#define kGiftLinesQty 4     //普通礼物跑道数量
#define kMessageLinesQty 2  //广播消息跑道数量
#define kValidPeriod 5      //礼物数量叠加有效时间（秒） 超过时间将会清零重新计算，但是现在进房间一直有效，时间确认代码也被注释，代码在下方
#define kGiftNoticeCellViewWidth 202        //礼物通知窗口的宽度
#define kGiftNoticeCellViewHeight 34        //礼物通知窗口的高度
#define kBannerViewWidth 202                //顶端大礼物横幅窗口的宽度
#define kBannerViewHeight 34                //顶端大礼物横幅窗口的高度

@interface GiftNoticeView ()


@end

@implementation GiftNoticeView {
    UIView* backgroundView;
    NSMutableArray* cells;                  //普通礼物窗口的数组，最下面的窗口在0位，越上面越大，为了让下方普通礼物窗口优先使用
    NSMutableArray* messageCells;           //喇叭广播窗口的数组，同样最下面的在数组的0位置
    NSMutableArray* waitingGiftNotices;     //排队等待显示的普通礼物信息。
    NSMutableArray* activeGiftNotices;      //显示过的活跃的礼物信息，用于累加记录一段时间内收到的总礼物数量。
    
    NSMutableArray* waitingBanners;         //排队等待显示的超级礼物信息。
    NSMutableArray* waitingMessages;        //排队等待显示的喇叭广播消息。
    
    BannerView* bannerView;                 //顶端的超级礼物跑道显示的页面。
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
        
//        self.backgroundColor = [UIColor blueColor];
//        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        
        bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kBannerViewWidth, kBannerViewHeight)];
        bannerView.hidden = YES;
        [self addSubview:bannerView];
        
        //创建广播消息跑道
        for(int i=0; i<kMessageLinesQty; i ++){
            
            MessageView *tempCell = [[MessageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - (i+1) * (kGiftNoticeCellViewHeight + kGapHeight)), kGiftNoticeCellViewWidth, kGiftNoticeCellViewHeight)];
            tempCell.cellID = i;
            tempCell.senderLabel.text = [NSString stringWithFormat:@"line %d", i];
            tempCell.contentLabel.text = [NSString stringWithFormat:@"line %d", i];
            
            [self addSubview:tempCell];
            [messageCells addObject:tempCell];
            tempCell.hidden = YES;
        }
        
        //创建普通礼物跑道
        for(int i=0; i<kGiftLinesQty; i ++){
            int endHeight = self.frame.size.height;
            if(messageCells.count >0){
                MessageView *tempMessageCell = [messageCells objectAtIndex:messageCells.count - 1];
                endHeight = tempMessageCell.layer.position.y - tempMessageCell.frame.size.height/2;
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
        
//        for(int i=0; i<cells.count; i ++){
//            NSLog(@"%d x %f y %f", i, [[cells objectAtIndex:i] frame].origin.x, [[cells objectAtIndex:i] frame].origin.y);
//        }
        
        //注册通知中心观察者 和对应处理方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsWaiting:) name:@"IAmWaiting" object:nil];//一个普通礼物页面在等待礼物
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellWantToDisappear:) name:@"IWantToDisappear" object:nil];//一个普通礼物想要消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ACellIsDisappeared:) name:@"IAmDisappeared" object:nil];//一个普通礼物消失了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ABannerFinish:) name:@"BannerFinished" object:nil];//一个超级礼物显示完成了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AMessageFinish:) name:@"MessageFinished" object:nil];//一个广播信息显示完成了
        
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

//插入一个等待显示的广播消息
- (void)insertWaitingMessagesWithSenderID:(NSString *)senderID Name: (NSString *)senderName IconPath: (NSString *)senderIconPath ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName Content:(NSString *) content{
    @synchronized (waitingGiftNotices) {
            [waitingMessages addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", senderIconPath, @"senderIconPath", receiverID, @"receiverID", receiverName, @"receiverName", content, @"content", nil]];
            [self checkWaitingMessages];
        
    }
}

//插入一个等待显示的礼物，包括超级礼物和普通礼物，通过isSuperGift来确定是否是超级礼物，放进不同的等待信息列表中
- (void)insertWaitingGiftNoticesWithSenderID:(NSString *)senderID Name: (NSString *)senderName IconPath: (NSString *)senderIconPath ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName GiftID: (NSString *)giftID Name:(NSString *)giftName ImagePath: (NSString *)giftImagePath Count:(NSString *)count SuperGift: (Boolean)isSuperGift{
    @synchronized (waitingGiftNotices) {
        if (isSuperGift) {
            [waitingBanners addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", senderIconPath, @"senderIconPath", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", giftImagePath, @"giftImagePath", count, @"count", nil]];
            [self checkWaitingBanners];
        }else{
            NSMutableDictionary *lastDictionary = [waitingGiftNotices lastObject];
            if (lastDictionary == nil) {
                [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", senderIconPath, @"senderIconPath", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", giftImagePath, @"giftImagePath", count, @"count", nil]];
            }else{
                if ([[lastDictionary objectForKey:@"senderID"] isEqualToString:senderID]&&[[lastDictionary objectForKey:@"giftID"] isEqualToString: giftID]) {
//                    NSLog(@"add count");
                    [lastDictionary setValue:[NSString stringWithFormat:@"%d",([[lastDictionary objectForKey:@"count"] intValue] + [count intValue])] forKey:@"count"];
                }else{
                    [waitingGiftNotices addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:senderID, @"senderID", senderName, @"senderName", senderIconPath, @"senderIconPath", receiverID, @"receiverID", receiverName, @"receiverName", giftID, @"giftID", giftName, @"giftName", giftImagePath, @"giftImagePath", count, @"count", nil]];
                }
            }
            [self checkWaitingGiftNotices];
        }
    }
}

//检查下是否可以显示下一个礼物，1 是否有可用的礼物显示单元，2 是否有等待需要显示的礼物
- (void)checkWaitingGiftNotices{
    @synchronized (waitingGiftNotices) {
        if (waitingGiftNotices.count > 0) {
            NSMutableDictionary *nextGiftNoticeDic = [waitingGiftNotices objectAtIndex:0];
            NSString *tempSenderID = [nextGiftNoticeDic objectForKey:@"senderID"];
            NSString *tempSenderName = [nextGiftNoticeDic objectForKey:@"senderName"];
            NSString *tempSenderIconPath = [nextGiftNoticeDic objectForKey:@"senderIconPath"];
            NSString *tempReceiverID = [nextGiftNoticeDic objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextGiftNoticeDic objectForKey:@"receiverName"];
            NSString *tempGiftID = [nextGiftNoticeDic objectForKey:@"giftID"];
            NSString *tempGiftName = [nextGiftNoticeDic objectForKey:@"giftName"];
            NSString *tempGiftImagePath = [nextGiftNoticeDic objectForKey:@"giftImagePath"];
            NSString *tempCount = [nextGiftNoticeDic objectForKey:@"count"];
            
            GiftNoticeCellView *tempGiftNoticeCellView = [self findFeasibleCellBySender:tempSenderID Gift:tempGiftID];
            if (tempGiftNoticeCellView != nil) {
                
                tempGiftNoticeCellView.canDisappear = NO;
                tempGiftNoticeCellView.canKeepWaiting = NO;
                
                ActiveGiftNotice *tempActiveGiftNotice = [self findActiveGiftNoticeBySender:tempSenderID Gift:tempGiftID];
                if (tempActiveGiftNotice == nil) {
                    tempActiveGiftNotice = [[ActiveGiftNotice alloc] initWithSenderID:tempSenderID Name:tempSenderName IconPath:tempSenderIconPath ReceiverID:tempReceiverID name:tempReceiverName GiftID:tempGiftID Name:tempGiftName ImagePath:tempGiftImagePath];
                    [activeGiftNotices addObject:tempActiveGiftNotice];
                }
                
                [tempActiveGiftNotice increaseCount:[tempCount intValue] withGiftNoticeCell:tempGiftNoticeCellView];
                
                
                
//                NSLog(@"cellid %d %@ %@ increaseCount %d", tempGiftNoticeCellView.cellID, tempSender, tempGift, [tempCount intValue]);
                [waitingGiftNotices removeObjectAtIndex:0];
                
                //keep finding
                [self checkWaitingGiftNotices];
                
            }
        }
    }
}

//检查下是否可以显示下一个消息，1 是否有可用的消息显示单元，2 是否有等待需要显示的消息
- (void)checkWaitingMessages{
    @synchronized (waitingMessages) {
        if (waitingMessages.count > 0) {
            NSMutableDictionary *nextWaitingMessage = [waitingMessages objectAtIndex:0];
            NSString *tempSenderID = [nextWaitingMessage objectForKey:@"senderID"];
            NSString *tempSenderName = [nextWaitingMessage objectForKey:@"senderName"];
            NSString *tempSenderIconPath = [nextWaitingMessage objectForKey:@"senderIconPath"];
            NSString *tempReceiverID = [nextWaitingMessage objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextWaitingMessage objectForKey:@"receiverName"];
            NSString *tempContent = [nextWaitingMessage objectForKey:@"content"];
            
            MessageView *tempMessageCell = [self findFeasibleMessageCell];
            if (tempMessageCell != nil) {
                if (tempMessageCell.isHidden) {
//                    NSLog(@"send next");
                    //test test bannerView startAnimationWithSenderName
                    [tempMessageCell startAnimationWithSenderName:tempSenderName IconPath: tempSenderIconPath ReceiverName:tempReceiverName Content:tempContent];
                    [waitingMessages removeObjectAtIndex:0];
                }
            }
            
        }
    }
}


//检查下是否可以显示下一个超级礼物，1 是否有可用的超级礼物显示单元，2 是否有等待需要显示的超级礼物
- (void)checkWaitingBanners{
//    NSLog(@"checkWaitingBanners");
    @synchronized (waitingBanners) {
        if (waitingBanners.count > 0) {
            NSMutableDictionary *nextWaitingBanner = [waitingBanners objectAtIndex:0];
            NSString *tempSenderID = [nextWaitingBanner objectForKey:@"senderID"];
            NSString *tempSenderName = [nextWaitingBanner objectForKey:@"senderName"];
            NSString *tempSenderIconPath = [nextWaitingBanner objectForKey:@"senderIconPath"];
            NSString *tempReceiverID = [nextWaitingBanner objectForKey:@"receiverID"];
            NSString *tempReceiverName = [nextWaitingBanner objectForKey:@"receiverName"];
            NSString *tempGiftID = [nextWaitingBanner objectForKey:@"giftID"];
            NSString *tempGiftName = [nextWaitingBanner objectForKey:@"giftName"];
            NSString *tempGiftImagePath = [nextWaitingBanner objectForKey:@"giftImagePath"];
            NSString *tempCount = [nextWaitingBanner objectForKey:@"count"];
            
            if (bannerView.isHidden) {
//                NSLog(@"send next");
                //test test bannerView startAnimationWithSenderName
                
                ActiveGiftNotice *tempActiveGiftNotice = [self findActiveGiftNoticeBySender:tempSenderID Gift:tempGiftID];
                if (tempActiveGiftNotice == nil) {
                    tempActiveGiftNotice = [[ActiveGiftNotice alloc] initWithSenderID:tempSenderID Name:tempSenderName IconPath:tempSenderIconPath ReceiverID:tempReceiverID name:tempReceiverName GiftID:tempGiftID Name:tempGiftName ImagePath:tempGiftImagePath];
                    [activeGiftNotices addObject:tempActiveGiftNotice];
                }
                
                [tempActiveGiftNotice increaseCount:[tempCount intValue] withBannerCell:bannerView];
                
                [waitingBanners removeObjectAtIndex:0];
            }
        }
    }
}

//寻找可用的单元
- (int)findFeasibleCell{
    for(GiftNoticeCellView* tempCell in cells){
        if (tempCell.isHidden == YES) {
            return tempCell.cellID;
        }
    }
    return -1;
}

- (GiftNoticeCellView *)findFeasibleCellBySender:(NSString *)senderID Gift:(NSString *)giftID{
//    NSLog(@"findFeasibleCellBySender");
    for(GiftNoticeCellView* tempCell in cells){
        if ([tempCell.senderID isEqualToString:senderID] && [tempCell.giftID isEqualToString:giftID] && !tempCell.isDisappear){
//            NSLog(@"reuse return %d",tempCell.cellID);
            return tempCell;
        }
    }
    
    for(GiftNoticeCellView* tempCell in cells){
//        NSLog(@"cell id %d %d %d",tempCell.cellID, tempCell.isDisappear, tempCell.isUsable);
        if(tempCell.isDisappear && tempCell.isUsable){
//            NSLog(@"new return %d",tempCell.cellID);
            return tempCell;
        }
    }
//    NSLog(@"findFeasibleCellBySender");
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
//            if (now - tempNotice.updateTime < kValidPeriod) {         //有效期验证，来实现比如五分钟内收到的礼物叠加
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