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
    long currentTimeInterval;
    Boolean isShown;
    

    
}

- (instancetype)initWithCell:(GiftNoticeCellView *)cell Sender:(NSString *)sender Gift:(NSString *)gift
{
    self = [super init];
    if (self) {
        currentCount = 0;
        targetCount = 0;
        currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        _allocatedCell = cell;
        _senderName = sender;
        _giftName = gift;
    }
    return self;
}

- (void)increaseCount:(int)number withCell: (GiftNoticeCellView *)cell {
    
    currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    targetCount = currentCount + number;
    
    [cell increaseCellWithCurrentCount:currentCount TargetCount:targetCount Sender:_senderName Gift:_giftName];
    
    currentCount = targetCount;
}


@end
