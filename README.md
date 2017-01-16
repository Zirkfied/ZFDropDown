# ZFDropDown
A drop down for iOS. Designed by Kevin Hirsch. Written in OC by Zirkfied. It can also create your own custom style.

原作者Kevin Hirsch用Swift写的一个简单大气的下拉列表框，本人根据原样式写了一个OC版本，支持自定义样式。喜欢的欢迎star一个，有任何建议或问题可以加QQ群交流：451169423

####Swift : https://github.com/AssistoLab/DropDown

![](https://github.com/Zirkfied/Library/blob/master/DropDown1.png)![](https://github.com/Zirkfied/Library/blob/master/DropDown2.png)![](https://github.com/Zirkfied/Library/blob/master/DropDown3.png)

![](https://github.com/Zirkfied/Library/blob/master/DropDown.gif)



###用法:
        第一步(step 1)
        将项目里ZFDropDown整个文件夹拖进新项目
        
        第二步(step 2)
        #import "ZFDropDown.h"
        
        第三步(step 3)
        须遵循ZFDropDownDelegate代理协议
        
        ZFDropDown * dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(50, 100, 300, 40) pattern:kDropDownPatternDefault];
        dropDown.delegate = self;
        [dropDown.topicButton setTitle:@"Please choose 1 continent / area" forState:UIControlStateNormal];
        [self.view addSubview:dropDown];
        
####    @required 必须实现的方法
        - (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
             return @[@"Chinese", @"Math", @"English", @"Politics", @"Physics", @"Chemistry", @"Geography", @"History", @"Biology", @"Philosophy"];
        }
        


###其余说明
####
        1.若是通过网络加载数据，在拿到数据后调用[dropDown reloadData]进行刷新列表
        2.自定义样式请看Demo示例中的CustomViewController.m
        3.其余方法和属性请查看ZFDropDown.h
   
        
###更新日志
        2017.01.15 初版发布
        
##本人其他开源框架
####[ZFChart - 一款简单好用的图表库，目前有柱状，线状，饼图，波浪，雷达，圆环图类型](https://github.com/Zirkfied/ZFChart)
####[ZFScan - 仿微信 二维码/条形码 扫描](https://github.com/Zirkfied/ZFScan)
####[ZFDropDown - 简单大气的下拉列表框](https://github.com/Zirkfied/ZFDropDown)
