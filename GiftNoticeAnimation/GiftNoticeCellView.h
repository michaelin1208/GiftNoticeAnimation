//
//  GiftNoticeCellView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftNoticeCellView : UIView

@property (strong, nonatomic) UILabel *giftSenderLabel;
@property (strong, nonatomic) UILabel *giftNameLabel;

@property (nonatomic) int cellID;

//+ (GiftNoticeCellView *)instanceGiftNoticeCellView;

- (void)refreshCellWithSender:(NSString *)name Gift:(NSString *)gift;
- (void)initAnimations;

@end
