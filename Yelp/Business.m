//
//  Business.h
//  Yelp
//
//  Created by Miles Spielberg on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"
#import "NSArray+ArrayOps.h"

@implementation Business

- (Business *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
        NSDictionary *location = dictionary[@"location"];
        self.streetAddress = [location[@"address"] firstObject];
        self.city = location[@"city"];
        self.neighborhoods = location[@"neighborhoods"];
        self.name = dictionary[@"name"];
        self.phoneNumber = dictionary[@"display_phone"];
        self.rating = [dictionary[@"rating"] integerValue];
        self.reviewCount = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = [NSURL URLWithString:dictionary[@"rating_img_url"]];
        self.ratingSnippet = dictionary[@"snippet_text"];
        self.distanceInMeters = dictionary[@"distance"];
        NSArray *rawCategories = dictionary[@"categories"];
        self.categories = [rawCategories mapWithBlock:^id(NSArray *x) {
            return [x firstObject];
        }];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Business: %p; name='%@'>", self, self.name];
}

@end
