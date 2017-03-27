//
//  ZFDropDown.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZFDropDown.h"
#import "ZFView.h"

@interface ZFDropDown()<UITableViewDelegate, UITableViewDataSource>{
    
}

@property (nonatomic, strong) UIWindow * window;
/** 主题容器view */
@property (nonatomic, strong) ZFView * topicContainerView;
/** 装载tableView的背景容器 */
@property (nonatomic, strong) UIView * tableViewContainerView;
/** 下拉tableView */
@property (nonatomic, strong) UITableView * tableView;
/** topicBorderStyleSingleLine */
@property (nonatomic, strong) UIView * line;

/** 数据 */
@property (nonatomic, strong) NSArray * itemArray;
/** 记录主题控件样式 */
@property (nonatomic, assign) kDropDownPattern pattern;
/** cell的高度 */
@property (nonatomic, assign) CGFloat heightForRow;
/** tableView展示行数 */
@property (nonatomic, assign) NSUInteger numberOfRowsToDisplay;
/** self原始的rect */
@property (nonatomic, assign) CGRect originRect;

@end

@implementation ZFDropDown

- (void)commonInit{
    _originRect = self.frame;
    _numberOfRowsToDisplay = 6;
    _heightForRow = 44.f;
    _shadowOpacity = 0.5f;
    _cornerRadius = 0.f;
    _topicBackgroundColor = ZFClear;
    _tableViewBackgroundColor = ZFTaupe3;
    _cellTextColor = ZFBlack;
    _cellTextFont = [UIFont systemFontOfSize:17.f];
    _cellTextAlignment = NSTextAlignmentLeft;
    _cellNumberOfLines = 1;
    _borderStyle = kDropDownTopicBorderStyleNone;
    _borderColor = ZFLightGray;
    _separatorStyle = UITableViewCellSeparatorStyleNone;
    _window = [UIApplication sharedApplication].keyWindow;
    _orientation = kDropDownOrientationDown;
}

- (instancetype)initWithFrame:(CGRect)frame pattern:(kDropDownPattern)pattern{
    self = [super initWithFrame:frame];
    if (self) {
        _pattern = pattern;
        [self commonInit];
        [self setUpUI];
    }
    
    return self;
}

/**
 *  设置UI
 */
- (void)setUpUI{
    //主题容器view
    self.topicContainerView = [[ZFView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.topicContainerView];
    
    if (_pattern == kDropDownPatternDefault) {
        self.topicButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.topicButton.frame = CGRectMake(10, 0, CGRectGetWidth(self.topicContainerView.frame) - 20, CGRectGetHeight(self.topicContainerView.frame));
        self.topicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.topicButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        [self.topicContainerView addSubview:self.topicButton];
    }else if (_pattern == kDropDownPatternCustom){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
        [self.topicContainerView addGestureRecognizer:tap];
    }
    
    //装载tableView的背景容器
    self.tableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topicContainerView.frame) + 1, CGRectGetWidth(self.frame), _numberOfRowsToDisplay * _heightForRow)];
    self.tableViewContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tableViewContainerView.bounds].CGPath;
    self.tableViewContainerView.hidden = YES;
    [self addSubview:_tableViewContainerView];
    
    //下拉tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableViewContainerView.frame), CGRectGetHeight(self.tableViewContainerView.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = _tableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewContainerView addSubview:self.tableView];
}

- (void)reset{
    if ([self.delegate respondsToSelector:@selector(itemArrayInDropDown:)]) {
        self.itemArray = [NSArray arrayWithArray:[self.delegate itemArrayInDropDown:self]];
    }
    
    if ([self.delegate respondsToSelector:@selector(numberOfRowsToDisplayIndropDown:itemArrayCount:)]) {
        _numberOfRowsToDisplay = [self.delegate numberOfRowsToDisplayIndropDown:self itemArrayCount:self.itemArray.count];
    }
}

/**
 *  重新设置部分UI属性
 */
- (void)resetUI{
    self.tableViewContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.topicContainerView.frame) + 1, CGRectGetWidth(self.frame), _numberOfRowsToDisplay * _heightForRow);
    self.tableViewContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tableViewContainerView.bounds].CGPath;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableViewContainerView.frame), CGRectGetHeight(self.tableViewContainerView.frame));
    
    if (_pattern == kDropDownPatternCustom){
        if ([self.delegate respondsToSelector:@selector(viewForTopicInDropDown:)]) {
            [self.topicContainerView addSubview:[self.delegate viewForTopicInDropDown:self]];;
            
        }else{
            NSLog(@"请通过- (UIView *)viewForTopicInDropDown:(ZFDropDown *)dropDown协议方法返回一个自定义topic view");
        }
    }
}

