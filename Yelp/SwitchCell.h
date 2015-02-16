//
//  SwitchCell.h
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate

- (void)switchCell:(SwitchCell *)switchCell changedValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (strong, nonatomic) NSString *title;
@property (nonatomic) BOOL on;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

@end
