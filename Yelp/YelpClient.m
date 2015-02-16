//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "YelpFilterSettings.h"
#import "Units.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuth1Credential *cred = [BDBOAuth1Credential credentialWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:cred];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term filters:(YelpFilterSettings *)filters offset:(NSInteger)offset success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *baseParameters = @{@"term": term, @"offset": @(offset), @"ll" : @"37.774866,-122.394556"};
    NSDictionary *filterParameters = [self parametersForFilterSettings:filters];
    
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:baseParameters];

    if (filters) {
        [allParameters addEntriesFromDictionary:filterParameters];
    }
    
    NSLog(@"sending search parameters: %@", allParameters);
    
    return [self GET:@"search" parameters:allParameters success:success failure:failure];
}

- (NSDictionary *)parametersForFilterSettings:(YelpFilterSettings *)filterSettings {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (filterSettings.sortType > 0) {
        dict[@"sort"] = [NSString stringWithFormat:@"%ld", filterSettings.sortType];
    }
    
    if (filterSettings.activeCategories.count > 0) {
        dict[@"category_filter"] = [filterSettings.activeCategories componentsJoinedByString:@","];
    }
    
    dict[@"radius_filter"] = [NSString stringWithFormat:@"%f", filterSettings.searchRadiusInMiles * kMetersPerMile];
    
    if (filterSettings.dealsFilter) {
        dict[@"deals_filter"] = @"true";
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
