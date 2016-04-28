//
//  MessageView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/28.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "MessageView.h"
#define kBannerViewLabelWidth 120
#define kBannerViewLabelHeight 13

#define kCountLabelWidth 30
#define kCountLabelHeight kCountLabelWidth

#define kBannerViewHeadBtnWidth 35
#define kBannerViewHeadBtnHeight kBannerViewHeadBtnWidth

#define kBannerViewGiftImageViewWidth 40
#define kBannerViewGiftImageViewHeight kBannerViewGiftImageViewWidth

#define kGiftImageViewWidth 40
#define kGiftImageViewHeight kGiftImageViewWidth

#define kGiftMargin 5

#define kCLDefaultHeadImage [UIImage imageNamed:@"Defaulthead"]

#define kShortStayDuration 1
#define kLongStayDuration 2
#define kMoveDuration 3

@interface MessageView ()


@end

@implementation MessageView {
    NSString *senderName;
    NSString *receiverName;
    NSString *giftName;
    NSString *content;
    int stayDuration;
    
    CGPoint startPoint;
//    CGPoint stayPoint;
    CGPoint endPoint;
    
    CAKeyframeAnimation *moveInAnimation;
//    CAKeyframeAnimation *moveOutAnimation;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage * bgImage = [UIImage imageNamed:@"chat_gift_animate_bg"];
        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.giftSenderLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 4, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.giftSenderLabel.textColor = [UIColor yellowColor];
        self.giftSenderLabel.font = [UIFont boldSystemFontOfSize:12];
        self.giftNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 17, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.giftNameLabel.textColor = [UIColor yellowColor];
        self.giftNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.countLabel = [[UILabel alloc] initWithFrame: CGRectMake(210, 0, kCountLabelWidth, kCountLabelHeight)];
        self.countLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.countLabel.font = [UIFont boldSystemFontOfSize:20];
        self.countLabel.textColor = [UIColor redColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBannerViewHeadBtnWidth, kBannerViewHeadBtnHeight)];
        [self.headImageView setImage:kCLDefaultHeadImage];
        self.headImageView.layer.cornerRadius = kBannerViewHeadBtnHeight/2;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderWidth = 1.0;
        self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview: self.headImageView];
        
        self.giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.giftSenderLabel.frame.origin.x+self.giftSenderLabel.frame.size.width + kGiftMargin, self.frame.size.height - kGiftImageViewHeight, kGiftImageViewWidth, kGiftImageViewHeight)];
        [self.giftImageView setImage:kCLDefaultHeadImage];
        
        [self addSubview: self.giftImageView];
        [self addSubview: self.giftSenderLabel];
        [self addSubview: self.giftNameLabel];
        [self addSubview: self.countLabel];
        
        
    }
    return self;
}

- (void)initAnimation{
    startPoint = CGPointMake(self.superview.frame.size.width, self.layer.position.y);
//    stayPoint = CGPointMake(self.superview.frame.size.width/2, self.frame.size.height/2 + 20);
    endPoint = CGPointMake(-self.frame.size.width, self.layer.position.y);
    
    //Part 1 animation
    //路径曲线
    UIBezierPath *moveInPath = [UIBezierPath bezierPath];
    [moveInPath moveToPoint:startPoint];
    [moveInPath addLineToPoint:endPoint];
    
    //关键帧
    moveInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveInAnimation.path = moveInPath.CGPath;
    moveInAnimation.removedOnCompletion = NO;
    moveInAnimation.duration = kMoveDuration;
    moveInAnimation.delegate = self;
    
    
//    //Part 2 animation
//    //路径曲线
//    UIBezierPath *moveOutPath = [UIBezierPath bezierPath];
//    [moveOutPath moveToPoint:stayPoint];
//    [moveOutPath addLineToPoint:endPoint];
//    
//    //关键帧
//    moveOutAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    moveOutAnimation.path = moveOutPath.CGPath;
//    moveOutAnimation.removedOnCompletion = NO;
//    moveOutAnimation.duration = kMoveDuration;
//    moveOutAnimation.delegate = self;
}

- (void)startAnimationWithSenderName:(NSString *)sName ReceiverName:(NSString *)rName Content:(NSString *)con{
    
    if (moveInAnimation == nil) {
        [self initAnimation];
    }
    
    senderName = sName;
    receiverName = rName;
    content = con;
//    giftName = gName;
//    count = c;
    
    self.giftSenderLabel.text = senderName;
    self.giftNameLabel.text = content;
//    self.countLabel.text = [NSString stringWithFormat:@"X %@", count];
    
//    if (isInReceiver) {
//        stayDuration = kLongStayDuration;
//    }else{
//        stayDuration = kShortStayDuration;
//    }
    
    [self startMoveIn];
}

-(void)startMoveIn{
    self.hidden = NO;
    self.layer.position = startPoint;
    [self.layer addAnimation:moveInAnimation forKey:@"MoveIn"];
    self.layer.position = endPoint;
}

//-(void)startMoveOut{
//    self.layer.position = stayPoint;
//    [self.layer addAnimation:moveOutAnimation forKey:@"MoveOut"];
//    self.layer.position = endPoint;
//}

- (void) animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([self.layer animationForKey:@"MoveIn"] == anim){
//        [NSTimer scheduledTimerWithTimeInterval:stayDuration target:self selector:@selector(startMoveOut) userInfo:nil repeats:NO];
        self.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFinished" object:[NSNumber numberWithInt:_cellID] userInfo:nil];

    }
//    }else if([self.layer animationForKey:@"MoveOut"] == anim){
//        self.hidden = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerFinished" object:nil userInfo:nil];
//    }
}


@end
