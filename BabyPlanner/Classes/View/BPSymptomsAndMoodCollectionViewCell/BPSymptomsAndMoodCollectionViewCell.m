//
//  BPSymptomsAndMoodCollectionViewCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSymptomsAndMoodCollectionViewCell.h"

@implementation BPSymptomsAndMoodCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(29.0, 22.0, 42.0, 42.0)];
        [self.contentView addSubview:self.imageView];
        
        UIImage *selectedImage = [UIImage imageNamed:@"symptoms_selected"];
        UIImageView *selectedView = [[UIImageView alloc] initWithImage:selectedImage];
        selectedView.contentMode = UIViewContentModeCenter;
        self.selectedBackgroundView = selectedView;
    }
    return self;
}

@end
