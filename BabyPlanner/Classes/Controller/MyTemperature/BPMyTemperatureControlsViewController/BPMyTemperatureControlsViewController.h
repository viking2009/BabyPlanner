//
//  BPMyTemperatureControlsViewController.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPBaseViewController.h"

@class BPDate;

@interface BPMyTemperatureControlsViewController : BPBaseViewController

@property (nonatomic, copy) void (^handler)(void);
@property (nonatomic, strong) BPDate *date;

@end
