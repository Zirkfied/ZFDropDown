//
//  ZFDropDown.h
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFConst.h"
@class ZFDropDown;
@class ZFTopicContainerView;

@protocol ZFDropDownDelegate <NSObject>

@required

/**
 *  数据
 *
 *  PS: ①当dropDown为kDropDownPatternDefault时, NSArray必须存储NSString类型: @[@"1", @"2", @"3"];
 
        ②当dropDown为kDropDownPatternCustom时, NSArray可存储任意元素类型，但所有元素的类型必须一致
 *
 *  @return NSArray
 */
- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown;



@optional

/**
 *  设置cell高度(默认为44.f)
 *
 *  @param dropDown 当前dropDown
 *  @param indexPath 当前cell的下标
 */
- (CGFloat)dropDown:(ZFDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  tableView展示行数(默认展示6行)
 *
 *  @param dropDown 当前dropDown
 *  @param count 可拿到数据源的个数进行特殊情况行数展示设置
    eg: 例如当有多个dropDown时，某个dropDown数据源的个数不够n个，则可以用此方法拿到count进行判断，当count < n，则返回当前数据源的个数，否则则返回n个
 *
 *  @return 返回NSUInteger
 */
- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count;

/**
 *  返回自定义topic(当dropDown为kDropDownPatternDefault时，该方法无效)
 */
- (UIView *)viewForTopicInDropDown:(ZFDropDown *)dropDown;

/**
 *  返回自定义cell(当dropDown为kDropDownPatternDefault时，该方法无效)
 
 *  @param dropDown 当前dropDown
 *  @param tableView tableView
 *  @param indexPath indexPath
 *  @return UITableViewCell
 */
- (UITableViewCell *)dropDown:(ZFDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *获取被点击的数据所在数组的下标，用于进行后续的数据传值操作
 
 *  @param dropDown 当前dropDown
 *  @param indexPath 数据所在数组的位置下标
 */
- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  dropDown样式
 */
typedef enum{
    kDropDownPatternDefault = 0,//自带Button
    kDropDownPatternCustom = 1,//自定义控件
}kDropDownPattern;

/**
 *  topic边框样式
 */
typedef enum{
    kDropDownTopicBorderStyleNone = 0,//无边框(默认)
    kDropDownTopicBorderStyleSingleLine = 1,//底部有边线
    kDropDownTopicBorderStyleRect = 2//长方形边框
}kDropDownTopicBorderStyle;

typedef enum{
    kDropDownOrientationUp = 0,//上方显示
    kDropDownOrientationDown = 1//下方显示(默认)
}kDropDownOrientation;

@interface ZFDropDown : UIView

@property (nonatomic, weak) id<ZFDropDownDelegate> delegate;

/** Default模式下自带的主题Button */
@property (nonatomic, strong) UIButton * topicButton;

/** topic背景颜色(默认为ZFClear) */
@property (nonatomic, strong) UIColor * topicBackgroundColor;
/** tableView背景颜色(默认为ZFTaupe3) */
@property (nonatomic, strong) UIColor * tableViewBackgroundColor;
/** cell文本颜色 */
@property (nonatomic, strong) UIColor * cellTextColor;
/** cell文本Font */
@property (nonatomic, strong) UIFont * cellTextFont;
/** cell文本Alignment */
@property (nonatomic, assign) NSTextAlignment cellTextAlignment;
/** cell文本显示行数(默认为1行) */
@property (nonatomic, assign) NSInteger cellNumberOfLines;
/** tableView展示方向(默认为kDropDownOrientationDown) */
@property (nonatomic, assign) kDropDownOrientation orientation;

/** tableView的阴影透明度(默认为0.5, 范围0~1) */
@property (nonatomic, assign) CGFloat shadowOpacity;
/** tableView的cornerRadius */
@property (nonatomic, assign) CGFloat cornerRadius;
/** tableView分割线样式(默认为UITableViewCellSeparatorStyleNone) */
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
/** topic边框样式(默认为kDropDownTopicBorderStyleNone) */
@property (nonatomic, assign) kDropDownTopicBorderStyle borderStyle;
/** topic边框颜色(默认为ZFLightGray) */
@property (nonatomic, strong) UIColor * borderColor;


/**
 *  初始化
 
 *  @param frame frame
 *  @param pattern dropDown样式
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame pattern:(kDropDownPattern)pattern;

/**
 *  刷新tableView数据(网络数据加载后调用此方法进行数据刷新)
 */
- (void)reloadData;

/**
 *  当dropDown为kDropDownTopicPatternForCustom自定义样式时，且viewForTopic里有UIButton或UIControl控件时，若需要通过该UIButton或UIControl弹出下拉列表，则添加下句代码:
 
 [self.button addTarget:dropDown action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
 
 target填写当前的dropDown, 切勿填self, 否则无效
 selector则为show
 
 具体用法请看CustomViewController.m
 */
- (void)show;

/**
 *  取消第一响应，用于手势响应事件里
 */
- (void)resignDropDownResponder;

@end
