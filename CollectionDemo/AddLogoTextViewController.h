//
//  AddLogoTextViewController.h
//  CollectionDemo
//
//  Created by Anthony on 6/14/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLogoTextViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImage *retrivedImage;
@property (strong, nonatomic) IBOutlet UIImage *templateImage;
@property (strong, nonatomic) IBOutlet UIImage *resultImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end
