//
//  MasterChoseCell.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/18.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "MasterChoseCell.h"

#define nameNormalColor RGB(92, 113, 147, 1.0f)
#define nameHighColor [UIColor whiteColor]

@interface MasterChoseCell ()
{
    UIImage *_normalImage;
    UIImage *_highlightImage;
}

@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIView *flagOfNewMsg;
@property (weak, nonatomic) IBOutlet UIView *separater;

@end

@implementation MasterChoseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setItem:(NSArray *)item
{
    _item = item;
    
    NSString *name = _item[0];
    NSString *iconNormalStr = _item[1];
    NSString *iconHighStr = _item[2];
    
    UIImage *iconNormal = [UIImage imageNamed:iconNormalStr];
    UIImage *iconHigh = [UIImage imageNamed:iconHighStr];
    
    _normalImage = iconNormal;
    _highlightImage = iconHigh;
    
    _itemName.textColor = nameNormalColor;
    
    _itemName.text = name;
    _icon.image = iconNormal;
    
    _flagOfNewMsg.layer.cornerRadius = 4;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        self.contentView.backgroundColor = RGB(19, 43, 66, 1.0);
        _itemName.textColor = nameHighColor;
        _icon.image = _highlightImage;
        _verticalLine.hidden = NO;
    } else {
        self.contentView.backgroundColor = RGB(31, 53, 77, 1.0);
        _itemName.textColor = nameNormalColor;
        _icon.image = _normalImage;
        _verticalLine.hidden = YES;
    }
}

- (void)setHasNewMsg:(BOOL)hasNewMsg
{
    _hasNewMsg = hasNewMsg;
    
    if (_hasNewMsg) {
        _flagOfNewMsg.hidden = NO;
    } else {
        _flagOfNewMsg.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
