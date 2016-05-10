//
//  BannerView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/28.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "BannerView.h"
//#import "UserInfoManager.h"
//#import "UIImageView+WebCache.h"
#define kBannerViewLabelWidth 120
#define kBannerViewLabelHeight 13

#define kCountLabelWidth 30
#define kCountLabelHeight kCountLabelWidth

#define kBannerViewHeadBtnWidth 35
#define kBannerViewHeadBtnHeight kBannerViewHeadBtnWidth

#define kBannerViewGiftImageViewWidth 40
#define kBannerViewGiftImageViewHeight kBannerViewGiftImageViewWidth

#define kGiftImageViewWidth 60
#define kGiftImageViewHeight kGiftImageViewWidth

#define kGiftMargin 5

#define kCLDefaultHeadImage [UIImage imageNamed:@"Defaulthead"]

#define kShortStayDuration 0.5
#define kLongStayDuration 1
#define kMoveDuration 2

@interface BannerView ()


@end

@implementation BannerView {
    NSString *senderName;
    NSString *senderIconPath;
    NSString *receiverName;
    NSString *giftName;
    NSString *giftImagePath;
    NSString *count;
    int stayDuration;
    
    CGPoint startPoint;
    CGPoint stayPoint;
    CGPoint endPoint;
    
    CAKeyframeAnimation *moveInAnimation;
    CAKeyframeAnimation *moveOutAnimation;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //上方超级礼物的页面样式
        UIImage * bgImage = [UIImage imageNamed:@"chat_gift_animate_bg"];
        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.giftSenderLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 4, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.giftSenderLabel.textColor = [UIColor yellowColor];
        self.giftSenderLabel.font = [UIFont boldSystemFontOfSize:12];
        self.giftNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 17, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.giftNameLabel.textColor = [UIColor yellowColor];
        self.giftNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.countLabel = [[UILabel alloc] initWithFrame: CGRectMake(210, 0, kCountLabelWidth, kCountLabelHeight)];
        self.countLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.countLabel.font = [UIFont boldSystemFontOfSize:20];
        self.countLabel.textColor = [UIColor redColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBannerViewHeadBtnWidth, kBannerViewHeadBtnHeight)];
        [self.headImageView setImage:kCLDefaultHeadImage];
        self.headImageView.layer.cornerRadius = kBannerViewHeadBtnHeight/2;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderWidth = 1.0;
        self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview: self.headImageView];
        
        self.giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.giftSenderLabel.frame.origin.x+self.giftSenderLabel.frame.size.width + kGiftMargin, self.frame.size.height - kGiftImageViewHeight, kGiftImageViewWidth, kGiftImageViewHeight)];
        [self.giftImageView setImage:kCLDefaultHeadImage];
        [self.giftImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview: self.giftImageView];
        [self addSubview: self.giftSenderLabel];
        [self addSubview: self.giftNameLabel];
        [self addSubview: self.countLabel];
        
        
    }
    return self;
}

- (void)initAnimation{
    startPoint = CGPointMake(self.superview.frame.size.width + self.frame.size.width/2, self.frame.size.height/2 + 20);
    stayPoint = CGPointMake(self.superview.frame.size.width/2, self.frame.size.height/2 + 20);
    endPoint = CGPointMake(0 - self.frame.size.width/2, self.frame.size.height/2 + 20);;
    
    //Part 1 animation
    //路径曲线
    UIBezierPath *moveInPath = [UIBezierPath bezierPath];
    [moveInPath moveToPoint:startPoint];
    [moveInPath addLineToPoint:stayPoint];
    
    //关键帧
    moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveInAnimation.path = moveInPath.CGPath;
    moveInAnimation.removedOnCompletion = NO;
    moveInAnimation.duration = kMoveDuration;
    moveInAnimation.delegate = self;
    
    
    //Part 2 animation
    //路径曲线
    UIBezierPath *moveOutPath = [UIBezierPath bezierPath];
    [moveOutPath moveToPoint:stayPoint];
    [moveOutPath addLineToPoint:endPoint];
    
    //关键帧
    moveOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveOutAnimation.path = moveOutPath.CGPath;
    moveOutAnimation.removedOnCompletion = NO;
    moveOutAnimation.duration = kMoveDuration;
    moveOutAnimation.delegate = self;
}

//开始移动入场动画，isInReceiver来确认是否为在自己的直播间，是的话停留时间更长
- (void)startAnimationWithSenderName:(NSString *)sName IconPath:(NSString *) sIconPath ReceiverName:(NSString *)rName GiftName:(NSString *)gName ImagePath:(NSString *)gImagePath Count:(NSString *)c InReceiver:(Boolean)isInReceiver{
    
    if (moveInAnimation == nil || moveOutAnimation == nil) {
        [self initAnimation];
    }
    
    senderName = sName;
    senderIconPath = sIconPath;
    receiverName = rName;
    giftName = gName;
    giftImagePath = gImagePath;
    count = c;
    
    self.giftSenderLabel.text = senderName;
    self.giftNameLabel.text = [NSString stringWithFormat:@"送给 %@ %@", receiverName, giftName];
    self.countLabel.text = [NSString stringWithFormat:@"X %@", count];
    [self.countLabel sizeToFit];
    
    
    if ([senderIconPath rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        senderIconPath = [@"http://" stringByAppendingString:senderIconPath];
    }
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:senderIconPath] placeholderImage:kCLDefaultHeadImage];
//    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserInfoManager getInstance].baseConfig.itemPicRootUrl,giftImagePath]]];
    [self.headImageView setImage:kCLDefaultHeadImage];
    [self.giftImageView setImage:kCLDefaultHeadImage];
    
    if (isInReceiver) {
        stayDuration = kLongStayDuration;
    }else{
        stayDuration = kShortStayDuration;
    }
    
    [self startMoveIn];
}

-(void)startMoveIn{
    self.hidden = NO;
    self.layer.position = startPoint;
    [self.layer addAnimation:moveInAnimation forKey:@"MoveIn"];
    self.layer.position = stayPoint;
}

-(void)startMoveOut{
    self.layer.position = stayPoint;
    [self.layer addAnimation:moveOutAnimation forKey:@"MoveOut"];
    self.layer.position = endPoint;
}

- (void) animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animation start");
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([self.layer animationForKey:@"MoveIn"] == anim){
        [NSTimer scheduledTimerWithTimeInterval:stayDuration target:self selector:@selector(startMoveOut) userInfo:nil repeats:NO];
    }else if([self.layer animationForKey:@"MoveOut"] == anim){
        self.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerFinished" object:nil userInfo:nil];
    }
}


@end

