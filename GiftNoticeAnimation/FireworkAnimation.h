//
//  FireworkAnimation.h
//  Animation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Firework.h"

@interface FireworkAnimation:UIView

//@property (nonatomic, strong) UIImageView *image;
//@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGPoint endPostion;

- (void)startAnimationAtView: (UIView *)view;

@end
