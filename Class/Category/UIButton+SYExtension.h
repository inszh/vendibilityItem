//
//  UIButton+SYExtension.h
//  BaseFrame
//
//  Created by 小华 on 2018/10/19.
//  Copyright © 2018年 everjiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchedBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SYExtension)

- (void)addTargetBlock:(TouchedBlock)touchHandler;




@end

NS_ASSUME_NONNULL_END
