//
//  SortOrderCell.h
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortOrderCell;

@protocol SortOrderCellDelegate

- (void)sortOrderCell:(SortOrderCell *)sortOrderCell didChangeValue:(NSInteger)value;

@end

@interface SortOrderCell : UITableViewCell

@property (weak, nonatomic) id<SortOrderCellDelegate> delegate;
@property (nonatomic) NSInteger value;

@end
