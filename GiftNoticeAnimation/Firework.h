//
//  Firework.h
//  Animation
//
//  Created by 9158 on 16/4/23.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Firework:UIView

//@property (nonatomic, strong) UIImageView *image;
//@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGPoint endPostion;
@property (nonatomic, strong) CALayer *sublayer;
@property (nonatomic, strong) CALayer *sublayer2;

- (void)startAnimationAtView: (UIView *)currentView;
- (instancetype)initWithStartPosition:(CGPoint)startPoint EndPosition:(CGPoint)endPoint;

@end