/**
 *  主题点击Action
 */
- (void)show{
    [self hideOtherDropDown];
    [self.superview bringSubviewToFront:self];
    self.topicContainerView.isSelected = !self.topicContainerView.isSelected;
    
    if (self.topicContainerView.isSelected) {
        
        if (_orientation == kDropDownOrientationDown) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + self.tableView.frame.size.height + 1);
            
        }else if (_orientation == kDropDownOrientationUp){
            self.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame) - self.tableView.frame.size.height, self.frame.size.width, self.tableView.frame.size.height);
            self.tableViewContainerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.topicContainerView.frame = CGRectMake(0, self.frame.size.height - self.topicContainerView.frame.size.height, self.topicContainerView.frame.size.width, self.topicContainerView.frame.size.height);
        }
        
        self.tableViewContainerView.alpha = 1.f;
        self.tableViewContainerView.hidden = NO;
        self.tableViewContainerView.layer.shadowColor = ZFDarkGray.CGColor;
        self.tableViewContainerView.layer.shadowOpacity = _shadowOpacity;
        self.tableViewContainerView.layer.shadowOffset = CGSizeZero;
        self.tableViewContainerView.layer.shadowRadius = 8.f;
        CGAffineTransform originTransform = self.tableViewContainerView.transform;
        CGAffineTransform scaleTransform = CGAffineTransformScale(self.tableViewContainerView.transform, 0.9, 0.9);
        self.tableViewContainerView.transform = scaleTransform;
        
        [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionAllowUserInteraction &UIViewAnimationOptionCurveEaseOut animations:^{
            self.tableViewContainerView.transform = originTransform;
            
        } completion:nil];
        
    }else{
        
        [UIView animateKeyframesWithDuration:0.1f delay:0.f options:UIViewAnimationOptionAllowUserInteraction &UIViewAnimationOptionCurveEaseIn animations:^{
            self.tableViewContainerView.alpha = 0.95f;
            
        } completion:^(BOOL finished) {
            self.tableViewContainerView.layer.shadowColor = ZFClear.CGColor;
            self.tableViewContainerView.layer.shadowOpacity = 0.f;
            self.tableViewContainerView.layer.shadowOffset = CGSizeZero;
            self.tableViewContainerView.layer.shadowRadius = 0.f;
            self.tableViewContainerView.hidden = YES;
            [self.window sendSubviewToBack:self.tableViewContainerView];
            self.frame = _originRect;
            
            if (_orientation == kDropDownOrientationUp){
                self.topicContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            }
            
        }];
    }
}

/**
 *  隐藏其他DropDown
 */
- (void)hideOtherDropDown{
    for (UIView * subview in self.superview.subviews) {
        if ([subview isKindOfClass:[ZFDropDown class]]) {
            ZFDropDown * dropDown = (ZFDropDown *)subview;
            if (subview != self) {
                if (dropDown.topicContainerView.isSelected) {
                    dropDown.topicContainerView.isSelected = NO;
                    dropDown.frame = dropDown.originRect;
                    
                    if (dropDown.orientation == kDropDownOrientationUp){
                        dropDown.topicContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(dropDown.frame), CGRectGetHeight(dropDown.frame));
                    }
                    
                    dropDown.tableViewContainerView.layer.shadowColor = ZFClear.CGColor;
                    dropDown.tableViewContainerView.layer.shadowOpacity = 0.f;
                    dropDown.tableViewContainerView.layer.shadowOffset = CGSizeZero;
                    dropDown.tableViewContainerView.layer.shadowRadius = 0.f;
                    dropDown.tableViewContainerView.hidden = YES;
                    [self.window sendSubviewToBack:dropDown.tableViewContainerView];
                }
            }
        }
    }
}

/**
 *  单独隐藏
 */
