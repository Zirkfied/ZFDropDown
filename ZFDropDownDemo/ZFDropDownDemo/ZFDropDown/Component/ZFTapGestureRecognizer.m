//
//  ZFTapGestureRecognizer.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZFTapGestureRecognizer.h"

@implementation ZFTapGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

/**
 *  重写手势代理方法（添加了手势导致tableView的didSelectRowAtIndexPath方法失效）
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
