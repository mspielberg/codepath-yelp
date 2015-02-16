//
//  SwitchCell.m
//  Yelp
//
//  Created by Miles Spielberg on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    self.switchLabel.text = title;
}

- (BOOL)on {
    return self.onOffSwitch.on;
}

- (void)setOn:(BOOL)on {
    NSLog(@"Entering setOn: %d", on);
    self.onOffSwitch.on = on;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onValueChanged:(id)sender {
    [self.delegate switchCell:self changedValue:self.on];
}

@end
