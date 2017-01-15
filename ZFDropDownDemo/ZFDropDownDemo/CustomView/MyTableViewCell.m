//
//  MyTableViewCell.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyTableViewCell.h"
#import "ZFColor.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
    [self.contentView addSubview:self.imgView];
    
    self.txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, 146, 34)];
    self.txtLabel.numberOfLines = 0;
    self.txtLabel.textColor = ZFSystemBlue;
    self.txtLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:self.txtLabel];
    
    self.subTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 34)];
    self.subTxtLabel.numberOfLines = 0;
    self.subTxtLabel.textColor = ZFLightGray;
    self.subTxtLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.subTxtLabel];
}

@end
