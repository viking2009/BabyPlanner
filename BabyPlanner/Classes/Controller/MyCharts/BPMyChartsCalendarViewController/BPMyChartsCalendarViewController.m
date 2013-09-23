//
//  BPMyChartsCalendarViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsCalendarViewController.h"

@interface BPMyChartsCalendarViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BPMyChartsCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.statusBarView.backgroundColor = [UIColor clearColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = [NSString stringWithFormat:@"TODO:\n%@", [self class]];
    [self.scrollView addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
