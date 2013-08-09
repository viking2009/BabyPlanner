//
//  BPFlagView.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPFlagView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSDate *date;

- (void)updateUI;

@end
