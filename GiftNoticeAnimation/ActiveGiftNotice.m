//
//  ActiveGiftNotice.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/26.
//  Copyright © 2016年 9158. All rights reserved.
//

//
//  GiftNoticeCellView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveGiftNotice.h"

#define kGiftNoticeCellViewWeight 200
#define kGiftNoticeCellViewHeight 50
#define kGiftNoticeCellLabelWidth 100
#define kGiftNoticeCellLabelHeight 20
#define kRunDuration 0.5

@interface ActiveGiftNotice ()


@end

@implementation ActiveGiftNotice {
    UIView* backgroundView;
    CAAnimationGroup *appearAnimation;
    CAAnimationGroup *disappearAnimation;
    Boolean firstStep;
    
    CGPoint startPoint;
    CGPoint stayPoint;
    CGPoint endPoint;
    
    int currentCount;
    int targetCount;
    Boolean isShown;
}

- (instancetype)initWithSenderID:(NSString *)senderID Name:(NSString *)senderName ReceiverID:(NSString *)receiverID name:(NSString *)receiverName GiftID:(NSString *)giftID Name:(NSString *)giftName{
    self = [super init];
    if (self) {
        currentCount = 0;
        targetCount = 0;
        _updateTime = [[NSDate date] timeIntervalSince1970];
//        _allocatedCell = cell;
        _senderID = senderID;
        _senderName = senderName;
        _receiverID = receiverID;
        _receiverName = receiverName;
        _giftID = giftID;
        _giftName = giftName;
    }
    return self;
}

- (void)increaseCount:(int)number withGiftNoticeCell: (GiftNoticeCellView *)cell {
    
    _updateTime = [[NSDate date] timeIntervalSince1970];
    targetCount = currentCount + number;
    
    [cell increaseCellWithCurrentCount:currentCount TargetCount:targetCount SenderID:_senderID Name:_senderName GiftID:_giftID Name:_giftName];
    
    currentCount = targetCount;
}

- (void)increaseCount:(int)number withBannerCell: (BannerView *)cell {
    
    _updateTime = [[NSDate date] timeIntervalSince1970];
    targetCount = currentCount + number;
    
    [cell startAnimationWithSenderName:_senderName ReceiverName:_receiverName GiftName:_giftName Count:[NSString stringWithFormat:@"%d", targetCount] InReceiver:YES];
    
    currentCount = targetCount;
}


@end
