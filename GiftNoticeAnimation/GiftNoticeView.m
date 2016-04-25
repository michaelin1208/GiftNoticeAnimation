//
//  GiftNoticeView.m
//  GiftNoticeAnimation
//
//  Created by 9158 on 16/4/25.
//  Copyright © 2016年 9158. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftNoticeView.h"
#import "GiftNoticeCellView.h"

#define kGapHeight 5
#define kGiftLinesQty 3

@interface GiftNoticeView ()


@end

@implementation GiftNoticeView {
    UIView* backgroundView;
    NSMutableArray* cells;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cells = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blueColor];
        
        for(int i=0; i<kGiftLinesQty; i ++){
            
            GiftNoticeCellView *tempCell = [[GiftNoticeCellView alloc] init];
            
            tempCell.frame = CGRectMake(0, (kGiftLinesQty - i - 1) * (tempCell.frame.size.height + kGapHeight), tempCell.frame.size.width, tempCell.frame.size.height);
            tempCell.cellID = i;
            tempCell.giftNameLabel.text = [NSString stringWithFormat:@"line %d", i];
            tempCell.giftSenderLabel.text = [NSString stringWithFormat:@"line %d", i];
            
            [tempCell initAnimations];
//            NSLog(@"w %f h %f", tempCell.frame.size.width, tempCell.frame.size.height);
            
            [self addSubview:tempCell];
            [cells addObject:tempCell];
            tempCell.hidden = YES;
        }
        
        if (cells.count > 0){
            GiftNoticeCellView *tempCell = [cells objectAtIndex:0];
            
            self.frame = CGRectMake(0, 0, tempCell.frame.size.width, cells.count * (tempCell.frame.size.height + kGapHeight));
            [self reloadInputViews];
        }
        
        for(int i=0; i<cells.count; i ++){
            NSLog(@"%d x %f y %f", i, [[cells objectAtIndex:i] frame].origin.x, [[cells objectAtIndex:i] frame].origin.y);
        }
        
    }
    return self;
}

- (void)addNotice {
    [[cells objectAtIndex:0] refreshCellWithSender:@"aaaaa" Gift:@"bbbbbbb"];
}

@end