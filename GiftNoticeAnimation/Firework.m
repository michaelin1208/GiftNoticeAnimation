//
//  Firework.m
//  Animation
//
//  Created by 9158 on 16/4/23.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "Firework.h"

@interface Firework ()


@end

@implementation Firework {
    int step;
    UIView *backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        step = 0;
        
//        _startPosition = startPoint;
//        _endPostion = endPoint;
        
        _sublayer =[CALayer layer];
        _sublayer.backgroundColor =[UIColor orangeColor].CGColor;
        _sublayer.shadowOffset = CGSizeMake(0, 3);
        _sublayer.shadowRadius =5.0;
        _sublayer.shadowColor =[UIColor blackColor].CGColor;
        _sublayer.shadowOpacity = 1;
        
        _sublayer.borderColor =[UIColor blackColor].CGColor;
        _sublayer.borderWidth =2.0;
        _sublayer.cornerRadius =10.0;
        _sublayer.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        CGImageRef img = [UIImage imageNamed:@"QQ20160423-1.png"].CGImage;
        _sublayer.contents = (__bridge id)img;
        _sublayer.frame = CGRectMake(0, 0, CGImageGetWidth(img), CGImageGetWidth(img));
//        _sublayer.position = _startPosition;
        //    _sublayer.contentsScale = 0.1;
//        [_sublayer setRasterizationScale:0.1];
        
        _sublayer2 =[CALayer layer];
        _sublayer2.backgroundColor =[UIColor orangeColor].CGColor;
        _sublayer2.shadowOffset = CGSizeMake(0, 3);
        _sublayer2.shadowRadius =5.0;
        _sublayer2.shadowColor =[UIColor blackColor].CGColor;
        _sublayer2.shadowOpacity = 1;
        
        _sublayer2.borderColor =[UIColor blackColor].CGColor;
        _sublayer2.borderWidth =2.0;
        _sublayer2.cornerRadius =10.0;
        _sublayer2.anchorPoint = CGPointMake(0.5, 0.5);
        
        CGImageRef img2 = [UIImage imageNamed:@"QQ20160423-0.png"].CGImage;
        _sublayer2.contents = (__bridge id)img2;
        _sublayer2.frame = CGRectMake(0, 0, CGImageGetWidth(img2), CGImageGetWidth(img2));
//        _sublayer2.position = _endPostion;
    }
    return self;
}

- (instancetype)initWithStartPosition:(CGPoint)startPoint EndPosition:(CGPoint)endPoint
{
    self = [self init];    
    _startPosition = startPoint;
    _endPostion = endPoint;
    return self;
}

- (void)startAnimationAtView: (UIView *)currentView {
    backgroundView = currentView;
    // 烟花开始从发射点发射到结束点的动画
    [backgroundView.layer addSublayer:_sublayer];
    
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:_startPosition];
    CGPoint toPoint = _endPostion;
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(backgroundView.frame.size.width/2,0)];
//    _sublayer.position = CGPointMake(100, 100);
    
    //关键帧
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = NO;
    moveAnim.duration = 1;
    moveAnim.delegate = self;
    
    [_sublayer addAnimation:moveAnim forKey:@"shoot"];
    _sublayer.position = _endPostion;
    
}

- (void) animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animation start");
}

// 烟花的发射到固定点后 再调用爆炸的动画
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    NSLog(@"animation stop");
    if (anim == [_sublayer animationForKey:@"shoot"]) {
        [_sublayer removeFromSuperlayer];
        
        [backgroundView.layer addSublayer:_sublayer2];
        
        _sublayer2.position = _endPostion;
        //旋转变化
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.fromValue = [NSNumber numberWithFloat:0.1];
        //x，y轴缩小到0.1,Z 轴不变
        scaleAnim.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnim.duration = 0.5;
        scaleAnim.delegate = self;
        scaleAnim.removedOnCompletion = NO;
        [_sublayer2 addAnimation:scaleAnim forKey:@"explosion"];

    }else if (anim == [_sublayer2 animationForKey:@"explosion"]){
        [_sublayer2 removeFromSuperlayer];
//        NSLog(@"_sublayer2 remove");
    }
    
    
    
}
@end

