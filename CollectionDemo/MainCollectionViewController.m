//
//  MainCollectionViewController.m
//  CollectionDemo
//
//  Created by Anthony on 6/3/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"MainCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainImagesURL = [[NSMutableArray alloc] init];
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
            NSLog(@"FAILED TO FECTH URLS");
            return;
        }
        NSError *JSONError;
        NSDictionary *receivedData = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError] objectForKey:@"result"];
        for (NSDictionary* key in receivedData) {
            NSString *value = [key objectForKey:@"instanceImageUrl"];
            NSURL *url = [NSURL URLWithString:value];
            [_mainImagesURL addObject:url];
            NSLog(@"%@",value);
        }
        NSLog(@"FINISHED FETCHING URLS");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadData];
            } completion:^(BOOL finished) {}];
            [self.collectionView layoutIfNeeded];

        });
    }];
    [downloadTask resume];

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
    NSData * imageData = [NSData dataWithContentsOfURL:[_mainImagesURL objectAtIndex:indexPath.row]];
    UIImage * image = [UIImage imageWithData:imageData scale:1];
    myCell.imageView.image = image;
    myCell.backgroundColor = [UIColor whiteColor];
    NSLog(@"CELL CREATED: %ld",(long)indexPath.row);
    return myCell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *image = [UIImage imageNamed:[_mainImagesURL objectAtIndex:indexPath.row]];
//    //You may want to create a divider to scale the size by the way..
//    return CGSizeMake(image.size.width, image.size.height);
//}

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

@end
