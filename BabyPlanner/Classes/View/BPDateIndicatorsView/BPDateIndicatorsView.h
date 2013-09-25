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
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *pregnant;
@property (nonatomic, strong) NSNumber *menstruation;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *boy;
@property (nonatomic, strong) NSNumber *girl;
@property (nonatomic, strong) NSNumber *sexualIntercourse;
@property (nonatomic, strong) NSNumber *ovulation;

- (void)updateUI;

@end