- (void)hide{
    for (UIView * subview in self.superview.subviews) {
        if ([subview isKindOfClass:[ZFDropDown class]]) {
            ZFDropDown * dropDown = (ZFDropDown *)subview;
            if (dropDown.topicContainerView.isSelected) {
                dropDown.topicContainerView.isSelected = NO;
                dropDown.frame = dropDown.originRect;
                
                if (dropDown.orientation == kDropDownOrientationUp){
                    dropDown.topicContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(dropDown.frame), CGRectGetHeight(dropDown.frame));
                }
                
                dropDown.tableViewContainerView.layer.shadowColor = ZFClear.CGColor;
                dropDown.tableViewContainerView.layer.shadowOpacity = 0.f;
                dropDown.tableViewContainerView.layer.shadowOffset = CGSizeZero;
                dropDown.tableViewContainerView.layer.shadowRadius = 0.f;
                dropDown.tableViewContainerView.hidden = YES;
                [self.window sendSubviewToBack:dropDown.tableViewContainerView];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_pattern == kDropDownPatternDefault) {
        static NSString * cellIdentifier = @"DefaultCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        NSString * text = nil;
        if ([self.itemArray[indexPath.row] isKindOfClass:[NSString class]]) {
            text = self.itemArray[indexPath.row];
        }else{
            NSLog(@"当前dropDown样式为kDropDownPatternDefault, 请替换为kDropDownPatternCustom");
            return [[UITableViewCell alloc] init];
        }
        
        cell.textLabel.text = text;
        cell.textLabel.textColor = _cellTextColor;
        cell.textLabel.font = _cellTextFont;
        cell.textLabel.textAlignment = _cellTextAlignment;
        cell.textLabel.numberOfLines = _cellNumberOfLines;
        cell.backgroundColor = ZFClear;
        return cell;
        
        //自定义cell
    }else if (_pattern == kDropDownPatternCustom){
        if ([self.delegate respondsToSelector:@selector(dropDown:tableView:cellForRowAtIndexPath:)]) {
            return [self.delegate dropDown:self tableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(dropDown:heightForRowAtIndexPath:)]) {
        _heightForRow = [self.delegate dropDown:self heightForRowAtIndexPath:indexPath];
    }
    
    return _heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self show];
    
    if (_pattern == kDropDownPatternDefault) {
        [self.topicButton setTitle:self.itemArray[indexPath.row] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(dropDown:didSelectRowAtIndexPath:)]) {
        [self.delegate dropDown:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - public method

- (void)reloadData{
    [self reset];
    [self.tableView reloadData];
    [self resetUI];
}

- (void)resignDropDownResponder{
    [self hide];
}

#pragma mark - 重写setter, getter方法

- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSArray array];
    }
    
    return _itemArray;
}

- (void)setDelegate:(id<ZFDropDownDelegate>)delegate{
    _delegate = delegate;
    
    [self reset];
    [self resetUI];
}

- (void)setTopicBackgroundColor:(UIColor *)topicBackgroundColor{
    _topicBackgroundColor = topicBackgroundColor;
    self.topicContainerView.backgroundColor = _topicBackgroundColor;
}

- (void)setTableViewBackgroundColor:(UIColor *)tableViewBackgroundColor{
    _tableViewBackgroundColor = tableViewBackgroundColor;
    self.tableView.backgroundColor = _tableViewBackgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.tableViewContainerView.layer.cornerRadius = _cornerRadius;
    self.tableView.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderStyle:(kDropDownTopicBorderStyle)borderStyle{
    _borderStyle = borderStyle;
    
    if (_borderStyle == kDropDownTopicBorderStyleSingleLine) {
        self.line = nil;
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.topicContainerView.frame) - 0.6f, CGRectGetWidth(self.topicContainerView.frame), 0.6f)];
        self.line.backgroundColor = _borderColor;
        [self.topicContainerView addSubview:self.line];
        
    }else if (_borderStyle == kDropDownTopicBorderStyleRect){
        self.topicContainerView.layer.borderColor = _borderColor.CGColor;
        self.topicContainerView.layer.borderWidth = 0.6f;
    }
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    if (_borderStyle == kDropDownTopicBorderStyleSingleLine) {
        self.line.backgroundColor = _borderColor;
    }else if (_borderStyle == kDropDownTopicBorderStyleRect){
        self.topicContainerView.layer.borderColor = _borderColor.CGColor;
    }
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{
    _separatorStyle = separatorStyle;
    self.tableView.separatorStyle = _separatorStyle;
}

@end
