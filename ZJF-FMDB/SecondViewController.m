//
//  SecondViewController.m
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import "SecondViewController.h"
#import "ZJFDBManager.h"

#define PATH @"/Users/zjf/Desktop/iOS开发/Demo/ZJF-FMDB/ZJF-FMDB/zjfdb.sqlite"

@interface SecondViewController ()
{
    ZJFDBManager * dataBase;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dataBase = [[ZJFDBManager alloc] initWithPath:PATH];
    

}



- (IBAction)queryBtnClicked:(id)sender {
    if (_idTextField.text.length == 0) {
        [self showAlertViewWithString:@"请输入完整信息"];
    }
    else {
        NSString * whereString = [NSString stringWithFormat:@"where ID=%@",_idTextField.text];
        
        FMResultSet * set = [dataBase select:nil fromList:@"数据" where:whereString];
        while ([set next]) {
            _outputLabel.text = [set stringForColumn:@"车次"];
        }
    }
    
    
}


- (IBAction)backBtnClicked:(id)sender {
    //返回到上一个界面：dissmiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)showAlertViewWithString:(NSString *)msg {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
