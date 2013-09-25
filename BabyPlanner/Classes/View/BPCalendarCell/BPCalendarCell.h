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

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) BPDate *date;
@property (nonatomic, strong) NSNumber *childBirth;

@end
