//
//  RadiusCell.m
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RadiusCell.h"
#import "Units.h"
#import "NSArray+ArrayOps.h"

@interface RadiusCell ()

@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (nonatomic) float previousValue;
@property (strong, nonatomic) NSArray *allowedValues;

@end

@implementation RadiusCell

- (void)awakeFromNib {
    // Initialization code
    self.allowedValues = @[@1.0, @5.0, @10.0, @25.0];
    self.previousValue = self.radiusSlider.value;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setValue:(float)value {
    _value = [self constrainedValue:value];
    self.radiusSlider.value = _value;
    [self updateLabelWithValue:_value];
}


- (IBAction)onSliderChanged:(id)sender {
    float radiusInMiles = self.radiusSlider.value;
    float constrainedRadius = [self constrainedValue:radiusInMiles];
    if (constrainedRadius != self.previousValue) {
        self.previousValue = constrainedRadius;
        [self updateLabelWithValue:constrainedRadius];
        _value = constrainedRadius;
        [self.delegate radiusCell:self didSelectValue:constrainedRadius];
    }
}

- (void)updateLabelWithValue:(float)value {
    self.radiusLabel.text = [NSString stringWithFormat:@"%.0f mi", value];
}

- (float)constrainedValue:(float)value {
    NSNumber *selected = [self.allowedValues firstItemMatching:^BOOL(NSNumber *item) {
        return [item floatValue] >= value;
    }];
    
    if (selected) {
        return [selected floatValue];
    } else {
        return [self.allowedValues.firstObject floatValue];
    }
}

@end
