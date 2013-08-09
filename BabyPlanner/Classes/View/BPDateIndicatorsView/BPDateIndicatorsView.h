//
//  BPDateIndicatorsView.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPDateIndicatorsView : UIView

// NOTE: CoreData will be used for store data, so use NSNumber

@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) NSNumber *pregnant;
@property (nonatomic, assign) NSNumber *menstruation;
@property (nonatomic, assign) NSNumber *temperature;
@property (nonatomic, assign) NSNumber *boy;
@property (nonatomic, assign) NSNumber *girl;
@property (nonatomic, assign) NSNumber *sexualIntercourse;
@property (nonatomic, assign) NSNumber *ovulation;

- (void)updateUI;

@end
