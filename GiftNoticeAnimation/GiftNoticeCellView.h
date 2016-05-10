//
//  GiftNoticeCellView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UserInfoManager.h"

@interface GiftNoticeCellView : UIView

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *giftImageView;
@property (strong, nonatomic) UIImageView *prizeImageView;
@property (strong, nonatomic) UIImageView *lightImageView;
@property (strong, nonatomic) UILabel *giftSenderLabel;
@property (strong, nonatomic) UILabel *giftNameLabel;
@property (strong, nonatomic) UILabel *countLabel;

@property (nonatomic) int cellID;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *senderIconPath;
@property (strong, nonatomic) NSString *giftID;
@property (strong, nonatomic) NSString *giftName;
@property (strong, nonatomic) NSString *giftImagePath;


@property (nonatomic) Boolean isUsable;
@property (nonatomic) Boolean isUsed;
@property (nonatomic) Boolean isDisappear;
@property (nonatomic) Boolean canDisappear;
@property (nonatomic) Boolean canKeepWaiting;

//+ (GiftNoticeCellView *)instanceGiftNoticeCellView;

- (void)initAnimations;
//- (void)appearCellWithCount: (int)count Sender: (NSString *)name Gift:(NSString *)gift;
- (void)increaseCellWithCurrentCount: (int)cCount TargetCount: (int)tCount SenderID: (NSString *)senderID Name: (NSString *)senderName IconPath: (NSString *)senderIconPath GiftID:(NSString *)giftID Name: (NSString *)giftName ImagePath: (NSString *)giftImagePath;

- (void) startToWait;
- (void) disappearAnimation;

@end
