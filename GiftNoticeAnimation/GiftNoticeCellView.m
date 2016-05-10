//
//  GiftNoticeCellView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftNoticeCellView.h"

#import "FireworkAnimation.h"
#import "Car.h"
//#import "UIImageView+WebCache.h"

#define kGiftNoticeCellLabelWidth 120
#define kGiftNoticeCellLabelHeight 13
#define kGiftMargin 5
#define kCountLabelWidth 30
#define kCountLabelHeight kCountLabelWidth
#define kRunDuration 0.3
#define kStayDuration 0.4


#define kPrizeScaleValue 0.83

#define kNormalGiftHeadBtnWidth 35
#define kNormalGiftHeadBtnHeight kNormalGiftHeadBtnWidth

#define kGiftImageViewWidth 50
#define kGiftImageViewHeight kGiftImageViewWidth


#define kCLDefaultHeadImage [UIImage imageNamed:@"Defaulthead"]
#define kChatNickNameColor [UIColor colorWithRed:255.0/255.0 green:175/255.0 blue:74/255.0 alpha:1]

@interface GiftNoticeCellView ()


@end

@implementation GiftNoticeCellView {
    UIView* backgroundView;
    CAAnimationGroup *appearAnimation;
    CAAnimationGroup *disappearAnimation;
    CABasicAnimation *lightAnimation;
    CABasicAnimation *increaseAnimation1;
    CABasicAnimation *increaseAnimation2;
    CABasicAnimation *increaseAnimation3;
    Boolean firstStep;
    
    CGPoint startPoint;
    CGPoint stayPoint;
    CGPoint endPoint;
    
    int waitingCount;
    
    int currentCount;
    int targetCount;
    
    int animationType;
    
    FireworkAnimation *fireworkAnimation;
    Car *car;
//    long waitingTimeInterval;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        firstStep = YES;
        _isDisappear = YES;
        _isUsable = YES;
        _isUsed = NO;
        
        //页面格式样式在这之后设置
        UIImage * bgImage = [UIImage imageNamed:@"chat_gift_animate_bg"];
        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.giftSenderLabel = [[UILabel alloc] initWithFrame: CGRectMake(42, 4, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        self.giftSenderLabel.textColor = kChatNickNameColor;
        self.giftSenderLabel.font = [UIFont boldSystemFontOfSize:12];
        self.giftNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(42, 17, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        self.giftNameLabel.textColor = [UIColor whiteColor];
        self.giftNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.countLabel = [[UILabel alloc] initWithFrame: CGRectMake(210, 0, kCountLabelWidth, kCountLabelHeight)];
        self.countLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.countLabel.font = [UIFont boldSystemFontOfSize:20];
        self.countLabel.textColor = [UIColor redColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        self.countLabel.adjustsFontSizeToFitWidth = YES;
//        self.countLabel.backgroundColor = [UIColor yellowColor];
        
        
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kNormalGiftHeadBtnWidth, kNormalGiftHeadBtnHeight)];
        [self.headImageView setImage:kCLDefaultHeadImage];
        self.headImageView.layer.cornerRadius = kNormalGiftHeadBtnHeight/2;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderWidth = 1.0;
        self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview: self.headImageView];
        
        
        self.lightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"light"]];
        float tempLightWidth = self.lightImageView.frame.size.width * kPrizeScaleValue;
        float tempLightHeight = self.lightImageView.frame.size.height * kPrizeScaleValue;
        self.lightImageView.frame = CGRectMake(self.headImageView.frame.size.width/2 - tempLightWidth/2, self.headImageView.frame.size.height/2 - tempLightHeight/2, tempLightWidth, tempLightHeight);
        [self addSubview:self.lightImageView];
        self.lightImageView.hidden = YES;
        
        self.prizeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"500"]];
        float tempPrizeWidth = self.prizeImageView.frame.size.width * kPrizeScaleValue;
        float tempPrizeHeight = self.prizeImageView.frame.size.height * kPrizeScaleValue;
        self.prizeImageView.frame = CGRectMake(self.headImageView.frame.size.width/2 - tempPrizeWidth/2, self.headImageView.frame.size.height/2 - tempPrizeHeight/2, tempPrizeWidth, tempPrizeHeight);
        [self addSubview:self.prizeImageView];
        self.prizeImageView.hidden = YES;
        
        
        self.giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.giftSenderLabel.frame.origin.x+self.giftSenderLabel.frame.size.width + kGiftMargin, self.frame.size.height - kGiftImageViewHeight, kGiftImageViewWidth, kGiftImageViewHeight)];
        [self.giftImageView setImage:kCLDefaultHeadImage];
        [self.giftImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview: self.giftImageView];
        
        
        [self addSubview: self.giftSenderLabel];
        [self addSubview: self.giftNameLabel];
        [self addSubview: self.countLabel];
        
        self.countLabel.hidden = YES;
        
        waitingCount = 0;
        currentCount = 0;
        targetCount = 0;
        
        _senderID = @"";
        _senderName = @"";
        _giftID = @"";
        _giftName = @"";
        
        car = [[Car alloc] init];
        fireworkAnimation = [[FireworkAnimation alloc] init];
        
        
    }
    
    
    
    return self;
}

