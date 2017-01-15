//
//  ViewController.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DefaultViewController.h"
#import "ZFDropDown.h"

@interface DefaultViewController ()<ZFDropDownDelegate>

@property (nonatomic, strong) ZFDropDown * dropDown;
@property (nonatomic, strong) ZFDropDown * dropDown2;
@property (nonatomic, strong) ZFTapGestureRecognizer * tap;

@end

@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZFWhite;
    
    CGFloat width = 300;
    CGFloat height = 40;
    CGFloat xPos = (SCREEN_WIDTH - width) / 2;
    CGFloat yPos = NAVIGATIONBAR_HEIGHT + 10;
    
    self.dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(xPos, yPos, width, height) pattern:kDropDownPatternDefault];
    self.dropDown.delegate = self;
    [self.dropDown.topicButton setTitle:@"Please choose 1 continent / area" forState:UIControlStateNormal];
    self.dropDown.topicButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.dropDown.cornerRadius = 10.f;
    [self.view addSubview:self.dropDown];
    
    
    self.dropDown2 = [[ZFDropDown alloc] initWithFrame:CGRectMake(xPos, yPos + 350, width, height) pattern:kDropDownPatternDefault];
    self.dropDown2.delegate = self;
    [self.dropDown2.topicButton setTitle:@"Please choose 1 subject" forState:UIControlStateNormal];
    self.dropDown2.topicButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.dropDown2.borderStyle = kDropDownTopicBorderStyleSingleLine;
    self.dropDown2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.dropDown2.cellTextFont = [UIFont boldSystemFontOfSize:20.f];
    self.dropDown2.orientation = kDropDownOrientationUp;
//    self.dropDown2.topicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.dropDown2];
    
    
    self.tap = [[ZFTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:self.tap];
}

/**
 *  self.view添加手势取消dropDown第一响应
 */
- (void)tapAction{
    [self.dropDown resignDropDownResponder];
    [self.dropDown2 resignDropDownResponder];
}

#pragma mark - ZFDropDownDelegate

- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    if (dropDown == self.dropDown) {
        return @[@"Asia", @"Europe", @"Africa", @"Oceania", @"North America", @"South America", @"Antarctica", @"Arctic"];
    }
    
    return @[@"Chinese", @"Math", @"English", @"Politics", @"Physics", @"Chemistry", @"Geography", @"History", @"Biology", @"Philosophy"];
}

- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
    if (dropDown == self.dropDown) {
        return 5;
    }
    
    return 6;
}

@end
