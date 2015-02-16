//
//  BusinessCell.m
//  Yelp
//
//  Created by Miles Spielberg on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"
#import "Units.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starsImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.locationLabel.preferredMaxLayoutWidth = self.locationLabel.frame.size.width;
    self.categoriesLabel.preferredMaxLayoutWidth = self.categoriesLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    [self.businessImageView setImageWithURL:self.business.imageUrl];
    self.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", self.index + 1, self.business.name];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", [self.business.distanceInMeters floatValue] * kMilesPerMeter];
    [self.starsImageView setImageWithURL:self.business.ratingImageUrl];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%ld reviews", self.business.reviewCount];
    self.locationLabel.text = self.business.streetAddress;
    if (self.business.neighborhoods.count > 0) {
        self.locationLabel.text = [self.locationLabel.text stringByAppendingFormat:@", %@", [self.business.neighborhoods componentsJoinedByString:@", "]];
    }
    self.categoriesLabel.text = [self.business.categories componentsJoinedByString:@", "];
    
}

@end
