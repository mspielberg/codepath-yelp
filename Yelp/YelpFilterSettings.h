//
//  YelpFilterSettings.h
//  Yelp
//
//  Created by Miles Spielberg on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpFilterSettings : NSObject <NSCopying>

@property NSInteger sortType;
@property float searchRadiusInMiles;
@property BOOL dealsFilter;
@property NSArray *activeCategories;

@end
