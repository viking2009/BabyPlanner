//
//  BPMyTemperatureViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureViewController.h"
#import "BPMyTemperatureMainViewController.h"
#import "BPMyTemperatureControlsViewController.h"
#import "BPUtils.h"

@interface BPMyTemperatureViewController () <UIPageViewControllerDataSource>

@property (nonatomic, readonly) BPMyTemperatureMainViewController *mainController;
@property (nonatomic, readonly) BPMyTemperatureControlsViewController *controlsController;
@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation BPMyTemperatureViewController

@synthesize mainController = _mainController;
@synthesize controlsController = _controlsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Temperature";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mytemperature_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mytemperature_unselected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    [self addChildViewController:self.pageController];
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    
    // Feature #34 My Temperature: Controller for My Temperature slide effect (disable scrolling)
    for (UIScrollView *view in self.pageController.view.subviews)
        if ([view isKindOfClass:[UIScrollView class]])
            view.scrollEnabled = NO;
    
    [self.pageController setViewControllers:@[self.mainController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BPMyTemperatureMainViewController *)mainController
{
    DLog();
    if (!_mainController) {
        _mainController = [[BPMyTemperatureMainViewController alloc] init];
        
        __weak __typeof(&*self) weakSelf = self;
        _mainController.handler = ^{
            [weakSelf.pageController setViewControllers:@[weakSelf.controlsController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        };
    }
    
    return _mainController;
}

- (BPMyTemperatureControlsViewController *)controlsController
{
    DLog();
    if (!_controlsController) {
        _controlsController = [[BPMyTemperatureControlsViewController alloc] init];
        
        __weak __typeof(&*self) weakSelf = self;
        _controlsController.handler = ^{
            [weakSelf.pageController setViewControllers:@[weakSelf.mainController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        };
    }
    
    return _controlsController;
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DLog(@"%@", viewController);
//    return (viewController == self.controlsController ? self.mainController : nil);
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    DLog(@"%@", viewController);
//    return (viewController == self.mainController ? self.controlsController : nil);
    return nil;
}

@end
