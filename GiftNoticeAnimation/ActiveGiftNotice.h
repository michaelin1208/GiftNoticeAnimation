//
//  ActiveGiftNotice.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/26.
//  Copyright © 2016年 9158. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GiftNoticeCellView.h"

@interface ActiveGiftNotice : NSObject

//+ (GiftNoticeCellView *)instanceGiftNoticeCellView;
//@property (nonatomic) isShown;
@property (strong, nonatomic) GiftNoticeCellView *allocatedCell;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *giftID;
@property (strong, nonatomic) NSString *giftName;
@property (nonatomic) long updateTime;

- (instancetype)initWithSenderID:(NSString *)senderID Name:(NSString *)senderName GiftID:(NSString *)giftID Name:(NSString *)giftName;
- (void)increaseCount:(int)number withCell: (GiftNoticeCellView *)cell;
    
@end
