//
//  MessageView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/28.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView:UIView

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *giftImageView;
@property (strong, nonatomic) UILabel *senderLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *countLabel;

@property (nonatomic) int cellID;

//- (instancetype)initWithSenderName:(NSString *)senderName ReceiverName:(NSString *)reveiverName GiftName:(NSString *)GiftName;
- (void)startAnimationWithSenderName:(NSString *)sName IconPath:(NSString *) sIconPath ReceiverName:(NSString *)rName Content:(NSString *)con;

@end