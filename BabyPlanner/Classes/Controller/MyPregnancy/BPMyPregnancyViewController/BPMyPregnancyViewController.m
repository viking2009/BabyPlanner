//
//  BPMyPregnancyViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyPregnancyViewController.h"
#import "BPMyPregnancyMainViewController.h"
#import "BPMyPregnancyControlsViewController.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"

@interface BPMyPregnancyViewController ()

@property (nonatomic, weak) UIViewController *visibleViewController;

@end

@implementation BPMyPregnancyViewController

@synthesize mainController = _mainController;
@synthesize controlsController = _controlsController;

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
	// Do any additional setup after loading the view, typically from a nib.
    
    self.visibleViewController = self.mainController;
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

- (BPMyPregnancyMainViewController *)mainController
{
    DLog();
    if (!_mainController) {
        _mainController = [[BPMyPregnancyMainViewController alloc] init];
        [self addChildViewController:_mainController];
        _mainController.view.frame = self.view.bounds;
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swapViewControllers)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [_mainController.view addGestureRecognizer:swipeUp];
        
        [self.view addSubview:_mainController.view];
        [_mainController didMoveToParentViewController:self];
        
        __weak __typeof(&*self) weakSelf = self;
        _mainController.handler = ^{
            [weakSelf swapViewControllers];
        };
    }
    
    return _mainController;
}

- (BPMyPregnancyControlsViewController *)controlsController
{
    DLog();
    if (!_controlsController) {
        _controlsController = [[BPMyPregnancyControlsViewController alloc] init];
        [self addChildViewController:_controlsController];
        _controlsController.view.frame = CGRectOffset(self.view.bounds, 0, self.view.height);
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swapViewControllers)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [_controlsController.view addGestureRecognizer:swipeDown];
        
        [self.view addSubview:_controlsController.view];
        [_controlsController didMoveToParentViewController:self];
        
        __weak __typeof(&*self) weakSelf = self;
        _controlsController.handler = ^{
            [weakSelf swapViewControllers];
        };
    }
    
    return _controlsController;
}

- (void)swapViewControllers
{
    DLog();
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //    UIViewController* fromVc = self.visibleViewController;
    UIViewController* toVc = (self.visibleViewController == self.mainController ? self.controlsController : self.mainController);
    CGRect rect = (self.visibleViewController == self.mainController ? self.view.bounds : CGRectOffset(self.view.bounds, 0, self.view.height));
    //    DLog(@"rect: %@", NSStringFromCGRect(rect));
    //    DLog(@"from: %@", fromVc);
    //    DLog(@"toVc: %@", toVc);
    ////    fromVc.view.frame = self.view.bounds;
    //
    //    DLog(@"fromVc rect: %@", NSStringFromCGRect(fromVc.view.frame));
    //    DLog(@"toVc rect: %@", NSStringFromCGRect(toVc.view.frame));
    
    __weak __typeof(&*self) weakSelf = self;
    //    [self transitionFromViewController:fromVc
    //                      toViewController:toVc
    //                              duration:5.f
    //                               options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionShowHideTransitionViews
    //                            animations:^{
    //                                weakSelf.controlsController.view.frame = rect;
    //                            }
    //                            completion:^(BOOL done){
    //                                weakSelf.visibleViewController = toVc;
    //                                DLog(@"weakSelf.visibleViewController: %@", weakSelf.visibleViewController);
    //                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //                            }];
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                     animations:^{
                         weakSelf.controlsController.view.frame = rect;
                     } completion:^(BOOL finished) {
                         weakSelf.visibleViewController = toVc;
                         DLog(@"weakSelf.visibleViewController: %@", weakSelf.visibleViewController);
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
    
}

@end
