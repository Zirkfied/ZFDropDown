//
//  CustomViewController.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomViewController.h"
#import "ZFDropDown.h"
#import "MyTableViewCell.h"

@interface CustomViewController ()<ZFDropDownDelegate>

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) ZFDropDown * dropDown;
@property (nonatomic, strong) ZFTapGestureRecognizer * tap;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UILabel * label;

@end

@implementation CustomViewController

- (NSArray *)dataSource{
    if (!_dataSource) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Songs" ofType:@"plist"];
        _dataSource = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZFWhite;
    
    CGFloat width = 300;
    CGFloat height = 40;
    CGFloat xPos = (SCREEN_WIDTH - width) / 2;
    CGFloat yPos = 100;
    
    self.dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(xPos, yPos, width, height) pattern:kDropDownPatternCustom];
    self.dropDown.delegate = self;
    self.dropDown.borderStyle = kDropDownTopicBorderStyleRect;
    [self.view addSubview:self.dropDown];
    
    
    self.tap = [[ZFTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:self.tap];
}

/**
 *  self.view添加手势取消dropDown第一响应
 */
- (void)tapAction{
    [self.dropDown resignDropDownResponder];
}

#pragma mark - ZFDropDownDelegate

- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    return self.dataSource;
}

- (UIView *)viewForTopicInDropDown:(ZFDropDown *)dropDown{
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.imageView.image = [UIImage imageNamed:@""];
    self.imageView.backgroundColor = ZFFicelle;
    [self.backgroundView addSubview:self.imageView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(40, 5, 255, 30);
    [self.button setTitle:@"Please choose 1 song" forState:UIControlStateNormal];
    [self.button setTitleColor:ZFSystemBlue forState:UIControlStateNormal];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //注意这里的target是dropDown, 不是self
    [self.button addTarget:dropDown action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.button];
    
    return self.backgroundView;
}

- (UITableViewCell *)dropDown:(ZFDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"MyTableViewCell";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dict[@"cover"]];
    cell.txtLabel.text = dict[@"title"];
    cell.subTxtLabel.text = dict[@"singer"];
    cell.backgroundColor = ZFTaupe3;
    return cell;
}

//- (CGFloat)dropDown:(ZFDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100.f;
//}

- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataSource[indexPath.row];
    self.imageView.image = [UIImage imageNamed:dict[@"cover"]];
    [self.button setTitle:dict[@"title"] forState:UIControlStateNormal];
}

//- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
//    return 4;
//}

@end
