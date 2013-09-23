//
//  BPMyChartsDetailsViewController.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPViewController.h"

#import "BPMyChartsCalendarViewController.h"
#import "BPMyChartsDiagramViewController.h"
#import "BPCycle+Additions.h"

@interface BPMyChartsDetailsViewController : BPViewController

@property (nonatomic, strong) BPCycle *cycle;

@property (nonatomic, readonly) BPMyChartsCalendarViewController *calendarViewController;
@property (nonatomic, readonly) BPMyChartsDiagramViewController *diagramViewController;

@end
