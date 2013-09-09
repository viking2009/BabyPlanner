//
//  BPStatsCollectionViewCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPLabel.h"

#define BPStatsCellSubtitleWidth    30.f
#define BPStatsCellInset            1.f

@interface BPStatsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BPLabel *titleLabel;
@property (nonatomic, strong) BPLabel *subtitleLabel;

@end
