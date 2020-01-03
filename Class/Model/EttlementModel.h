//
//  EttlementModel.h
//  RMCalendar
//
//  Created by ark on 2019/12/11.
//  Copyright © 2019 迟浩东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EttlementModel : NSObject

@property (nonatomic , copy) NSString              * itemName;
@property (nonatomic , copy) NSString              * itemCode;
@property (nonatomic , copy) NSString              * settlementMethod;
@property (nonatomic , copy) NSString              * settlementValue;
@property (nonatomic , copy) NSString              * settlementFixValue;
@property (nonatomic , copy) NSString              * postpone;
@property (nonatomic , assign) BOOL                isPostpone;

@property (nonatomic , copy) NSString              * originWeek;
@property (nonatomic , copy) NSString              * originSettlementMethod;


@end

NS_ASSUME_NONNULL_END
