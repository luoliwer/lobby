//
//  ListCell.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/10/19.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = K_FONT_11;
        _contentLabel.backgroundColor = [UIColor clearColor];
    
        [self addSubview:_contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
