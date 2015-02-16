//
//  RadiusCell.h
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadiusCell;

@protocol RadiusCellDelegate

- (void)radiusCell:(RadiusCell *)radiusCell didSelectValue:(float)value;

@end

@interface RadiusCell : UITableViewCell

@property (nonatomic) float value;
@property (weak, nonatomic) id<RadiusCellDelegate> delegate;

@end
