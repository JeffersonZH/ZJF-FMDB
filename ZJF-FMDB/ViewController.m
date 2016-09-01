//
//  ViewController.m
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import "ViewController.h"
#import "ZJFDBManager.h"
#import "SecondViewController.h"

#define PATH @"/Users/zjf/Desktop/iOS开发/Demo/ZJF-FMDB/ZJF-FMDB/zjfdb.sqlite"

@interface ViewController ()
{
    ZJFDBManager * dataBase;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建数据库（初始化）
    dataBase = [[ZJFDBManager alloc] initWithPath:PATH];

    //创建表单：车次记录表单
    [dataBase createList:@"数据" columns:@{@"ID":@"integer",@"车次":@"char(128)"} primaryKey:@"ID"];
}

//1 插入数据:将输入的数据存到数据库
- (IBAction)insertBtnClicked:(id)sender {
    if ((_textField0.text.length == 0) || (_textField1.text.length == 0)) {
        [self showAlertViewWithString:@"请输入完整信息"];
    }
    else {
        NSString * string = [NSString stringWithFormat:@"'%@'", _textField1.text];
        NSDictionary * dic = @{@"ID":_textField0.text,@"车次":string};
        BOOL ret = [dataBase insertRecordFromDictionary:dic intoList:@"数据"];
        if (ret) {
            [self showAlertViewWithString:@"数据插入成功"];
        }
        else {
            [self showAlertViewWithString:@"数据插入失败"];
        }
    }
}

//3 查询数据
- (IBAction)queryDataBtnClicked:(id)sender {
    if (_idTextField.text.length == 0) {
        [self showAlertViewWithString:@"请输入ID"];
    }
    else {
        NSString * whereString = [NSString stringWithFormat:@"where ID=%@",_idTextField.text];
        
        FMResultSet * set = [dataBase select:nil fromList:@"数据" where:whereString];
        while ([set next]) {
            _outputLabel.text = [set stringForColumn:@"车次"];
        }
    }
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

- (IBAction)nextPageBtnCicked:(id)sender {
    SecondViewController * secondVC = [[SecondViewController alloc] init];
    [self presentViewController:secondVC animated:YES completion:nil];
}

//2 更新数据
- (IBAction)updateBtnClicked:(id)sender {
    if (_updateIdTextField.text.length == 0 || _updateDataTextField.text.length == 0) {
        [self showAlertViewWithString:@"请输入完整信息"];
    }
    else {
        //注：char类型数据要加单引号“‘”
        NSString * updateString = [NSString stringWithFormat:@"'%@'", _updateDataTextField.text];
        //修改指定ID的车次数据
        BOOL ret = [dataBase updateDictionary:@{@"车次":updateString} fromList:@"数据" where:@{@"ID":_updateIdTextField.text}];
        if (ret) {
            [self showAlertViewWithString:@"数据更新成功"];
        }
        else {
            [self showAlertViewWithString:@"数据更新失败"];
        }
    }
}




@end
