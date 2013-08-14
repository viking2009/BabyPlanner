//
//  BPSymptomsAndMoodCollectionViewCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSymptomsAndMoodCollectionViewCell.h"
#import "BPUtils.h"

@implementation BPSymptomsAndMoodCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeBottom;
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        self.titleLabel.textColor = RGB(70, 70, 70);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        UIImage *normalImage = [BPUtils imageNamed:@"symptoms_icon_background_normal"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:normalImage];
//        backgroundView.contentMode = UIViewContentModeCenter;
        self.backgroundView = backgroundView;
        
        UIImage *selectedImage = [BPUtils imageNamed:@"symptoms_icon_background_selected"];
        UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
//        selectedBackgroundView.contentMode = UIViewContentModeCenter;
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
        
    rect.size.height -= BPSymptomsAndMoodDefaultTitleHeight;
    self.imageView.frame = rect;
    self.backgroundView.frame = rect;
    self.selectedBackgroundView.frame = rect;
    
    rect.origin.y = rect.size.height;
    rect.size.height = BPSymptomsAndMoodDefaultTitleHeight;
    self.titleLabel.frame = rect;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    else
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    else
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
}

@end
