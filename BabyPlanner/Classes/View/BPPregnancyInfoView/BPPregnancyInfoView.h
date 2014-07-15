//
//  BPPregnancyInfoView.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.05.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPPregnancyInfoView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *day;

- (void)updateUI;

@end
