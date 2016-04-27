//
//  Car.m
//  Animation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "Car.h"

const static CFTimeInterval runDuration = 2;

@interface Car ()


@end

@implementation Car {
    int step;
    CALayer *sublayer1;
    CALayer *sublayer2;
    CGPoint startPoint1;
    CGPoint endPoint1;
    CGPoint startPoint2;
    CGPoint endPoint2;
    NSMutableArray *animations;
    UIView *backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        step = 0;
        animations = [[NSMutableArray alloc] init];
        startPoint1 = CGPointMake(320, 0);
        endPoint1 = CGPointMake(0, 320);
        startPoint2 = CGPointMake(320, 320);
        endPoint2 = CGPointMake(0, 0);
    }
    return self;
}

- (void)startAnimationAtView: (UIView *)currentView {
    
    backgroundView = currentView;
    
    // Car image 1 for first half animation
    sublayer1 =[CALayer layer];
    
    sublayer1.backgroundColor =[UIColor orangeColor].CGColor;
    sublayer1.shadowOffset = CGSizeMake(0, 3);
    sublayer1.shadowRadius =5.0;
    sublayer1.shadowColor =[UIColor blackColor].CGColor;
    sublayer1.shadowOpacity = 1;
    
    sublayer1.borderColor =[UIColor blackColor].CGColor;
    sublayer1.borderWidth =2.0;
    sublayer1.cornerRadius =10.0;
    sublayer1.anchorPoint = CGPointMake(0.5, 0.5);
    [backgroundView.layer addSublayer:sublayer1];
    
    CGImageRef img1 = [UIImage imageNamed:@"QQ20160425-0.png"].CGImage;
    sublayer1.contents = (__bridge id)img1;
    sublayer1.frame = CGRectMake(0, 0, CGImageGetWidth(img1), CGImageGetWidth(img1));
//    sublayer1.position = startPoint1;
    
    //Part 1 animation
    //路径曲线
    UIBezierPath *movePath1 = [UIBezierPath bezierPath];
    [movePath1 moveToPoint:startPoint1];
    [movePath1 addLineToPoint:endPoint1];
    
    //关键帧
    CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim1.path = movePath1.CGPath;
    moveAnim1.removedOnCompletion = NO;
    moveAnim1.duration = runDuration;
    moveAnim1.delegate = self;
    
    [animations addObject:moveAnim1];
    
    // Car image 2 for next animation
    sublayer2 =[CALayer layer];
    
    sublayer2.backgroundColor =[UIColor orangeColor].CGColor;
    sublayer2.shadowOffset = CGSizeMake(0, 3);
    sublayer2.shadowRadius =5.0;
    sublayer2.shadowColor =[UIColor blackColor].CGColor;
    sublayer2.shadowOpacity = 1;
    
    sublayer2.borderColor =[UIColor blackColor].CGColor;
    sublayer2.borderWidth =2.0;
    sublayer2.cornerRadius =10.0;
    sublayer2.anchorPoint = CGPointMake(0.5, 0.5);
    [backgroundView.layer addSublayer:sublayer2];
    
    CGImageRef img2 = [UIImage imageNamed:@"QQ20160425-0.png"].CGImage;
    sublayer2.contents = (__bridge id)img2;
    sublayer2.frame = CGRectMake(0, 0, CGImageGetWidth(img2), CGImageGetWidth(img2));
//    sublayer2.position = startPoint2;
    
    //Part 2 animation
    //路径曲线
    UIBezierPath *movePath2 = [UIBezierPath bezierPath];
    [movePath2 moveToPoint:startPoint2];
    [movePath2 addLineToPoint:endPoint2];
    
    //关键帧
    CAKeyframeAnimation *moveAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim2.path = movePath2.CGPath;
    moveAnim2.removedOnCompletion = NO;
    moveAnim2.duration = runDuration;
    moveAnim2.delegate = self;
    
    [animations addObject:moveAnim2];
    
    sublayer1.hidden = false;
    sublayer2.hidden = true;
    [sublayer1 addAnimation:moveAnim1 forKey:nil];
    sublayer1.position = endPoint1;
    step = 1;
    
    
}

- (void) animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

// 烟花的发射到固定点后 再调用爆炸的动画
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAKeyframeAnimation *tempAnimation = [animations objectAtIndex:step];
    NSLog(@"step %d", step);
    if(step == 0){
//        sublayer1.position = startPoint1;
        sublayer1.hidden = false;
        sublayer2.hidden = true;
        [sublayer1 addAnimation:tempAnimation forKey:nil];
        sublayer1.position = endPoint1;
        step = 1;
    }else{
//        sublayer2.position = startPoint2;
        sublayer1.hidden = true;
        sublayer2.hidden = true;
//        [sublayer2 addAnimation:tempAnimation forKey:nil];
        sublayer2.position = endPoint2;
        
        step = 0;
    }
}
@end

