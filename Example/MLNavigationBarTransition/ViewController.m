//
//  ViewController.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/27.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "ViewController.h"
#import "MLPickerButton.h"

typedef NS_ENUM(NSUInteger, RowIndex) {
    RowIndexBarTintColor = 0,
    RowIndexBarBackgroundImageColor,
    RowIndexTitleColor,
    RowIndexItemColor,
    RowIndexShowShadowImage,
    RowIndexBackgroundAlpha,
    RowIndexBackgroundHeight,
};

#define kRowCount 7
#define kButtonTag 100

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MLPickerButtonDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Title";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    if (!_configs) {
        _configs = [@[
                     @"Gray",
                     @"None",
                     @"White",
                     @"White",
                     @"YES",
                     @"1.0",
                     @"-1",
                     ]mutableCopy];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - event
- (void)test
{
    ViewController *vc = [ViewController new];
    
    vc.navigationBarConfig = [self barConfigWithConfigs:_configs];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - helper
- (MLNavigationBarConfig*)barConfigWithConfigs:(NSArray*)configs {
    MLNavigationBarConfig *barConfig = [MLNavigationBarConfig new];
    
    NSDictionary *map = @{
                          @"Gray":[UIColor colorWithRed:0.052 green:0.052 blue:0.057 alpha:1.000],
                          @"Red":[UIColor colorWithRed:0.802 green:0.218 blue:0.203 alpha:1.000],
                          @"Yellow":[UIColor colorWithRed:0.991 green:0.851 blue:0.627 alpha:1.000],
                          @"White":[UIColor whiteColor],
                          @"Black":[UIColor blackColor],
                          };
    
    
    barConfig.barTintColor = map[configs[RowIndexBarTintColor]];
    barConfig.barBackgroundImageColor = map[configs[RowIndexBarBackgroundImageColor]];
    barConfig.titleColor = map[configs[RowIndexTitleColor]];
    barConfig.itemColor = map[configs[RowIndexItemColor]];
    barConfig.showShadowImage = [configs[RowIndexShowShadowImage] isEqualToString:@"YES"]?YES:NO;
    barConfig.backgroundAlpha = [configs[RowIndexBackgroundAlpha] floatValue];
    barConfig.backgroundHeight = [configs[RowIndexBackgroundHeight] floatValue];
    
    return barConfig;
}

#pragma mark - layout
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MLPickerButton *button = (MLPickerButton *)[cell.contentView viewWithTag:kButtonTag];
    [button touchUpInSide];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    cell.textLabel.text = @[@"BarTintColor",@"BackgroundImageColor",@"TitleColor",@"ItemColor",@"ShowShadowImage",@"BackgroundAlpha",@"BackgroundHeight"][indexPath.row];
    cell.detailTextLabel.text = _configs[indexPath.row];
    
    MLPickerButton *button = [cell.contentView viewWithTag:kButtonTag];
    if (!button) {
        button = [MLPickerButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectZero;
        button.delegate = self;
        button.tag = kButtonTag;
        [cell.contentView addSubview:button];
    }
    
    button.pickerTitle = cell.textLabel.text;
    button.userInfo = @(indexPath.row);
    switch (indexPath.row) {
        case RowIndexBarTintColor:
            button.dataOfSingleComponentPicker = @[@"Gray",@"Red"];
            break;
        case RowIndexBarBackgroundImageColor:
            button.dataOfSingleComponentPicker = @[@"None",@"Gray",@"Red"];
            break;
        case RowIndexTitleColor:
            button.dataOfSingleComponentPicker = @[@"White",@"Black"];
            break;
        case RowIndexItemColor:
            button.dataOfSingleComponentPicker = @[@"White",@"Black"];
            break;
        case RowIndexShowShadowImage:
            button.dataOfSingleComponentPicker = @[@"YES",@"NO"];
            break;
        case RowIndexBackgroundAlpha:
            button.dataOfSingleComponentPicker = @[@"1.0",@"0.8",@"0.5",@"0.0"];
            break;
        case RowIndexBackgroundHeight:
            button.dataOfSingleComponentPicker = @[@"-1",@"30",@"20"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - event
- (void)doneWithPickerButton:(MLPickerButton*)pickerButton {
    NSInteger index = [pickerButton.pickerView selectedRowInComponent:0];
    NSString *colorString = pickerButton.dataOfSingleComponentPicker[index];
    _configs[[pickerButton.userInfo integerValue]] = colorString;
    
    [self.tableView reloadData];
}

@end