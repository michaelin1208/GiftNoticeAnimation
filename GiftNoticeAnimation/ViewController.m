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
    
    giftNoticeView = [[GiftNoticeView alloc] init];
    [self.view addSubview:giftNoticeView];
    
//    NSLog(@"giftNoticeView width %f height %f", giftNoticeView.frame.size.width, giftNoticeView.frame.size.height);
    
    giftNoticeView.frame = CGRectMake(0, 300, giftNoticeView.frame.size.width, giftNoticeView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)giftAG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
//    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G1" Count:@"1"];
}
- (IBAction)giftAG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSender:@"A" Gift:@"G2" Count:@"1"];
}
- (IBAction)giftBG1tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G1" Count:@"1"];
}
- (IBAction)giftBG2tnTouched:(id)sender {
    [giftNoticeView insertWaitingGiftNoticesWithSender:@"B" Gift:@"G2" Count:@"1"];
}

@end