//初始化动画
- (void)initAnimations{
    
    
//    self.layer.anchorPoint = CGPointMake(0, 0);
    
    startPoint = CGPointMake(-self.frame.size.width + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    stayPoint = CGPointMake(10 + self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    endPoint = CGPointMake(10 + self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y - 30 +self.frame.size.height / 2);
    
    //Move in animation
    //路径曲线
    UIBezierPath *movePath1 = [UIBezierPath bezierPath];
    [movePath1 moveToPoint:startPoint];
    [movePath1 addLineToPoint:stayPoint];
    
    //关键帧
    CAKeyframeAnimation *moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveInAnimation.path = movePath1.CGPath;
//    moveInAnimation.removedOnCompletion = NO;
//    moveInAnimation.duration = kRunDuration;
//    moveInAnimation.delegate = self;
    
    CABasicAnimation *opacityIncreaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityIncreaseAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityIncreaseAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    appearAnimation = [CAAnimationGroup animation];
    appearAnimation.animations = [NSArray arrayWithObjects:moveInAnimation, opacityIncreaseAnimation, nil];
    appearAnimation.duration = kRunDuration;
    appearAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    appearAnimation.removedOnCompletion = NO;
    appearAnimation.delegate = self;
    
    //Move out animation
    //路径曲线
    UIBezierPath *movePath2 = [UIBezierPath bezierPath];
    [movePath2 moveToPoint:stayPoint];
    [movePath2 addLineToPoint:endPoint];
    
    //关键帧
    CAKeyframeAnimation *moveOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveOutAnimation.path = movePath2.CGPath;
//    moveOutAnimation.removedOnCompletion = NO;
//    moveOutAnimation.duration = kRunDuration;
//    moveOutAnimation.delegate = self;
    
    CABasicAnimation *opacitydecreaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacitydecreaseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacitydecreaseAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    disappearAnimation = [CAAnimationGroup animation];
    disappearAnimation.animations = [NSArray arrayWithObjects:moveOutAnimation, opacitydecreaseAnimation, nil];
    disappearAnimation.duration = kRunDuration;
    disappearAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappearAnimation.removedOnCompletion = NO;
    disappearAnimation.delegate = self;
    
    
    //increase count animation
    increaseAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    increaseAnimation1.fromValue = [NSNumber numberWithFloat:6.0];
    //x，y轴缩小到0.1,Z 轴不变
    increaseAnimation1.toValue = [NSNumber numberWithFloat:1.0];
    //    increaseAnimation.removedOnCompletion = YES;
    increaseAnimation1.duration = 0.3f;
    increaseAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    increaseAnimation1.removedOnCompletion = NO;
    increaseAnimation1.fillMode = kCAFillModeForwards;
    increaseAnimation1.delegate = self;
    
    increaseAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    increaseAnimation2.fromValue = [NSNumber numberWithFloat:1.0];
    //x，y轴缩小到0.1,Z 轴不变
    increaseAnimation2.toValue = [NSNumber numberWithFloat:2.0];
    //    increaseAnimation.removedOnCompletion = YES;
    increaseAnimation2.duration = 0.2;
    increaseAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    increaseAnimation2.removedOnCompletion = NO;
    increaseAnimation2.fillMode = kCAFillModeForwards;
    increaseAnimation2.delegate = self;
    
    increaseAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    increaseAnimation3.fromValue = [NSNumber numberWithFloat:2.0];
    //x，y轴缩小到0.1,Z 轴不变
    increaseAnimation3.toValue = [NSNumber numberWithFloat:1.0];
    //    increaseAnimation.removedOnCompletion = YES;
    increaseAnimation3.duration = 0.2;
    increaseAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    increaseAnimation3.removedOnCompletion = NO;
    increaseAnimation3.fillMode = kCAFillModeForwards;
    increaseAnimation3.delegate = self;
    
    
    lightAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    lightAnimation.duration = 2; // 持续时间
    lightAnimation.repeatCount = 0; // 重复次数
    lightAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    lightAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
}

//显示中奖500倍动画
- (void)showPrizeAnimation{
    self.prizeImageView.hidden = NO;
    self.lightImageView.hidden = NO;
    [self.lightImageView.layer addAnimation:lightAnimation forKey:@"lightAnimation"];
//    self start
}

//隐藏中奖500倍动画
- (void)hiddenPrizeAnimation{
    self.prizeImageView.hidden = YES;
    self.lightImageView.hidden = YES;
    [self.lightImageView.layer removeAllAnimations];
}

//增加礼物计数 考虑是否在增加数量的动画中，增加动画中就只增加最终数字，不开始动画
- (void)increaseCellWithCurrentCount: (int)cCount TargetCount: (int)tCount SenderID: (NSString *)senderID Name: (NSString *)senderName IconPath: (NSString *)senderIconPath GiftID:(NSString *)giftID Name: (NSString *)giftName ImagePath: (NSString *)giftImagePath{
    
//    NSLog(@"SENDER %@ GIFT %@ COUNT %d", senderID, giftID, tCount);
//    currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    if([senderID isEqualToString:_senderID] && [giftID isEqualToString:_giftID] && !_isDisappear){
        if (_isUsable) {
//            NSLog(@"AAAAAAAAAAAAAAA");
            currentCount = cCount;
            targetCount = tCount;
            [self increaseAnimation];
        }else{
//            NSLog(@"BBBBBBBBBBBBBBB");
            targetCount = tCount;
        }
    }else{
//        NSLog(@"CCCCCCCCCCCCCCCC");
        _senderID = senderID;
        _senderName = senderName;
        _senderIconPath = senderIconPath;
        _giftID = giftID;
        _giftName = giftName;
        _giftImagePath = giftImagePath;
        currentCount = cCount;
        targetCount = tCount;
        self.giftSenderLabel.text = _senderName;
        self.giftNameLabel.text = _giftName;
        
        if ([_senderIconPath rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
            _senderIconPath = [@"http://" stringByAppendingString:_senderIconPath];
        }
        
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_senderIconPath] placeholderImage:kCLDefaultHeadImage];
//        
//        [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserInfoManager getInstance].baseConfig.itemPicRootUrl,_giftImagePath]]];
        
        [self.headImageView setImage: kCLDefaultHeadImage];
        [self.giftImageView setImage: kCLDefaultHeadImage];
        
        [self appearAnimation];
    }
    
    
}


