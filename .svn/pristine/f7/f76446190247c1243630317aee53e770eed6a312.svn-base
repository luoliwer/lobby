//
//  HasProductView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/24.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "HasProductView.h"
#import "Recommand.h"
#import "Public.h"

@interface HasProductView ()
{
    CGFloat startNonCyY;
}
@property (weak, nonatomic) IBOutlet UIView *businessView;
@property (weak, nonatomic) IBOutlet UIView *prodView;
@property (weak, nonatomic) IBOutlet UIView *recomandView;
@property (weak, nonatomic) IBOutlet UILabel *recomandName1;
@property (weak, nonatomic) IBOutlet UILabel *recomandDes1;
@property (weak, nonatomic) IBOutlet UILabel *recomandName2;
@property (weak, nonatomic) IBOutlet UILabel *recomandDes2;
@property (weak, nonatomic) IBOutlet UILabel *recomandName3;
@property (weak, nonatomic) IBOutlet UILabel *recomandDes3;

@end

@implementation HasProductView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _businessView.layer.cornerRadius = 5;
    _businessView.clipsToBounds = YES;
    _businessView.layer.borderColor = [BorderColor CGColor];
    _businessView.layer.borderWidth = BorderWidth;
    
    _prodView.layer.cornerRadius = 5;
    _prodView.clipsToBounds = YES;
    _prodView.layer.borderColor = [BorderColor CGColor];
    _prodView.layer.borderWidth = BorderWidth;
    
    _recomandView.layer.cornerRadius = 5;
    _recomandView.clipsToBounds = YES;
    _recomandView.layer.borderColor = [BorderColor CGColor];
    _recomandView.layer.borderWidth = BorderWidth;
}

- (void)setBusinesses:(NSArray *)businesses
{
    for (UIView *subview in _businessView.subviews) {
        if (subview.tag == 100) {
            continue;
        }
        [subview removeFromSuperview];
    }
    
    _businesses = businesses;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 50, _businessView.frame.size.width, _businessView.frame.size.height - 50);
    [_businessView addSubview:scrollView];
    
    [self updateUI:scrollView data:businesses];
}

- (void)setProducts:(NSArray *)products
{
    for (UIView *subview in _prodView.subviews) {
        if (subview.tag == 101) {
            continue;
        }
        [subview removeFromSuperview];
    }
    _products = products;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 50, _prodView.frame.size.width, _prodView.frame.size.height - 50);
    [_prodView addSubview:scrollView];
    
    [self updateUI:scrollView data:products];
}

- (void)updateUI:(UIScrollView *)view data:(NSArray *)data
{
    
    NSMutableArray *cy = [NSMutableArray array];
    NSMutableArray *nonCy = [NSMutableArray array];
    for (NSDictionary *item in data) {
        if ([[item valueForKey:@"cpcybs"] intValue] == 1) {
            [cy addObject:item];
        } else if ([[item valueForKey:@"cpcybs"] intValue] == 0) {
            [nonCy addObject:item];
        }
    }
    int i = 0;
    CGFloat width = view.frame.size.width / 2;
    CGFloat btnH = 30;
    CGFloat startY = 10;
    startNonCyY = startY;
    for (NSDictionary *item in cy) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * (i % 2), startY + btnH * (i / 2), width, btnH);
        button.selected = NO;
        button.tag = [[item valueForKey:@"cpdm"] integerValue];
        button.userInteractionEnabled = NO;
        button.titleLabel.font = K_FONT_13;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        button.imageView.contentMode = UIViewContentModeCenter;
        UIImage *image = nil;
        if ([[item valueForKey:@"cpcybs"] intValue] == 1) {
            image = [Public imageFromColor:UIColorFromRGB(0xfe9142) size:CGSizeMake(5, 5)];
        } else if ([[item valueForKey:@"cpcybs"] intValue] == 0) {
            image = [Public imageFromColor:UIColorFromRGB(0xe7eaf2) size:CGSizeMake(5, 5)];
        }
        [button setImage:image forState:UIControlStateNormal];
        button.imageView.layer.cornerRadius = 2.5;
        button.imageView.clipsToBounds = YES;
        [button setTitle:[item valueForKey:@"cpmc"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x24344e) forState:UIControlStateNormal];
//        [button setTitleColor:RGB(68, 64, 73, 1.0) forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, width / 10, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, width / 10 + 15, 0, 0);
        [view addSubview:button];
        
        if (i % 2 == 0) {
            startNonCyY += btnH;
        }
        
        i++;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, startNonCyY + 10, view.bounds.size.width - 40, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xe7eaf2);
    [view addSubview:line];
    
    int j = 0;
    for (NSDictionary *item in nonCy) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * (j % 2),  CGRectGetMaxY(line.frame) + 10 + btnH * (j / 2), width, btnH);
        button.selected = NO;
        button.tag = [[item valueForKey:@"cpdm"] integerValue];
        button.userInteractionEnabled = NO;
        button.titleLabel.font = K_FONT_13;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        button.imageView.contentMode = UIViewContentModeCenter;
        UIImage *image = nil;
        if ([[item valueForKey:@"cpcybs"] intValue] == 1) {
            image = [Public imageFromColor:UIColorFromRGB(0xfe9142) size:CGSizeMake(5, 5)];
        } else if ([[item valueForKey:@"cpcybs"] intValue] == 0) {
            image = [Public imageFromColor:UIColorFromRGB(0xe7eaf2) size:CGSizeMake(5, 5)];
        }
        [button setImage:image forState:UIControlStateNormal];
        button.imageView.layer.cornerRadius = 2.5;
        button.imageView.clipsToBounds = YES;
        [button setTitle:[item valueForKey:@"cpmc"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x5a5a5a) forState:UIControlStateNormal];
//        [button setTitleColor:RGB(68, 64, 73, 1.0) forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, width / 10, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, width / 10 + 15, 0, 0);
        [view addSubview:button];
        
        if (j % 2 == 0) {
            startNonCyY += btnH ;
        }
        
        j++;
    }
    
    view.contentSize = CGSizeMake(view.bounds.size.width, startNonCyY + 30);
}

- (void)setRecommands:(NSArray *)recommands
{
    _recommands = recommands;
    
    Recommand *recom1 = recommands[0];
    _recomandName1.text = recom1.recommandName;
    _recomandDes1.text = recom1.recommandContent;
    
    Recommand *recom2 = recommands[1];
    _recomandName2.text = recom2.recommandName;
    _recomandDes2.text = recom2.recommandContent;
    
    Recommand *recom3 = recommands[2];
    _recomandName3.text = recom3.recommandName;
    _recomandDes3.text = recom3.recommandContent;
}

@end
