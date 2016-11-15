//
//  AboutView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/1.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()
@property (weak, nonatomic) IBOutlet UILabel *descible;

@end

@implementation AboutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lableStyle:_descible];
}

- (void)lableStyle:(UILabel *)lable
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:lable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lable.text.length)];
    lable.attributedText = attributeString;
    
}

- (IBAction)close:(id)sender
{
    [self.superview removeFromSuperview];
}
@end