- (void) animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animation start");
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.layer animationForKey:@"appearAnimation"]) {
        //appearAnimation finished
//            _isUsable = YES;
        [self increaseAnimation];
    }else if (anim == [self.countLabel.layer animationForKey:@"increaseAnimation1"]) {
        //increaseAnimation1 finished
//        NSLog(@"cellid %d sleep %d", _cellID, currentCount);
        [self.countLabel.layer addAnimation:increaseAnimation2 forKey:@"increaseAnimation2"];
    }else if (anim == [self.countLabel.layer animationForKey:@"increaseAnimation2"]) {
        //increaseAnimation2 finished
//        NSLog(@"cellid %d sleep %d", _cellID, currentCount);
        [self.countLabel.layer addAnimation:increaseAnimation3 forKey:@"increaseAnimation3"];
    }else if (anim == [self.countLabel.layer animationForKey:@"increaseAnimation3"]) {
        //increaseAnimation3 finished
//        NSLog(@"cellid %d sleep %d", _cellID, currentCount);
        [self increaseAnimation];
//                [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(increaseAnimation) userInfo:nil repeats:NO];
    }else if (anim == [self.layer animationForKey:@"disappearAnimation"]) {
        //disappearAnimation finished
        
        [self hiddenPrizeAnimation];

        self.hidden = YES;
        self.countLabel.hidden = YES;
        _isUsable = YES;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmDisappeared" object:[NSNumber numberWithInt:_cellID]];
    }
}

