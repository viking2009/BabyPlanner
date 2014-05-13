//
//  BPMyPregnancyControlsViewController.h
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 13.05.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPBaseViewController.h"

@class BPDate;

@interface BPMyPregnancyControlsViewController : BPBaseViewController

@property (nonatomic, copy) void (^handler)(void);
@property (nonatomic, strong) BPDate *date;

@end
