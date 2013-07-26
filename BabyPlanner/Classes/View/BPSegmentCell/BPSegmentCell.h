//
//  BPSegmentCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 26.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVSegmentedControl.h"

@interface BPSegmentCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SVSegmentedControl *segmentView;

@end
