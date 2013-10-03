//
//  BPCalendarCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPDate;

@interface BPCalendarCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong) BPDate *date;
@property (nonatomic, strong) NSNumber *childBirth;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
