//
//  GiftNoticeCellView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftNoticeCellView : UIView

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *giftSenderLabel;
@property (strong, nonatomic) UILabel *giftNameLabel;
@property (strong, nonatomic) UILabel *countLabel;

@property (nonatomic) int cellID;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *giftName;


@property (nonatomic) Boolean isUsable;
@property (nonatomic) Boolean isUsed;
@property (nonatomic) Boolean isDisappear;
@property (nonatomic) Boolean canDisappear;
@property (nonatomic) Boolean canKeepWaiting;

//+ (GiftNoticeCellView *)instanceGiftNoticeCellView;

- (void)initAnimations;
- (void)appearCellWithCount: (int)count Sender: (NSString *)name Gift:(NSString *)gift;
- (void)increaseCellWithCurrentCount: (int)cCount TargetCount: (int)tCount Sender: (NSString *)name Gift:(NSString *)gift;

- (void) startToWait;
- (void) disappearAnimation;

@end
