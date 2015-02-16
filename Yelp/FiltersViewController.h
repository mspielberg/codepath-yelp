//
//  FiltersViewController.h
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpFilterSettings.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate

- (void)filtersViewController:(FiltersViewController *)filtersViewController didUpdateFilterSettings:(YelpFilterSettings *)filterSettings;

@end

@interface FiltersViewController : UIViewController

@property (weak, nonatomic) id<FiltersViewControllerDelegate>delegate;
@property (strong, nonatomic) YelpFilterSettings *filterSettings;

@end
