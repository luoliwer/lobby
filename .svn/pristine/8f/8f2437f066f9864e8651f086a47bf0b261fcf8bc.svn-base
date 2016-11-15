//
//  PublicAppointmentView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/10/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "PublicAppointmentView.h"
#import "CustomIndicatorView.h"

@implementation PublicAppointmentView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setPragrames:(NSArray *)pragrames
{
    _pragrames = pragrames;
    
    //访问接口
    [self dateDetail:_pragrames];
}

- (void)dateDetail:(NSArray *)pragram
{
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:pragram[0] forKey:@"dqdh"];
    [paramDic setObject:pragram[1] forKey:@"jgdh"];
    [paramDic setObject:pragram[2] forKey:@"ywzl"];
    [paramDic setObject:pragram[3] forKey:@"yybh"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
//        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSDictionary *result = [responseInfo valueForKey:@"result"];
                //设置时间
                NSString *dateTime = result[@"cjsj"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMdd"];
                NSDate *d = [formatter dateFromString:dateTime];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                self.timeLabel.text = [formatter stringFromDate:d];
                
                NSDictionary *keyValueDic = nil;//业务类型
                NSDictionary *accountDic = nil;//公司性质类型
                NSDictionary *dateTypeDic = nil;//预约状态类型
                //从本地获取客户层级
                NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
                NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                if (rootDic) {
                    NSArray *branches = rootDic[@"Root"];
                    NSMutableDictionary *tempDic1 = [NSMutableDictionary dictionary];
                    NSMutableDictionary *tempDic2 = [NSMutableDictionary dictionary];
                    NSMutableDictionary *tempDic3 = [NSMutableDictionary dictionary];
                    for (NSDictionary *item in branches) {
                        if ([@"OTO_DGYW" isEqualToString:item[@"codeType"]]) {
                            NSString *val = item[@"codeValue"];
                            NSString *key = item[@"codeId"];
                            [tempDic1 addEntriesFromDictionary:@{key:val}];
                        } else if ([@"OTO_ZHXZ" isEqualToString:item[@"codeType"]]) {
                            NSString *val = item[@"codeValue"];
                            NSString *key = item[@"codeId"];
                            [tempDic2 addEntriesFromDictionary:@{key:val}];
                        } else if ([@"OTO_BITP" isEqualToString:item[@"codeType"]]) {
                            NSString *val = item[@"codeValue"];
                            NSString *key = item[@"codeId"];
                            [tempDic3 addEntriesFromDictionary:@{key:val}];
                        }
                    }
                    keyValueDic = tempDic1;
                    accountDic = tempDic2;
                    dateTypeDic = tempDic3;
                }
                
                //设置业务类型
                NSString *busTypeKey = result[@"ywzl"];
                NSString *busVal = keyValueDic[busTypeKey];
                self.typeLabel.text = busVal ? : @"未知";
                //设置姓名
                self.customerNameLabel.text = result[@"sqkhrxm"];
                //设置联系电话
                self.phoneLabel.text = result[@"cwlxrsjhm"];
                //设置公司名称
                self.agentNameLabel.text = result[@"gsmc"];
                //设置账户性质
                NSString *accTypeKey = result[@"zhxz"];
                NSString *accTypeVal = accountDic[accTypeKey];
                self.characterLabel.text = accTypeVal ? : @"未知";
                //设置状态
                NSString *statusKey = result[@"yyzt"];
                NSString *statusVal = dateTypeDic[statusKey];
                self.statusLabel.text = statusVal ? : @"未知";
            }
        }
    };
    
    [InvokeManager invokeApi:@"otodgxx" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (IBAction)close:(id)sender {
    [self.superview removeFromSuperview];
}
@end
