//
//  RemindCollectCell.h
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/24.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expiration;
typedef enum : NSUInteger {
    RemindStatusUndo,
    RemindStatusDoing,
    RemindStatusTurn,
    RemindStatusClose,
    RemindStatusFinished,
} RemindStatus;

@interface RemindCollectCell : UICollectionViewCell

@property (nonatomic, strong) Expiration *expiration;

@end
