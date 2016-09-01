//
//  ViewController.h
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//1 插入数据
@property (weak, nonatomic) IBOutlet UITextField *textField0;

@property (weak, nonatomic) IBOutlet UITextField *textField1;
- (IBAction)insertBtnClicked:(id)sender;

//4 更新数据
@property (weak, nonatomic) IBOutlet UITextField *updateIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *updateDataTextField;


- (IBAction)updateBtnClicked:(id)sender;

//3 查询数据
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
- (IBAction)queryDataBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;

- (IBAction)nextPageBtnCicked:(id)sender;

@end

