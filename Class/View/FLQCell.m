//
//  FLQCell.m
//  RMCalendar
//
//  Created by ark on 2019/12/12.
//  Copyright © 2019 迟浩东. All rights reserved.
//

#import "FLQCell.h"

@interface FLQCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *descL;

@end

@implementation FLQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setEttModel:(EttlementModel *)ettModel
{
    _ettModel=ettModel;
        
    self.titleL.text=[NSString stringWithFormat:@"项目编号: %@ 号 \n项目名: %@",ettModel.itemCode,ettModel.itemName];
        
    if([ettModel.settlementMethod isEqualToString:@"W"]){
        if (ettModel.originWeek.length) {
            self.descL.text=[NSString stringWithFormat:@"购买方式每周 %@",ettModel.originWeek];
        }else{
            self.descL.text=[NSString stringWithFormat:@"购买方式每周 %@",ettModel.settlementValue];

        }
      }
    else if ([ettModel.settlementMethod isEqualToString:@"M"]) {
        if (ettModel.settlementFixValue.length) {
            self.descL.textColor=UIColor.redColor;
            self.descL.text=[NSString stringWithFormat:@"原购买方式每月 %@,遇节假日购买日期调整为%@日",ettModel.settlementValue,ettModel.settlementFixValue];
        }else{
            self.descL.text=[NSString stringWithFormat:@"购买方式每月 %@ 日",ettModel.settlementValue];
        }
        
    }

}


@end
