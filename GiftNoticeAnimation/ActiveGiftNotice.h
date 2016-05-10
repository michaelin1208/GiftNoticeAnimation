//
//  ActiveGiftNotice.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/26.
//  Copyright © 2016年 9158. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GiftNoticeCellView.h"
#import "BannerView.h"

@interface ActiveGiftNotice : NSObject

//+ (GiftNoticeCellView *)instanceGiftNoticeCellView;
//@property (nonatomic) isShown;
@property (strong, nonatomic) GiftNoticeCellView *allocatedCell;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *senderIconPath;
@property (strong, nonatomic) NSString *receiverID;
@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *giftID;
@property (strong, nonatomic) NSString *giftName;
@property (strong, nonatomic) NSString *giftImagePath;
@property (nonatomic) long updateTime;

- (instancetype)initWithSenderID:(NSString *)senderID Name:(NSString *)senderName IconPath:(NSString *)senderIconPath ReceiverID:(NSString *)receiverID name:(NSString *)receiverName GiftID:(NSString *)giftID Name:(NSString *)giftName ImagePath:(NSString *)giftImagePath;
- (void)increaseCount:(int)number withGiftNoticeCell: (GiftNoticeCellView *)cell;
- (void)increaseCount:(int)number withBannerCell: (BannerView *)cell;
    
@end
