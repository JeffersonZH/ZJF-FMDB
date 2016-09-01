//
//  SecondViewController.h
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *idTextField;


- (IBAction)queryBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;


- (IBAction)backBtnClicked:(id)sender;

@end
