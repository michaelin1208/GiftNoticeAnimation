//
//  GiftNoticeCellView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftNoticeCellView.h"

#define kGiftNoticeCellViewWeight 200
#define kGiftNoticeCellViewHeight 50
#define kGiftNoticeCellLabelWidth 100
#define kGiftNoticeCellLabelHeight 20
#define kRunDuration 0.5

@interface GiftNoticeCellView ()


@end

@implementation GiftNoticeCellView {
    UIView* backgroundView;
    CAAnimationGroup *appearAnimation;
    CAAnimationGroup *disappearAnimation;
    Boolean firstStep;
    
    CGPoint startPoint;
    CGPoint stayPoint;
    CGPoint endPoint;
    
    NSTimer
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        firstStep = YES;
        
        self.backgroundColor = [UIColor redColor];
        self.frame = CGRectMake(0, 0, kGiftNoticeCellViewWeight, kGiftNoticeCellViewHeight);
        self.giftSenderLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 4, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        self.giftNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 25, kGiftNoticeCellLabelWidth, kGiftNoticeCellLabelHeight)];
        [self addSubview: self.giftSenderLabel];
        [self addSubview: self.giftNameLabel];
        
//        self.layer.anchorPoint = CGPointMake(0, 0);
        
        
        
        
    }
    
    
    
    return self;
}

- (void)initAnimations{
    
    NSLog(@"x %f y %f", self.frame.origin.x, self.frame.origin.y);
    NSLog(@"width %f height %f", self.frame.size.width, self.frame.size.height);
    
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
}

- (void)refreshCellWithSender:(NSString *)name Gift:(NSString *)gift {
    self.giftSenderLabel.text = name;
    self.giftNameLabel.text = gift;
    
    self.hidden = NO;
    [self.layer addAnimation:appearAnimation forKey:@"appearAnimation"];
    self.layer.position = stayPoint;
    self.layer.opacity = 1.0;
    
    
    NSLog(@"x %f y %f", self.frame.origin.x, self.frame.origin.y);
    NSLog(@"width %f height %f", self.frame.size.width, self.frame.size.height);
}


- (void) animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

// 烟花的发射到固定点后 再调用爆炸的动画
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (firstStep){
        NSLog(@"MoveInAnimation end");
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(disappearAnimation) userInfo:nil repeats:NO];
    }else{
        self.hidden = YES;
        NSLog(@"MoveOutAnimation end");
        firstStep = YES;
    }
}

- (void) disappearAnimation{
    [self.layer addAnimation:disappearAnimation forKey:@"disappearAnimation"];
    self.layer.position = endPoint;
    self.layer.opacity = 0.0;
    firstStep = NO;
}

@end