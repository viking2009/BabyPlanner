//
//  BPMyChartsCalendarViewController.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPBaseViewController.h"
#import "BPCycle+Additions.h"

@interface BPMyChartsCalendarViewController : BPBaseViewController

@property (nonatomic, strong) BPCycle *cycle;
@property (nonatomic, strong, readonly) BPDate *selectedDate;

@end
