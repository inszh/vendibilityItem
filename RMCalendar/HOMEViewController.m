//
//  HOMEViewController.m
//  RMCalendar
//
//  Created by ark on 2020/1/1.
//  Copyright © 2020 迟浩东. All rights reserved.
//

#import "HOMEViewController.h"
#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"
#import "EttlementModel.h"
#import "FLQViewController.h"
#import "FLQdatas.h"
#import "AFNTool.h"
#import "MBProgressHUD.h"

@interface HOMEViewController ()

@property(nonatomic,copy)NSMutableArray *dateArray;

@end

@implementation HOMEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self btnClick];
}



- (void)btnClick
{
    
    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeSingle];
    
    NSArray *Emodels=[EttlementModel objectArrayWithKeyValuesArray:[FLQdatas formatDats]];
    
    __block NSMutableArray *tempArray=[NSMutableArray array];
    
    __block NSMutableArray *holidayArray=[NSMutableArray array];

    dispatch_group_t group = dispatch_group_create();

    __weak typeof(c) weakC = c;
    
    c.resultBlock = ^(NSArray *array) {

        NSMutableArray *lastArray=array.firstObject;
        RMCalendarModel *lastDay=lastArray.lastObject;
        dispatch_group_enter(group);

        NSString *month;
        if (lastDay.month<10) {
            month=[NSString stringWithFormat:@"0%lu",(unsigned long)lastDay.month];
        }else{
            month=[NSString stringWithFormat:@"%lu",(unsigned long)lastDay.month];
        }
        NSString *key=[NSString stringWithFormat:@"%lu%@",(unsigned long)lastDay.year,month];
        NSString *url=[NSString stringWithFormat:@"http://www.easybots.cn/api/holiday.php?m=%@",key];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakC.view animated:YES];
        
        hud.label.text = @"加载节日信息";
                   
       [AFNTool postWithURl:url parameters:nil success:^(id responseObject) {
           
           NSDictionary *dict=responseObject[key];
           
           self.dateArray=[NSMutableArray arrayWithArray:dict.allKeys];

           dispatch_group_leave(group);
           
           [hud hideAnimated:YES];

       } failure:^(NSError *error) { [hud hideAnimated:YES];}];
        
        dispatch_group_t group2 = dispatch_group_create();

        
        dispatch_group_enter(group2);

        NSRange r1 = {0,1};
        NSRange r2 = {1,1};
        __block NSString * dayStr;
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{

            [lastArray enumerateObjectsUsingBlock:^(RMCalendarModel *lastDay, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dateArray enumerateObjectsUsingBlock:^(NSString *day, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *fixDay=[day substringWithRange:r1];
                    if ([fixDay isEqualToString:@"0"]) {
                        dayStr=[day substringWithRange:r2];
                    }else{
                        dayStr=day;
                    }
                    
                    if (lastDay.day == dayStr.integerValue) {
                        lastDay.isHoliday=YES;
                    }
                }];
            }];
            
            dispatch_group_leave(group2);

        });

        dispatch_group_notify(group2, dispatch_get_main_queue(), ^{
            
            tempArray=lastArray.mutableCopy;

            [lastArray enumerateObjectsUsingBlock:^(RMCalendarModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL isWeekend = (model.week ==1 || model.week == 7);
                if (isWeekend && (model.month == lastDay.month && model.year == lastDay.year)) {
                    model.isHoliday=YES;
                }else if (model.month != lastDay.month && model.year != lastDay.year){
                    [tempArray removeObject:model];
                }
                
            }];
            
            [tempArray enumerateObjectsUsingBlock:^(RMCalendarModel *dateModel, NSUInteger idx, BOOL * _Nonnull stop) {

                [Emodels enumerateObjectsUsingBlock:^(EttlementModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {

                    if ([obj.settlementMethod isEqualToString:@"M"] && (obj.settlementValue.integerValue== dateModel.day)) {//月
                        
                        if (dateModel.isHoliday) {
                            RMCalendarModel *tempModel=[self checkHoliday:tempArray withCurrentItem:obj];
                            [tempModel.items addObject:obj];
                            [holidayArray addObject:tempModel];
                        }else{//平日
                            [dateModel.items addObject:obj];
                        }
  
                    }else if ([obj.settlementMethod isEqualToString:@"W"]&& (obj.settlementValue.integerValue == (dateModel.week -1))) {//周
                        if (dateModel.isHoliday) {
                            obj.originWeek=obj.settlementValue;
                            obj.settlementValue=[NSString stringWithFormat:@"%lu",(unsigned long)dateModel.day];
                            RMCalendarModel *tempModel=[self checkHoliday:tempArray withCurrentItem:obj];
                            [tempModel.items addObject:obj];
                            [holidayArray addObject:tempModel];
                        }else{//平日
                            [dateModel.items addObject:obj];
                        }
                    }
                }];
            }];
            
             __strong typeof(weakC) strongC = weakC;
            [tempArray addObjectsFromArray:holidayArray];
            [strongC.collectionView reloadData];
        });
        
    };
    
    c.isDisplayChineseCalendar = YES;
    c.isEnable = YES;
    c.title = @"日历";
    c.calendarBlock = ^(RMCalendarModel *model) {
        
        FLQViewController *flq=FLQViewController.new;
        flq.dataSouce=model.items.copy;
        [self.navigationController pushViewController:flq animated:YES];

    };
    [self.navigationController pushViewController:c animated:NO];
    
}

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray=[NSMutableArray array];
    }
    return _dateArray;

}


- (RMCalendarModel *)checkHoliday:(NSArray *)lastArray withCurrentItem:(EttlementModel *)item
{
    NSMutableArray * minArray=[NSMutableArray array];
    NSInteger dayInt=0;
    NSInteger minValue=0;
    NSInteger itemDay=0;
    for (RMCalendarModel *model in lastArray) {
        if (!model.isHoliday) {
            
            dayInt=model.day;
            itemDay=item.settlementValue.integerValue;
            
            if (model.day > itemDay) {
                minValue= dayInt- itemDay;
                NSNumber *minStr=[NSNumber numberWithLong:minValue];
                [minArray addObject:@{ minStr : model }];
            }
        }
    }

    NSArray *resultArray = [minArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [[obj1 allKeys] objectAtIndex:0];
        NSNumber *number2 = [[obj2 allKeys] objectAtIndex:0];
        NSComparisonResult result = [number1 compare:number2];
        return result == NSOrderedDescending; // 升序
    }];

    NSDictionary *dict=resultArray.firstObject;
    RMCalendarModel *model= dict.allValues.firstObject;
    
    item.settlementFixValue=[NSString stringWithFormat:@"%lu",(unsigned long)model.day];
    NSLog(@"原始日期%@号因节假日调整为%lu号",item.settlementValue,(unsigned long)model.day);
    
    return model;

}

@end
