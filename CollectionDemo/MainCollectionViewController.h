//
//  MainCollectionViewController.h
//  CollectionDemo
//
//  Created by Anthony on 6/3/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface MainCollectionViewController : UICollectionViewController <DetailViewControllerDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *mainImagesURL;
@property (strong, nonatomic) NSMutableArray *mainImages;
@property (strong, atomic) NSMutableArray *imageHasLoaded;
@property (strong, atomic) NSMutableArray *imageDownloadLock;
@end
