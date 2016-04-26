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
#define kRunDuration 1
#define kStayDuration 1

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
    
    int count;
    
    int currentCount;
    int targetCount;
    
    
    long currentTimeInterval;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        firstStep = YES;
        _isDisappear = NO;
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
//        self.countLabel.text = @"X60";
        
//        self.layer.anchorPoint = CGPointMake(0, 0);
        count = 0;
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

//- (void)appearCellWithCount: (int)count Sender: (NSString *)name Gift:(NSString *)gift {
//    
//    //    currentTimeInterval = [[NSDate date] timeIntervalSince1970];
//    
//    self.giftSenderLabel.text = name;
//    self.giftNameLabel.text = gift;
//    
//    [self appearAnimation];
//    
//}

- (void)increaseCellWithCurrentCount: (int)cCount TargetCount: (int)tCount Sender: (NSString *)sender Gift:(NSString *)gift {
    currentCount = cCount;
    targetCount = tCount;
    
//    currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    if([sender isEqualToString:_senderName] && [gift isEqualToString:_giftName] && !_isDisappear){
        NSLog(@"same same");
        [self increaseAnimation];
    }else{
        _senderName = sender;
        _giftName = gift;
        NSLog(@"different different");
        self.giftSenderLabel.text = _senderName;
        self.giftNameLabel.text = _giftName;
        [self appearAnimation];
    }
    
    
}


- (void) animationDidStart:(CAAnimation *)anim
{
    _isUsable = NO;
    NSLog(@"animation start");
}

// 烟花的发射到固定点后 再调用爆炸的动画
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (firstStep){
        _isUsable = YES;
        NSLog(@"increaseAnimation");
        [self increaseAnimation];
        
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(disappearAnimation) userInfo:nil repeats:NO];
        
    }else{
        if (_isDisappear){
            _isUsable = YES;
            self.hidden = YES;
            self.countLabel.hidden = YES;
            NSLog(@"MoveOutAnimation end");
            firstStep = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallNextNotice" object:[NSNumber numberWithInt:_cellID]];
        }else{
            
            [NSTimer scheduledTimerWithTimeInterval:kStayDuration target:self selector:@selector(increaseAnimation) userInfo:nil repeats:NO];
        }
    }
}

- (void) increaseAnimation{
    _isUsable = YES;
    _isDisappear = NO;
    if (currentCount < targetCount) {
        currentCount++;
        self.hidden = NO;
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"X%d", currentCount];
        [self.countLabel sizeToFit];
        [self.countLabel.layer addAnimation:increaseAnimation forKey:@"increaseAnimation"];
        firstStep = NO;
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WantDisappearMyself" object:[NSNumber numberWithInt:_cellID]];
    }
}

- (void) appearAnimation{
    _isDisappear = NO;
    self.hidden = NO;
    self.countLabel.hidden = YES;
//    _isUsable = NO;
    [self.layer addAnimation:appearAnimation forKey:@"appearAnimation"];
    self.layer.position = stayPoint;
    self.layer.opacity = 1.0;
}

- (void) disappearAnimation{
    count --;
    NSLog(@"count %d", count);
    if (count == 0) {
        _isDisappear = YES;
//        _isUsable = NO;
        [self.layer addAnimation:disappearAnimation forKey:@"disappearAnimation"];
        self.layer.position = endPoint;
        self.layer.opacity = 0.0;
        firstStep = NO;
    }
}

- (void)startToDisappear{
    count ++;
    NSLog(@"count %d", count);
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(disappearAnimation) userInfo:nil repeats:NO];
}


@end