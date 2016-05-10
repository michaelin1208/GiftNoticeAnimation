//
//  MessageView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/28.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "MessageView.h"
//#import "UIImageView+WebCache.h"
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

#define kMargin 6

#define kCLDefaultHeadImage [UIImage imageNamed:@"Defaulthead"]

#define kShortStayDuration 1
#define kLongStayDuration 2
#define kMoveDuration 4

#define kChatNickNameColor [UIColor colorWithRed:255.0/255.0 green:175/255.0 blue:74/255.0 alpha:1]

@interface MessageView ()


@end

@implementation MessageView {
    NSString *senderName;
    NSString *senderIconPath;
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
//        UIImage * bgImage = [UIImage imageNamed:@"chat_gift_animate_bg"];
//        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        
        //消息窗口的页面格式
        [self setBackgroundColor:[UIColor colorWithRed: 0 green:0 blue:0 alpha:100]];
        self.senderLabel.textColor = kChatNickNameColor;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        
        self.senderLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 4, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.senderLabel.textColor = [UIColor yellowColor];
        self.senderLabel.font = [UIFont boldSystemFontOfSize:12];
        self.contentLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 17, kBannerViewLabelWidth, kBannerViewLabelHeight)];
        self.contentLabel.textColor = [UIColor yellowColor];
        self.contentLabel.font = [UIFont boldSystemFontOfSize:12];
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
        
//        self.giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.senderLabel.frame.origin.x+self.senderLabel.frame.size.width + kMargin, self.frame.size.height - kGiftImageViewHeight, kGiftImageViewWidth, kGiftImageViewHeight)];
//        [self.giftImageView setImage:kCLDefaultHeadImage];
        
//        [self addSubview: self.giftImageView];
        [self addSubview: self.senderLabel];
        [self addSubview: self.contentLabel];
        [self addSubview: self.countLabel];
        
        
    }
    return self;
}

- (void)initAnimation{
    
    
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

- (void)startAnimationWithSenderName:(NSString *)sName IconPath:(NSString *) sIconPath ReceiverName:(NSString *)rName Content:(NSString *)con{
    
//    if (moveInAnimation == nil) {
//        [self initAnimation];
//    }
    
    senderName = sName;
    senderIconPath = sIconPath;
    receiverName = rName;
    content = con;
//    giftName = gName;
//    count = c;
    
    self.senderLabel.text = senderName;
    self.contentLabel.text = content;
    //    self.countLabel.text = [NSString stringWithFormat:@"X %@", count];
    
    
    
    if ([senderIconPath rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        senderIconPath = [@"http://" stringByAppendingString:senderIconPath];
    }
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:senderIconPath] placeholderImage:kCLDefaultHeadImage];
    [self.headImageView setImage:kCLDefaultHeadImage];
    
    //set custom animation
    [self.contentLabel sizeToFit];
    int newWidth = self.contentLabel.frame.size.width+self.contentLabel.frame.origin.x+kMargin;
    if (newWidth < self.senderLabel.frame.size.width+self.contentLabel.frame.origin.x+kMargin) {
        newWidth = self.senderLabel.frame.size.width+self.contentLabel.frame.origin.x+kMargin;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
    
    startPoint = CGPointMake(self.superview.frame.size.width + self.frame.size.width/2, self.layer.position.y);
    //    stayPoint = CGPointMake(self.superview.frame.size.width/2, self.frame.size.height/2 + 20);
    endPoint = CGPointMake(-self.frame.size.width + self.frame.size.width/2, self.layer.position.y);
    
    startPoint = CGPointMake(self.superview.frame.size.width + self.frame.size.width/2, self.layer.position.y);
    //    stayPoint = CGPointMake(self.superview.frame.size.width/2, self.frame.size.height/2 + 20);
    endPoint = CGPointMake(-self.frame.size.width + self.frame.size.width/2, self.layer.position.y);
    
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
//    NSLog(@"animation start");
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

