//
//  DetailViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "DetailViewController.h"
#import "AddLogoTextViewController.h"
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"AddLogoText"])
    {
        NSLog(@"PASSING IMAGE TO EDIT");
        // Get reference to the destination view controller
        AddLogoTextViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.retrivedImage = self.retrivedImage;
    }
}

@end
