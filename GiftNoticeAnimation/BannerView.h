//
//  BannerView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/28.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView:UIView

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *giftImageView;
@property (strong, nonatomic) UILabel *giftSenderLabel;
@property (strong, nonatomic) UILabel *giftNameLabel;
@property (strong, nonatomic) UILabel *countLabel;

- (instancetype)initWithSenderName:(NSString *)senderName ReceiverName:(NSString *)reveiverName GiftName:(NSString *)GiftName;
- (void)startAnimationWithSenderName:(NSString *)sName IconPath:(NSString *) sIconPath ReceiverName:(NSString *)rName GiftName:(NSString *)gName ImagePath:(NSString *)gImagePath Count:(NSString *)c InReceiver:(Boolean)isInReceiver;

@end
