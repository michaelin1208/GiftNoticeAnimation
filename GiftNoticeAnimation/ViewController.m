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
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" ReceiverID:@"111" Name:@"R111" GiftID:@"1111" Name:@"G1111" Count:@"1"];
}
- (IBAction)giftAG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"11" Name:@"S11" ReceiverID:@"111" Name:@"R111" GiftID:@"2222" Name:@"G2222" Count:@"1"];
}
- (IBAction)giftBG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" ReceiverID:@"111" Name:@"R111" GiftID:@"1111" Name:@"G1111" Count:@"1"];
}
- (IBAction)giftBG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" ReceiverID:@"111" Name:@"R111" GiftID:@"2222" Name:@"G2222" Count:@"1"];
}
- (IBAction)giftASG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" ReceiverID:@"111" Name:@"R111" GiftID:@"3333" Name:@"G3333" Count:@"1"];
}
- (IBAction)giftASG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSenderID:@"22" Name:@"S22" ReceiverID:@"111" Name:@"R111" GiftID:@"4444" Name:@"G4444" Count:@"1"];
}

- (IBAction)giftBSG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingMessagesWithSenderID:@"33" Name:@"S33" ReceiverID:@"333" Name:@"R333"Content:@"CCCCCCC11111"];
}
- (IBAction)giftBSG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingMessagesWithSenderID:@"44" Name:@"S44" ReceiverID:@"555" Name:@"R555"Content:@"CCCCCCC22222"];
}
@end
