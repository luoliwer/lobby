//
//  ListView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/10/12.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "ListView.h"
#import "Public.h"
#import "ListCell.h"

CGFloat const CellHeight = 30.0f;

@interface ListView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listTable;
    NSUInteger _seletedIndex;
}

@end

@implementation ListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _listTable = [[UITableView alloc] init];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_listTable];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置尺寸
    _listTable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


- (void)setListItems:(NSArray *)listItems
{
    _listItems = listItems;
    
    CGFloat tableWidth = 0;
    
    __block CGFloat previousWidth = 0;
    
    __block NSUInteger index = 0;
    
    [_listItems enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *content = [[obj allValues] firstObject];
        CGFloat maxWidth = [Public sizeOfString:content withFont:K_FONT_16].width ;
        CGFloat val = (maxWidth > previousWidth) ? maxWidth : previousWidth;
        previousWidth = val;
        //确定哪一行被选中
        if ([_selectedValue isEqualToString:content]) {
            index = idx;
        }
    }];
    
    _seletedIndex = index;
    
    tableWidth = previousWidth;
    
    self.frame = CGRectMake(self.frame.origin.x - tableWidth + 10, self.frame.origin.y, tableWidth, CellHeight * _listItems.count);
    
    [_listTable reloadData];
}

#pragma mark -- UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ListCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_seletedIndex  == indexPath.row) {
        cell.backgroundColor = RGB(222, 222, 222, 1.0);
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary *dic = _listItems[indexPath.row];
    cell.contentLabel.text = [[dic allValues] firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *val = _listItems[indexPath.row];
    
    if (_listViewSelectedValue) {
        _listViewSelectedValue(val);
    }
}

@end
