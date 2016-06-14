//
//  PhotoViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "PhotoViewController.h"
#import "DetailViewController.h"
#import "SimpleErrorAlertController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        SimpleErrorAlertController *alertView = [SimpleErrorAlertController alertControllerWithMessage:@"Device has no camera"];
        [self.parentViewController presentViewController: alertView animated:YES completion:nil];
        
    }
    else{
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self.parentViewController presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView setUserInteractionEnabled:YES];
}

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"IMAGE TAPPED");
    [self performSegueWithIdentifier: @"showDetail" sender: self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSLog(@"PASSING IMAGE");
        // Get reference to the destination view controller
        UINavigationController *navController = [segue destinationViewController];
        DetailViewController *vc = (DetailViewController *)[navController topViewController];
        
        // Pass any objects to the view controller here, like...
        vc.retrivedImage = self.imageView.image;
        vc.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = image;
    NSLog(@"IMAGE PICKED");
    
}
- (IBAction)takeFromPhotos:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self.parentViewController presentViewController:imagePicker animated:YES completion:NULL];
}


#pragma mark - DetailViewControllerDelegate

- (void)detailViewControllerDidCancel:(DetailViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
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
