//
//  MainCollectionViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/3/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"
#import "DetailViewController.h"
#import "SimpleErrorAlertController.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController
{
    UIImage *selectedImage;
}

static NSString * const reuseIdentifier = @"MainCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainImagesURL = [[NSMutableArray alloc] init];
    _mainImages = [[NSMutableArray alloc] init];
    _imageHasLoaded = [[NSMutableArray alloc] init];
    _imageDownloadLock = [[NSMutableArray alloc] init];
    NSString *urlAsString = @"http://version1.api.memegenerator.net/Instances_Select_ByPopular?languageCode=en&pageIndex=0&pageSize=12&urlName=Insanity-Wolf&days=7";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    //NSLog(@"%@", urlAsString);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:5.0];
    // create the connection with the request
    // and start loading the data
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            SimpleErrorAlertController *alertView = [SimpleErrorAlertController alertControllerWithMessage:@"Device has no camera"];
            [self presentViewController: alertView animated:YES completion:nil];
            return;
        }
        NSError *JSONError;
        NSDictionary *receivedData = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError] objectForKey:@"result"];
        for (NSDictionary* key in receivedData) {
            NSString *value = [key objectForKey:@"instanceImageUrl"];
            NSURL *url = [NSURL URLWithString:value];
            [_mainImagesURL addObject:url];
            [_mainImages addObject:[UIImage alloc]];
            [_imageHasLoaded addObject:@(NO)];
            [_imageDownloadLock addObject:dispatch_semaphore_create(1)];
            NSLog(@"%@",value);
        }
        NSLog(@"FINISHED FETCHING URLS");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [self.collectionView reloadData];
            [self.collectionView layoutIfNeeded];

        });
    }];
    [downloadTask resume];
    
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
  //  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu",_mainImagesURL.count);
    return _mainImagesURL.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CREATE CELL: %ld",(long)indexPath.row);
    MainCollectionViewCell *myCell = (MainCollectionViewCell *)[collectionView
                                    dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                    forIndexPath:indexPath];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    [myCell addSubview:spinner];
    [spinner startAnimating];
    
    myCell.imageView.image = nil;
//    myCell.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myCell.bounds.size.width, myCell.bounds.size.height)];
    NSLog(@"%lf",myCell.bounds.size.width);
    
    myCell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
    if ([[_imageHasLoaded objectAtIndex:indexPath.row]  isEqual: @(NO)]) {
        
        dispatch_async(myCustomQueue, ^{
            dispatch_semaphore_wait([_imageDownloadLock objectAtIndex:indexPath.row], DISPATCH_TIME_FOREVER);
            if ([[_imageHasLoaded objectAtIndex:indexPath.row]  isEqual: @(YES)]) {
                dispatch_semaphore_signal([_imageDownloadLock objectAtIndex:indexPath.row]);
                return;
            }
            NSData * imageData = [NSData dataWithContentsOfURL:[_mainImagesURL objectAtIndex:indexPath.row]];
            UIImage * image = [UIImage imageWithData:imageData scale:1];
            if (image) {
                [_mainImages replaceObjectAtIndex:indexPath.row withObject:image];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner removeFromSuperview];
                myCell.imageView.image = image;
                [_imageHasLoaded replaceObjectAtIndex:indexPath.row withObject:@(YES)];
            });
            NSLog(@"IMAGE FETCHED: %ld",(long)indexPath.row);
            dispatch_semaphore_signal([_imageDownloadLock objectAtIndex:indexPath.row]);
        });
    } else {
        dispatch_async(myCustomQueue, ^{
            dispatch_semaphore_wait([_imageDownloadLock objectAtIndex:indexPath.row], DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner removeFromSuperview];
                myCell.imageView.image = [_mainImages objectAtIndex:indexPath.row];
                NSLog(@"CONTENT MODE: %ld",(long)myCell.imageView.contentMode);

            });
            NSLog(@"USE IMAGE FROM STORAGE: %ld",(long)indexPath.row);
            dispatch_semaphore_signal([_imageDownloadLock objectAtIndex:indexPath.row]);
        });
    }
    myCell.imageView.contentMode = UIViewContentModeScaleToFill;
    
    NSLog(@"CELL CREATED: %ld",(long)indexPath.row);
    return myCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If you need to use the touched cell, you can retrieve it like so
    MainCollectionViewCell *cell = (MainCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedImage = cell.imageView.image;
    if ([[_imageHasLoaded objectAtIndex:indexPath.row]  isEqual: @(YES)]) {
        [self performSegueWithIdentifier: @"showDetail" sender: self];
    }
    NSLog(@"touched cell %@ at indexPath %ld", cell, (long)indexPath.row);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSLog(@"PASSING IMAGE");
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.retrivedImage = selectedImage;
        vc.delegate = self;
    }
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *image = [UIImage imageNamed:[_mainImagesURL objectAtIndex:indexPath.row]];
//    //You may want to create a divider to scale the size by the way..
//    return CGSizeMake(image.size.width, image.size.height);
//}

#pragma mark - DetailViewControllerDelegate

- (void)detailViewControllerDidCancel:(DetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


@end
