//
//  BPMyChartsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsViewController.h"
#import "BPUtils.h"

@interface BPMyChartsViewController ()

@end

@implementation BPMyChartsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"My Charts";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mycharts_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mycharts_unselected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
