//
//  GiftNoticeCellView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftNoticeCellView.h"

#define kGiftNoticeCellViewWidth 200
#define kGiftNoticeCellViewHeight 50
#define kGiftNoticeCellLabelWidth 100
#define kGiftNoticeCellLabelHeight 20
#define kCountLabelWidth 40
#define kCountLabelHeight 40
#define kRunDuration 0.5
#define kStayDuration 0.5

@interface GiftNoticeCellView ()


@end

@implementation GiftNoticeCellView {
    UIView* backgroundView;
    CAAnimationGroup *appearAnimation;
    CAAnimationGroup *disappearAnimation;
    CABasicAnimation *increaseAnimation;
    Boolean firstStep;
    
    CGPoint startPoint;
    CGPoint stayPoint;
    CGPoint endPoint;
    
    int waitingCount;
    
    int currentCount;
    int targetCount;
    
    int animationType;
    
//    long waitingTimeInterval;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        firstStep = YES;
        _isDisappear = YES;
        _isUsable = YES;
        self.backgroundColor = [UIColor redColor];
        self.frame = CGRectMake(0, 0, kGiftNoticeCellViewWidth, kGiftNoticeCellViewHeight);
        self.giftSenderLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 4, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        self.giftNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 25, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        self.countLabel = [[UILabel alloc] initWithFrame: CGRectMake(kGiftNoticeCellViewWidth - kCountLabelWidth - (kGiftNoticeCellViewHeight - kCountLabelHeight)/2, (kGiftNoticeCellViewHeight - kCountLabelHeight)/2, kCountLabelWidth, kCountLabelHeight)];
        self.countLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.countLabel.font = [UIFont boldSystemFontOfSize:32];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        self.countLabel.adjustsFontSizeToFitWidth = YES;
        self.countLabel.backgroundColor = [UIColor yellowColor];
        
        [self addSubview: self.giftSenderLabel];
        [self addSubview: self.giftNameLabel];
        [self addSubview:self.countLabel];
        
        self.countLabel.hidden = YES;
        
        waitingCount = 0;
        currentCount = 0;
        targetCount = 0;
        
        _senderName = @"";
        _giftName = @"";
        
        
    }
    
    
    
    return self;
}

- (void)initAnimations{
    
    
//    self.layer.anchorPoint = CGPointMake(0, 0);
    
    startPoint = CGPointMake(-self.frame.size.width + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    stayPoint = CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    endPoint = CGPointMake(-self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y - 30 +self.frame.size.height / 2);
    
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
    disappearAnimation.delegate = self;
    
    
    //increase count animation
    increaseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    increaseAnimation.fromValue = [NSNumber numberWithFloat:3.0];
    //x，y轴缩小到0.1,Z 轴不变
    increaseAnimation.toValue = [NSNumber numberWithFloat:1.0];
    increaseAnimation.duration = kStayDuration;
    increaseAnimation.delegate = self;
}

- (void)increaseCellWithCurrentCount: (int)cCount TargetCount: (int)tCount Sender: (NSString *)sender Gift:(NSString *)gift {
    
//    currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    if([sender isEqualToString:_senderName] && [gift isEqualToString:_giftName] && !_isDisappear){
        if (_isUsable) {
            currentCount = cCount;
            targetCount = tCount;
            [self increaseAnimation];
        }else{
            targetCount = tCount;
        }
    }else{
        _senderName = sender;
        _giftName = gift;
        currentCount = cCount;
        targetCount = tCount;
        self.giftSenderLabel.text = _senderName;
        self.giftNameLabel.text = _giftName;
        [self appearAnimation];
    }
    
    
}


- (void) animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch (animationType) {
        case 0:
            //appearAnimation finished
            _isUsable = YES;
            [self increaseAnimation];
            break;
        case 1:
            //increaseAnimation finished
            [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(increaseAnimation) userInfo:nil repeats:NO];
            break;
        case 2:
            //disappearAnimation finished
            
            self.hidden = YES;
            self.countLabel.hidden = YES;
            _isUsable = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmDisappeared" object:[NSNumber numberWithInt:_cellID]];
            
            break;
            
        default:
            break;
    }
}

- (void) appearAnimation{
    _isUsable = NO;
    animationType = 0;
    _isDisappear = NO;
    self.hidden = NO;
    self.countLabel.hidden = YES;
    [self.layer addAnimation:appearAnimation forKey:@"appearAnimation"];
    self.layer.position = stayPoint;
    self.layer.opacity = 1.0;
}

- (void) increaseAnimation{
    if (currentCount < targetCount) {
        _isUsable = NO;
        animationType = 1;
        currentCount++;
        self.hidden = NO;
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"X%d", currentCount];
        [self.countLabel sizeToFit];
        [self.countLabel.layer addAnimation:increaseAnimation forKey:@"increaseAnimation"];
        firstStep = NO;
    }else{
//        waitingTimeInterval = [[NSDate date] timeIntervalSince1970]; // record
        _isUsable = YES;
//        waitingCount ++;
        _canKeepWaiting = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmWaiting" object:[NSNumber numberWithInt:_cellID]];
        
    }
}

- (void) startToWait{
    waitingCount++;
    [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(endWaiting) userInfo:nil repeats:NO];
}

- (void) endWaiting{
    waitingCount--;
    if (waitingCount <= 0) {
        NSLog(@"send IWantToDisappear");
        _canDisappear = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IWantToDisappear" object:[NSNumber numberWithInt:_cellID]];
    }
}

- (void) disappearAnimation{
    _isUsable = NO;
    animationType = 2;
    _isDisappear = YES;
    [self.layer addAnimation:disappearAnimation forKey:@"disappearAnimation"];
    self.layer.position = endPoint;
    self.layer.opacity = 0.0;
}

- (Boolean) noMore{
    if (currentCount < targetCount) {
        return NO;
    }else{
        return YES;
    }
}



@end