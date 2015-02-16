//
//  Business.h
//  Yelp
//
//  Created by Miles Spielberg on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

- (Business *)initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *streetAddress;
@property NSString *city;
@property NSArray *neighborhoods;
@property NSString *name;
@property NSString *phoneNumber;
@property NSInteger rating;
@property NSInteger reviewCount;
@property NSURL *ratingImageUrl;
@property NSString *ratingSnippet;
@property NSNumber *distanceInMeters;
@property NSArray *categories;

@end
