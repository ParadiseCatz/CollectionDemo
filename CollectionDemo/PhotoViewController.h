//
//  PhotoViewController.h
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
