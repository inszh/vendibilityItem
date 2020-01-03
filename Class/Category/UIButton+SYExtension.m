//
//  UIButton+SYExtension.m
//  BaseFrame
//
//  Created by 小华 on 2018/10/19.
//  Copyright © 2018年 everjiankang. All rights reserved.
//

#import "UIButton+SYExtension.h"
#import <objc/runtime.h>
@implementation UIButton (SYExtension)

static const void *UIButtonBlockKey = &UIButtonBlockKey;

-(void)addTargetBlock:(TouchedBlock)touchHandler
{
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)actionTouched:(UIButton *)btn
{
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}




@end