- (void) didStopAppearAnimation{
    
    //appearAnimation finished
    //            _isUsable = YES;
    [self increaseAnimation];
}

- (void) didStopIncreaseAnimation{
    //increaseAnimation finished
//    NSLog(@"cellid %d sleep %d", _cellID, currentCount);
    [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(increaseAnimation) userInfo:nil repeats:NO];

}

- (void) didStopDisappearAnimation{
    //disappearAnimation finished
    
    self.hidden = YES;
    self.countLabel.hidden = YES;
    _isUsable = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmDisappeared" object:[NSNumber numberWithInt:_cellID]];

    
}

//普通礼物界面出现动画
- (void) appearAnimation{
    _isUsable = NO;
    animationType = 0;
    _isDisappear = NO;
    self.hidden = NO;
    self.countLabel.hidden = YES;
    [self.layer removeAllAnimations];
    [self.countLabel.layer removeAllAnimations];
    [self.layer addAnimation:appearAnimation forKey:@"appearAnimation"];
    self.layer.position = stayPoint;
    self.layer.opacity = 1.0;
//    [self checkGiftType:_giftName];
}

//普通礼物礼物数字增加动画
- (void) increaseAnimation{
//    NSLog(@"cellid %d wake %d", _cellID, currentCount);
    if (currentCount < targetCount) {
//        NSLog(@"increaseAnimation in Cell %d ",_cellID);
        _isUsable = NO;
        animationType = 1;
        currentCount++;
        self.hidden = NO;
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"X%d", currentCount];
        [self.countLabel sizeToFit];
        [self.layer removeAllAnimations];
        [self.countLabel.layer removeAllAnimations];
        [self.countLabel.layer addAnimation:increaseAnimation1 forKey:@"increaseAnimation1"];
        firstStep = NO;
        
        
//        [self showPrizeAnimation];
        
    }else{
//        waitingTimeInterval = [[NSDate date] timeIntervalSince1970]; // record
        _isUsable = YES;
//        waitingCount ++;
        _canKeepWaiting = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmWaiting" object:[NSNumber numberWithInt:_cellID]];
        
    }
}


//礼物窗口消失动画
- (void) disappearAnimation{
    if (_isUsable) {
        _isUsable = NO;
        animationType = 2;
        _isDisappear = YES;
        [self.layer removeAllAnimations];
        [self.countLabel.layer removeAllAnimations];
        [self.layer addAnimation:disappearAnimation forKey:@"disappearAnimation"];
        self.layer.position = endPoint;
        self.layer.opacity = 0.0;
    }else{
        _canDisappear = NO;
    }
}


- (void)checkGiftType:(NSString *)gift{
    if ([gift isEqualToString:@"firework"]) {
        [fireworkAnimation startAnimationAtView:self.superview.superview];
    }else if ([gift isEqualToString:@"car"]) {
        [car startAnimationAtView:self.superview.superview];
    }
}

- (void) startToWait{
    waitingCount++;
    [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(endWaiting) userInfo:nil repeats:NO];
}

- (void) endWaiting{
    waitingCount--;
    if (waitingCount <= 0) {
        if (_isUsable) {
//            NSLog(@"send IWantToDisappear");
            _canDisappear = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IWantToDisappear" object:[NSNumber numberWithInt:_cellID]];
        }
    }
}

- (Boolean) noMore{
    if (currentCount < targetCount) {
        return NO;
    }else{
        return YES;
    }
}



@end