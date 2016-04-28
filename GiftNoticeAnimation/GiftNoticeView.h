//
//  GiftNoticeView.h
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftNoticeView : UIView
- (void)insertWaitingMessagesWithSenderID:(NSString *)senderID Name: (NSString *)senderName ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName Content:(NSString *) content;
- (void)insertWaitingGiftNoticesWithSenderID:(NSString *)senderID Name: (NSString *)senderName ReceiverID:(NSString *)receiverID Name: (NSString *)receiverName GiftID: (NSString *)giftID Name:(NSString *)giftName Count:(NSString *)count;
@end
