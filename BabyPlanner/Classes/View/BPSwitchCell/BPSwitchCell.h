//
//  BPSwitchCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSwitch.h"

@class BPSwitchCell;

@protocol BPSwitchCellDelegate <NSObject>

- (void)switchCellDidToggle:(BPSwitchCell *)cell;

@end

@interface BPSwitchCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTSwitch *toggleView;
@property (nonatomic, weak) id delegate;

@end
