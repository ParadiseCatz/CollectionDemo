//
//  CustomErrorAlertController.m
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SimpleErrorAlertController.h"

@interface SimpleErrorAlertController ()

@end

@implementation SimpleErrorAlertController

+ (instancetype)alertControllerWithMessage:(NSString *)message {
    return [super alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    [self addAction:cancel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
