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
    CALayer *moveInLayer;
    CALayer *moveOutLayer;
    CGPoint startPoint1;
    CGPoint endPoint1;
    CGPoint startPoint2;
    CGPoint endPoint2;
//    NSMutableArray *animations;
    UIView *backgroundView;
    CAKeyframeAnimation *moveInAnimation;
    CAKeyframeAnimation *moveOutAnimation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        animations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startAnimationAtView: (UIView *)currentView {
    
    backgroundView = currentView;
    
    // Car image 1 for first half animation
    moveInLayer =[CALayer layer];
    
    moveInLayer.backgroundColor =[UIColor orangeColor].CGColor;
    moveInLayer.shadowOffset = CGSizeMake(0, 3);
    moveInLayer.shadowRadius =5.0;
    moveInLayer.shadowColor =[UIColor blackColor].CGColor;
    moveInLayer.shadowOpacity = 1;
    
    moveInLayer.borderColor =[UIColor blackColor].CGColor;
    moveInLayer.borderWidth =2.0;
    moveInLayer.cornerRadius =10.0;
    moveInLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [backgroundView.layer addSublayer:moveInLayer];
    
    CGImageRef img1 = [UIImage imageNamed:@"QQ20160425-0.png"].CGImage;
    moveInLayer.contents = (__bridge id)img1;
    moveInLayer.frame = CGRectMake(0, 0, CGImageGetWidth(img1), CGImageGetWidth(img1));
//    moveInLayer.position = startPoint1;
    
    
    
    startPoint1 = CGPointMake(backgroundView.frame.size.width+moveInLayer.frame.size.width/2, -moveInLayer.frame.size.height/2);
    endPoint1 = CGPointMake(-moveInLayer.frame.size.width/2, backgroundView.frame.size.width + moveInLayer.frame.size.width-moveInLayer.frame.size.height/2);
    startPoint2 = CGPointMake(backgroundView.frame.size.width + moveInLayer.frame.size.width/2, backgroundView.frame.size.width + moveInLayer.frame.size.width-moveInLayer.frame.size.height/2);
    endPoint2 = CGPointMake(-moveInLayer.frame.size.width/2, -moveInLayer.frame.size.height/2);
    
    //Part 1 animation
    //路径曲线
    UIBezierPath *movePath1 = [UIBezierPath bezierPath];
    [movePath1 moveToPoint:startPoint1];
    [movePath1 addLineToPoint:endPoint1];
    
    //关键帧
    moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveInAnimation.path = movePath1.CGPath;
    moveInAnimation.removedOnCompletion = NO;
    moveInAnimation.duration = runDuration;
    moveInAnimation.delegate = self;
    
//    [animations addObject:moveInAnimation];
    
    // Car image 2 for next animation
    moveOutLayer =[CALayer layer];
    
    moveOutLayer.backgroundColor =[UIColor orangeColor].CGColor;
    moveOutLayer.shadowOffset = CGSizeMake(0, 3);
    moveOutLayer.shadowRadius =5.0;
    moveOutLayer.shadowColor =[UIColor blackColor].CGColor;
    moveOutLayer.shadowOpacity = 1;
    
    moveOutLayer.borderColor =[UIColor blackColor].CGColor;
    moveOutLayer.borderWidth =2.0;
    moveOutLayer.cornerRadius =10.0;
    moveOutLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [backgroundView.layer addSublayer:moveOutLayer];
    
    CGImageRef img2 = [UIImage imageNamed:@"QQ20160425-0.png"].CGImage;
    moveOutLayer.contents = (__bridge id)img2;
    moveOutLayer.frame = CGRectMake(0, 0, CGImageGetWidth(img2), CGImageGetWidth(img2));
//    moveOutLayer.position = startPoint2;
    
    //Part 2 animation
    //路径曲线
    UIBezierPath *movePath2 = [UIBezierPath bezierPath];
    [movePath2 moveToPoint:startPoint2];
    [movePath2 addLineToPoint:endPoint2];
    
    //关键帧
    moveOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveOutAnimation.path = movePath2.CGPath;
    moveOutAnimation.removedOnCompletion = NO;
    moveOutAnimation.duration = runDuration;
    moveOutAnimation.delegate = self;
    
    moveInLayer.hidden = false;
    moveOutLayer.hidden = true;
    [moveInLayer addAnimation:moveInAnimation forKey:@"MoveIn"];
    moveInLayer.position = endPoint1;
    
    
}

- (void) animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animation start");
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([moveInLayer animationForKey:@"MoveIn"] == anim){
        moveInLayer.hidden = false;
        moveOutLayer.hidden = true;
        [moveInLayer addAnimation:moveOutAnimation forKey:@"MoveOut"];
        moveInLayer.position = endPoint1;
    }else if([moveOutLayer animationForKey:@"MoveOut"] == anim){
        moveInLayer.hidden = true;
        moveOutLayer.hidden = true;
        moveOutLayer.position = endPoint2;
        
    }
}
@end

