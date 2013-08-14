//
//  BPMyPregnancyViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyPregnancyViewController.h"
#import "BPUtils.h"

@interface BPMyPregnancyViewController ()

@end

@implementation BPMyPregnancyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Pregnancy";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mypregnancy_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mypregnancy_unselected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
