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
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *giftName;

- (instancetype)initWithCell:(GiftNoticeCellView *)cell Sender:(NSString *)sender Gift:(NSString *)gift;
- (void)increaseCount:(int)number withCell: (GiftNoticeCellView *)cell;
    
@end
