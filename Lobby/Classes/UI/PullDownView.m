//
//  PullDownView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "PullDownView.h"
#import "CustTableViewCell.h"
#import "Station.h"

@interface PullDownView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navTopView;

@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

@property (weak, nonatomic) IBOutlet UIButton *pullDownIcon;

@end

@implementation PullDownView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xEEF3F6);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma UITableView的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CustTableViewCell";
    CustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (CustTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = RGB(230, 235, 241, 1.0);
        cell.title.textColor = RGB(90, 90, 90, 1.0);
        cell.title.font = K_FONT_13;
    }
    
    if (_type == PullDownViewTypeBusiness) {
        cell.title.text = [_dataSource[indexPath.row] valueForKey:@"bs_name"];
    } else {
        Station *station = _dataSource[indexPath.row];
        cell.title.text = [NSString stringWithFormat:@"%@号窗口", station.stationNo] ;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.checkMarkView.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.checkMarkView.hidden = NO;
    
    if (_type == PullDownViewTypeBusiness) {
        self.subTitleLb.text = [_dataSource[indexPath.row] valueForKey:@"bs_name"];
    } else {
        Station *station = _dataSource[indexPath.row];
        cell.title.text = [NSString stringWithFormat:@"%@号窗口", station.stationNo] ;
    }
    
    _selectedValue = _dataSource[indexPath.row];
}

- (void)setType:(PullDownViewType)type
{
    _type = type;
}

//布局

- (void)setShow:(BOOL)show
{
    _show = show;
    
    if (_show) {
//        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, 236);
            _pullDownIcon.selected = YES;
            self.bottomLine.hidden = NO;
//        }];
    } else {
//        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, 61);
            _pullDownIcon.selected = NO;
            self.bottomLine.hidden = YES;
//        }];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _titleLb.text = _title;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    [_tableView reloadData];
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    _defaultImage = defaultImage;
    
    [_pullDownIcon setImage:_defaultImage forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    [_pullDownIcon setImage:_selectedImage forState:UIControlStateSelected];
}

- (IBAction)showOrHide:(UIButton *)sender
{
    _show = !sender.isSelected;
    
    self.show = _show;
    
    if (_layoutView) {
        _layoutView(self);
    }
}
@end
