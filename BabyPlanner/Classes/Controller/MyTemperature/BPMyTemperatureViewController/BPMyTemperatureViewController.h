//
//  BPMyTemperatureViewController.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPBaseViewController.h"

@class BPMyTemperatureMainViewController;
@class BPMyTemperatureControlsViewController;

@interface BPMyTemperatureViewController : BPBaseViewController

@property (nonatomic, readonly) BPMyTemperatureMainViewController *mainController;
@property (nonatomic, readonly) BPMyTemperatureControlsViewController *controlsController;

@end
