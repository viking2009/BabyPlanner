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

@interface BPMyTemperatureViewController ()

@property (nonatomic, readonly) BPMyTemperatureMainViewController *mainController;
@property (nonatomic, readonly) BPMyTemperatureControlsViewController *controlsController;
@property (nonatomic, weak) UIViewController *visibleViewController;

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

- (BPMyTemperatureMainViewController *)mainController
{
    DLog();
    if (!_mainController) {
        _mainController = [[BPMyTemperatureMainViewController alloc] init];
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

- (BPMyTemperatureControlsViewController *)controlsController
{
    DLog();
    if (!_controlsController) {
        _controlsController = [[BPMyTemperatureControlsViewController alloc] init];
        [self addChildViewController:_controlsController];
        _controlsController.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
        
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
    CGRect rect = (self.visibleViewController == self.mainController ? self.view.bounds : CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height));
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
