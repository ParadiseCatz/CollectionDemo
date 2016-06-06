//
//  DetailViewController.h
//  CollectionDemo
//
//  Created by Anthony on 6/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>
- (void)detailViewControllerDidCancel:(DetailViewController *)controller;
@end

@interface DetailViewController : UIViewController


@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImage *retrivedImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
