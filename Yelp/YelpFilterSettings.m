//
//  YelpFilterSettings.m
//  Yelp
//
//  Created by Miles Spielberg on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "YelpFilterSettings.h"

@implementation YelpFilterSettings

- (YelpFilterSettings *)init {
    self = [super init];
    if (self) {
        self.sortType = 0;
        self.searchRadiusInMiles = 5.0;
        self.dealsFilter = NO;
        self.activeCategories = @[];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    YelpFilterSettings *copy = [[self.class allocWithZone:zone] init];
    copy.sortType = self.sortType;
    copy.searchRadiusInMiles = self.searchRadiusInMiles;
    copy.dealsFilter = self.dealsFilter;
    copy.activeCategories = [self.activeCategories copyWithZone:zone];
    return copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; sortType=%ld, searchRadius=%f, dealsFilter=%d, categories=%@", self.class, self, self.sortType, self.searchRadiusInMiles, self.dealsFilter, self.activeCategories];
}

@end
