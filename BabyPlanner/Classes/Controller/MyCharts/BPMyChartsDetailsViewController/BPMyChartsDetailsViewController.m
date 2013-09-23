//
//  BPMyChartsDetailsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsDetailsViewController.h"
#import "BPCycle+Additions.h"
#import "BPUtils.h"

#define kBPSegmentButtonWidth   65.f
#define kBPSegmentButtonHeight  30.f

@interface BPMyChartsDetailsViewController ()

@property (nonatomic, strong) UIButton *segmentLeftButton;
@property (nonatomic, strong) UIButton *segmentRightButton;

- (void)showCalendar;
- (void)showDiagram;

@end

@implementation BPMyChartsDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // TODO: add "All charts" button
//        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.segmentLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.segmentLeftButton.contentEdgeInsets = UIEdgeInsetsMake(1.f, 0, 3.f, 0);
    self.segmentLeftButton.frame = CGRectMake(self.navigationImageView.center.x - kBPSegmentButtonWidth,
                                              self.navigationImageView.frame.origin.y + floorf(self.navigationImageView.frame.size.height/2 - kBPSegmentButtonHeight/2),
                                              kBPSegmentButtonWidth, kBPSegmentButtonHeight);
    
    UIImage *segmentLeftButtonNormalImage = [BPUtils imageNamed:@"mycharts_segment_left_normal"];
    UIImage *segmentLeftButtonSelectedImage = [BPUtils imageNamed:@"mycharts_segment_left_selected"];
    [self.segmentLeftButton setBackgroundImage:segmentLeftButtonNormalImage forState:UIControlStateNormal];
    [self.segmentLeftButton setBackgroundImage:segmentLeftButtonSelectedImage forState:UIControlStateHighlighted];
    [self.segmentLeftButton setBackgroundImage:segmentLeftButtonSelectedImage forState:UIControlStateSelected];
    [self.segmentLeftButton setBackgroundImage:segmentLeftButtonSelectedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIImage *segmentIconCalendarNormalImage = [BPUtils imageNamed:@"mycharts_segment_icon_calendar_normal"];
    UIImage *segmentIconCalendarSelectedImage = [BPUtils imageNamed:@"mycharts_segment_icon_calendar_selected"];
    [self.segmentLeftButton setImage:segmentIconCalendarNormalImage forState:UIControlStateNormal];
    [self.segmentLeftButton setImage:segmentIconCalendarSelectedImage forState:UIControlStateHighlighted];
    [self.segmentLeftButton setImage:segmentIconCalendarSelectedImage forState:UIControlStateSelected];
    [self.segmentLeftButton setImage:segmentIconCalendarSelectedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.segmentLeftButton addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.segmentLeftButton];
    
    self.segmentRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.segmentRightButton.contentEdgeInsets = UIEdgeInsetsMake(1.f, 0, 3.f, 0);
    self.segmentRightButton.frame = CGRectMake(self.navigationImageView.center.x,
                                               self.navigationImageView.frame.origin.y + floorf(self.navigationImageView.frame.size.height/2 - kBPSegmentButtonHeight/2),
                                               kBPSegmentButtonWidth, kBPSegmentButtonHeight);
    
    UIImage *segmentRightButtonNormalImage = [BPUtils imageNamed:@"mycharts_segment_right_normal"];
    UIImage *segmentRightButtonSelectedImage = [BPUtils imageNamed:@"mycharts_segment_right_selected"];
    [self.segmentRightButton setBackgroundImage:segmentRightButtonNormalImage forState:UIControlStateNormal];
    [self.segmentRightButton setBackgroundImage:segmentRightButtonSelectedImage forState:UIControlStateHighlighted];
    [self.segmentRightButton setBackgroundImage:segmentRightButtonSelectedImage forState:UIControlStateSelected];
    [self.segmentRightButton setBackgroundImage:segmentRightButtonSelectedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIImage *segmentIconDiagramNormalImage = [BPUtils imageNamed:@"mycharts_segment_icon_diagram_normal"];
    UIImage *segmentIconDiagramSelectedImage = [BPUtils imageNamed:@"mycharts_segment_icon_diagram_selected"];
    [self.segmentRightButton setImage:segmentIconDiagramNormalImage forState:UIControlStateNormal];
    [self.segmentRightButton setImage:segmentIconDiagramSelectedImage forState:UIControlStateHighlighted];
    [self.segmentRightButton setImage:segmentIconDiagramSelectedImage forState:UIControlStateSelected];
    [self.segmentRightButton setImage:segmentIconDiagramSelectedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.segmentRightButton addTarget:self action:@selector(showDiagram) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:self.segmentRightButton];
    
    [self showCalendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)showCalendar
{
    self.segmentLeftButton.selected = YES;
    self.segmentRightButton.selected = NO;
}

- (void)showDiagram
{
    self.segmentLeftButton.selected = NO;
    self.segmentRightButton.selected = YES;
}

@end
