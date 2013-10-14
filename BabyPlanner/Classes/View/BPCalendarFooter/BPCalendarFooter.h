//
//  BPCalendarFooter.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPDate;

@interface BPCalendarFooter : UICollectionViewCell

@property (nonatomic, strong) BPDate *date;
@property (nonatomic, strong) NSNumber *childBirth;

- (void)updateUI;

@end
