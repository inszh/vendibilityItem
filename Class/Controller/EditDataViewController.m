//
//  EditDataViewController.m
//  RMCalendar
//
//  Created by ark on 2019/12/19.
//  Copyright © 2019 迟浩东. All rights reserved.
//

#import "EditDataViewController.h"

@interface EditDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemNameTF;
@property (weak, nonatomic) IBOutlet UITextField *itemValueTF;
@property (weak, nonatomic) IBOutlet UIButton *itemBuyBtnM;
@property (weak, nonatomic) IBOutlet UIButton *itemBuyBtnW;
@property (weak, nonatomic) IBOutlet UITextField *itemBuyDayTF;

@end

@implementation EditDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setData];
}

- (void)setData
{
    if (self.dataModel.itemName) {
        self.itemNameTF.text=self.dataModel.itemName;
    }
    
    if (self.dataModel.itemCode) {
        self.itemValueTF.text=self.dataModel.itemCode;
    }
    
    if (self.dataModel.settlementValue) {
        self.itemBuyDayTF.text=self.dataModel.settlementValue;
    }
    
    [self.itemBuyDayTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    
//    if (self.dataModel.itemName) {
//        self.itemNameTF.text=self.dataModel.itemName;
//    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldChanged:(UITextField*)textField
{
    if (textField.text.intValue > 31 ) {
        textField.text=@"";
    }
}

@end
