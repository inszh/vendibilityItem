//
//  UITableViewCell+ACExtension.m
//  AirChina
//
//  Created by ark on 2019/11/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "UITableViewCell+ACExtension.h"


@implementation UITableViewCell (ACExtension)

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID =@"cellID";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        NSString *name=NSStringFromClass(self);

        cell=[[[NSBundle  mainBundle]loadNibNamed:name owner:self options:nil]  lastObject];
    }
    
    return cell;
}

@end
