//
//  NSString+Size.h
//  CommercialTenantClient
//
//  Created by YangChao on 28/7/15.
//  Copyright (c) 2015年 cdrcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
