//
//  BusinessCell.h
//  Yelp
//
//  Created by Miles Spielberg on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessCell : UITableViewCell

@property NSInteger index;
@property (strong, nonatomic) Business *business;

@end
