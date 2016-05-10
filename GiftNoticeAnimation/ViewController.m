//
//  ViewController.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "ViewController.h"
#import "GiftNoticeView.h"

@interface ViewController ()

@end

@implementation ViewController{
    GiftNoticeView *giftNoticeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    giftNoticeView = [[GiftNoticeView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 360)];
    [self.view addSubview:giftNoticeView];
    
//    NSLog(@"giftNoticeView width %f height %f", giftNoticeView.frame.size.width, giftNoticeView.frame.size.height);
    
//    giftNoticeView.frame = CGRectMake(0, 300, giftNoticeView.frame.size.width, giftNoticeView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)giftAG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" IconPath:@"path1" ReceiverID:@"111" Name:@"R111" GiftID:@"1111" Name:@"G1111" ImagePath:@"path2" Count:@"1" SuperGift:NO];
}
- (IBAction)giftAG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" IconPath:@"path1" ReceiverID:@"111" Name:@"R111" GiftID:@"2222" Name:@"G2222" ImagePath:@"path2" Count:@"1" SuperGift:NO];
}
- (IBAction)giftBG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" IconPath:@"path1" ReceiverID:@"111" Name:@"R111" GiftID:@"1111" Name:@"G1111" ImagePath:@"path2" Count:@"1" SuperGift:NO];
}
- (IBAction)giftBG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" IconPath:@"path1" ReceiverID:@"111" Name:@"R111" GiftID:@"2222" Name:@"G2222" ImagePath:@"path2" Count:@"1" SuperGift:NO];
}
- (IBAction)giftASG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" IconPath:@"path1" ReceiverID:@"111" Name:@"R111" GiftID:@"1111" Name:@"SG1111" ImagePath:@"path2" Count:@"1" SuperGift:YES];
}
- (IBAction)giftASG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" IconPath:@"path1" ReceiverID:@"222" Name:@"R222" GiftID:@"1111" Name:@"SG1111" ImagePath:@"path2" Count:@"1" SuperGift:YES];
}

- (IBAction)giftBSG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingMessagesWithSenderID:@"44" Name:@"S44" IconPath:@"PATH1" ReceiverID:@"1111" Name:@"R1111" Content:@"CCCCCCCCCCCCCCCCCCCCC444444444444444"];
}
- (IBAction)giftBSG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingMessagesWithSenderID:@"55" Name:@"S55" IconPath:@"PATH2" ReceiverID:@"2222" Name:@"R2222" Content:@"CCCCCCCCCCCCCCCCCCCCC555555555555555555555555555555"];
}
@end
