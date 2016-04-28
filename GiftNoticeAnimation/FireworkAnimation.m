//
//  FireworkAnimation.m
//  Animation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

//
//  Firework.m
//  Animation
//
//  Created by 9158 on 16/4/23.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "FireworkAnimation.h"

@interface FireworkAnimation ()


@end

@implementation FireworkAnimation {
    UIView* backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startAnimationAtView: (UIView *)currentView {
    backgroundView = currentView;
    
    Firework *firework = [[Firework alloc] init];
    firework.startPosition = CGPointMake(backgroundView.frame.size.width/2, 500);
    firework.endPostion = CGPointMake(firework.sublayer2.frame.size.width/2 - 10, 100);
    [firework startAnimationAtView:backgroundView];
    
    Firework *firework1 = [[Firework alloc] init];
    firework1.startPosition = CGPointMake(backgroundView.frame.size.width/2, 500);
    firework1.endPostion = CGPointMake(backgroundView.frame.size.width/2 - 20, 60);
    [firework1 startAnimationAtView:backgroundView];
    
    Firework *firework2 = [[Firework alloc] init];
    firework2.startPosition = CGPointMake(backgroundView.frame.size.width/2, 500);
    firework2.endPostion = CGPointMake(backgroundView.frame.size.width - firework.sublayer2.frame.size.width/2 + 10, 80);
    [firework2 startAnimationAtView:backgroundView];
    
}
@end

