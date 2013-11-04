//
//  BPMyChartsDetailsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsDetailsViewController.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"
#import "UINavigationController+Transition.h"
#import "BPMyTemperatureControlsViewController.h"

#define kBPSegmentButtonWidth   65.f
#define kBPSegmentButtonHeight  30.f

@interface BPMyChartsDetailsViewController ()

@property (nonatomic, strong) UIButton *segmentLeftButton;
@property (nonatomic, strong) UIButton *segmentRightButton;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, strong) UIView *containerView;

- (void)showCalendar;
- (void)showDiagram;

- (void)setSelectedViewController:(UIViewController *)selectedViewController animated:(BOOL)animated;

@end

@implementation BPMyChartsDetailsViewController

@synthesize calendarViewController = _calendarViewController;
@synthesize diagramViewController = _diagramViewController;

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
    
    CGFloat navigationImageViewHeight = self.navigationImageView.height - 3.f;
    
    self.segmentLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.segmentLeftButton.contentEdgeInsets = UIEdgeInsetsMake(1.f, 0, 3.f, 0);
    self.segmentLeftButton.frame = CGRectMake(self.navigationImageView.center.x - kBPSegmentButtonWidth,
                                              self.navigationImageView.top + floorf(navigationImageViewHeight/2 - kBPSegmentButtonHeight/2),
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
                                               self.navigationImageView.top + floorf(navigationImageViewHeight/2 - kBPSegmentButtonHeight/2),
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
    
    UIImage *greenImage = [BPUtils imageNamed:@"green_button"];
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.editButton.enabled = NO;
    [self.editButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    self.editButton.frame = CGRectMake(self.view.width - 10.f - greenImage.size.width, self.navigationImageView.top + floorf(navigationImageViewHeight/2 - greenImage.size.height/2), greenImage.size.width, greenImage.size.height);
    [self.editButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    self.editButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
    self.editButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.editButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [self.editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editButton];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationImageView.top + navigationImageViewHeight, self.view.width, self.view.height - (self.navigationImageView.top + navigationImageViewHeight) - self.tabBarController.tabBar.height)];
//    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    [self.view insertSubview:self.containerView belowSubview:self.navigationImageView];
    
    [self showCalendar];
    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)localize {
    [super localize];
    
    [self.editButton setTitle:BPLocalizedString(@"Edit") forState:UIControlStateNormal];
}

#pragma marl - Public

- (BPMyChartsCalendarViewController *)calendarViewController
{
    if (!_calendarViewController) {
        _calendarViewController = [[BPMyChartsCalendarViewController alloc] init];
        _calendarViewController.cycle = self.cycle;
        [self addChildViewController:_calendarViewController];
        [_calendarViewController didMoveToParentViewController:self];
    }
    
    return _calendarViewController;
}

- (BPMyChartsDiagramViewController *)diagramViewController
{
    if (!_diagramViewController) {
        _diagramViewController = [[BPMyChartsDiagramViewController alloc] init];
        _diagramViewController.cycle = self.cycle;
        [self addChildViewController:_diagramViewController];
        [_diagramViewController didMoveToParentViewController:self];
    }
    
    return _diagramViewController;
}

#pragma mark - Private

- (void)showCalendar
{
    self.segmentLeftButton.selected = YES;
    self.segmentRightButton.selected = NO;
    [self setSelectedViewController:self.calendarViewController animated:YES];
}

- (void)showDiagram
{
    self.segmentLeftButton.selected = NO;
    self.segmentRightButton.selected = YES;
    [self setSelectedViewController:self.diagramViewController animated:YES];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController animated:(BOOL)animated
{
    if (selectedViewController == self.selectedViewController)
        return ;
    
    UIViewController *fromViewController = self.selectedViewController;
    UIViewController *toViewController = selectedViewController;
    
    self.selectedViewController = selectedViewController;
    
    if (toViewController == nil) // don't animate
        [fromViewController.view removeFromSuperview];
    else if (fromViewController == nil) { // don't animate
        toViewController.view.frame = self.containerView.bounds;

        [self.containerView addSubview:toViewController.view];
    } else if (animated) {
        CGRect rect = self.containerView.bounds;
        if (selectedViewController == self.diagramViewController)
            rect.origin.x = rect.size.width;
        else
            rect.origin.x = -rect.size.width;
        
        DLog(@"%@", NSStringFromCGRect(rect));
        
        toViewController.view.frame = rect;
        self.segmentLeftButton.userInteractionEnabled = NO;
        self.segmentRightButton.userInteractionEnabled = NO;
        
        [self transitionFromViewController:fromViewController
                          toViewController:toViewController
                                  duration:0.3
                                   options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                animations:^ {
                                    CGRect rect = fromViewController.view.frame;
                                    if (selectedViewController == self.diagramViewController)
                                        rect.origin.x = -rect.size.width;
                                    else
                                        rect.origin.x = rect.size.width;
                                    
                                    fromViewController.view.frame = rect;
                                    toViewController.view.frame = self.containerView.bounds;
                                }
                                completion:^(BOOL finished) {
                                    self.segmentLeftButton.userInteractionEnabled = YES;
                                    self.segmentRightButton.userInteractionEnabled = YES;
                                }];
    } else { // not animated
        [fromViewController.view removeFromSuperview];
        
        toViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:toViewController.view];
    }
}

- (void)editButtonTapped
{
    BPDate *selectedDate = (self.selectedViewController == self.calendarViewController ? self.calendarViewController.selectedDate :
                            self.diagramViewController.selectedDate);
    
    if (!selectedDate)
        return ;
    
    BPMyTemperatureControlsViewController *controlsController = [[BPMyTemperatureControlsViewController alloc] init];
    controlsController.date = selectedDate;
    
    __weak __typeof(&*self) weakSelf = self;
    controlsController.handler = ^{
        [weakSelf.navigationController popViewControllerWithDuration:0.3f
                                                          prelayouts:^(UIView *fromView, UIView *toView) {
                                                              BPViewController *vc = (BPViewController *)weakSelf.selectedViewController;
                                                              [vc updateUI];
                                                          }
                                                          animations:^(UIView *fromView, UIView *toView) {
                                                              fromView.frame = CGRectOffset(toView.bounds, 0, toView.height);
                                                          }
                                                          completion:^(UIView *fromView, UIView *toView) {
                                                              //
                                                          }];
    };
    
    [self.navigationController pushViewController:controlsController duration:0.3f
                                       prelayouts:^(UIView *fromView, UIView *toView) {
                                           toView.frame = CGRectOffset(fromView.bounds, 0, fromView.height);
                                       }
                                       animations:^(UIView *fromView, UIView *toView) {
                                           toView.frame = fromView.frame;
                                       }
                                       completion:^(UIView *fromView, UIView *toView) {
                                           //
                                       }];
}

@end
