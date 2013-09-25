//
//  BPDateIndicatorsView.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPDate;

@interface BPDateIndicatorsView : UIView

@property (nonatomic, strong) BPDate *date;

- (void)updateUI;

@end
