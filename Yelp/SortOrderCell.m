//
//  SortOrderCell.m
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SortOrderCell.h"

@interface SortOrderCell ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;

@end

@implementation SortOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)value {
    return self.sortOrderControl.selectedSegmentIndex;
}

- (void)setValue:(NSInteger)value {
    self.sortOrderControl.selectedSegmentIndex = value;
}

- (IBAction)onValueChanged:(id)sender {
    [self.delegate sortOrderCell:self didChangeValue:self.sortOrderControl.selectedSegmentIndex];
}

@end
