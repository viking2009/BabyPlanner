//
//  BPSymptomsAndMoodCollectionViewCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BPSymptomsAndMoodDefaultImageWidth 102.f
#define BPSymptomsAndMoodDefaultImageHeight 102.f
#define BPSymptomsAndMoodDefaultTitleHeight 18.f

@interface BPSymptomsAndMoodCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
