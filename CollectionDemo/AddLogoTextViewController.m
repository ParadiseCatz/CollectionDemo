//
//  AddLogoTextViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/14/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "AddLogoTextViewController.h"

@interface AddLogoTextViewController ()

@end

@implementation AddLogoTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textField setReturnKeyType:UIReturnKeyDone];
    self.textField.delegate = self;
    UIImage *backgroundImage = self.retrivedImage;
    UIImage *watermarkImage = [UIImage imageNamed:@"Image"];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    self.templateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.resultImage = [self burnTextIntoImage:self.textField.text :self.templateImage];
    self.imageView.image = self.templateImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Creates an image with a home-grown graphics context, burns the supplied string into it. */
- (UIImage *)burnTextIntoImage:(NSString *)text :(UIImage *)img {
    
    UIGraphicsBeginImageContext(img.size);
    
    CGRect rect = CGRectMake(0,0, img.size.width, img.size.height);
    [img drawInRect:rect];
    
    [[UIColor redColor] set];           // set text color
    NSInteger fontSize = 24;
    if ( [text length] > 200 ) {
        fontSize = 10;
    }
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [text sizeWithAttributes:@{font: font}];
    CGRect r = CGRectMake(rect.origin.x,
                          rect.origin.y + (rect.size.height - 2*size.height)/2,
                          rect.size.width,
                          (rect.size.height - size.height)/2);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    [text drawInRect:r withAttributes:@{NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: font}];
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
    UIGraphicsEndImageContext();     // clean  up the context.
    return theImage;
}
- (IBAction)eraseText:(id)sender {
    self.imageView.image = self.templateImage;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.resultImage = [self burnTextIntoImage:self.textField.text :self.templateImage];
    [textField resignFirstResponder];
    return NO;
}
- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"shareButton pressed");
    UIImage *imagetoshare = self.resultImage;
    NSArray *activityItems = @[imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[
     UIActivityTypePostToWeibo,
     UIActivityTypePrint,
     UIActivityTypeCopyToPasteboard,
     UIActivityTypeAssignToContact,
     UIActivityTypeAddToReadingList,
     UIActivityTypePostToFlickr,
     UIActivityTypePostToVimeo,
     UIActivityTypePostToTencentWeibo,
     UIActivityTypeAirDrop];

    activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed) {
            if ([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
                NSLog(@"%@ was performed.", activityType);
                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Saved to Camera" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [Alert show];
            }
            
        } else {
            if (activityType == NULL) {
                //   NSLog(@"User dismissed the view controller without making a selection.");
            } else {
                //  NSLog(@"Activity was not performed.");
            }
        }
    };
    [self presentViewController:activityVC animated:TRUE completion:nil];
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
