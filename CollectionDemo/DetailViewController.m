//
//  DetailViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.retrivedImage;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate detailViewControllerDidCancel:self];
}

@end
