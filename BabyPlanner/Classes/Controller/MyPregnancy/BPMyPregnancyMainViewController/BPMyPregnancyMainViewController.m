//
//  BPMyPregnancyMainViewController.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 13.05.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyPregnancyMainViewController.h"
#import "BPMyPregnancyControlsViewController.h"
#import "BPUtils.h"
#import "BPThemeManager.h"
#import "BPSettings+Additions.h"
#import "BPDate+Additions.h"
#import "BPCircleLayout.h"
#import "BPCircleCell.h"
#import "BPFlagView.h"
#import "BPDateIndicatorsView.h"
#import "NSDate-Utilities.h"
#import "BPDatesManager.h"
#import "BPDate.h"
#import "ObjectiveSugar.h"
#import "UINavigationController+Transition.h"
#import "UIView+Sizes.h"
#import "NSDate-Utilities.h"

#import <QuartzCore/QuartzCore.h>

#define BPCircleCellIdentifier @"BPCircleCellIdentifier"

@interface BPMyPregnancyMainViewController ()

@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UIImageView *bubbleView;

- (void)updateBubbleView;

@end

@implementation BPMyPregnancyMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Pregnancy";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mypregnancy_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mypregnancy_unselected"]];

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:BPDatesManagerDidChangeContentNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.clipsToBounds = YES;
    
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_button_background"]];
    bottomView.frame = CGRectMake(0.f, self.view.height - 55.f - self.tabBarController.tabBar.height, bottomView.image.size.width, bottomView.image.size.height);
    [self.view addSubview:bottomView];
    
    self.myControlsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myControlsButtonBackgroundImage = [BPUtils imageNamed:@"mytemperature_main_button_edit"];
    [self.myControlsButton setBackgroundImage:myControlsButtonBackgroundImage forState:UIControlStateNormal];
    self.myControlsButton.frame = CGRectMake(self.view.width - 61.f, self.view.height - self.tabBarController.tabBar.height - myControlsButtonBackgroundImage.size.height - 8.f, myControlsButtonBackgroundImage.size.width, myControlsButtonBackgroundImage.size.height);
    [self.myControlsButton addTarget:self action:@selector(myControlsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myControlsButton];
    
    // TODO: check for condition and show first or second pair of images
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_main_girl1"]];

    CGFloat offset = self.view.height - self.girlView.image.size.height - self.tabBarController.tabBar.height - 27.f;
    
    self.girlView.frame = CGRectMake(168, offset, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];

    self.bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_main_bubble1"]];
    self.bubbleView.frame = CGRectMake(64, 120.f + offset, self.bubbleView.image.size.width, self.bubbleView.image.size.height);
    [self.view addSubview:self.bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.f, 15.f, self.bubbleView.width - 36.f, self.bubbleView.height - 20.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    self.selectLabel.textColor = RGB(0, 0, 0);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
//    self.selectLabel.layer.borderWidth = 1.0f;
//    self.selectLabel.layer.borderColor = [UIColor redColor].CGColor;
    //    self.selectLabel.shadowColor = RGB(255, 255, 255);
    //    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.bubbleView addSubview:self.selectLabel];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myControlsButtonTapped)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
//    [self loadData];
    [self updateUI];
    [self localize];
    [self customize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    DLog();
}

- (void)updateBubbleView
{
    self.selectLabel.text = BPLocalizedString(@"Your are pregnant!");
}

- (void)updateUI
{
    [super updateUI];
    
    if (self.isViewLoaded) {
        [self updateBubbleView];
    }
}

- (void)localize
{
    [super localize];
    
    [self updateBubbleView];
}

- (void)customize
{
    [super customize];
    
    //    self.view.backgroundColor = [BPThemeManager sharedManager].currentThemeColor;
    self.view.backgroundColor = [[BPThemeManager sharedManager] themeColorForTheme:@"Classic"];
}


#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{

}

#pragma mark - Private

- (void)myControlsButtonTapped
{
//    if (self.handler)
//        self.handler();

    BPMyPregnancyControlsViewController *controlsController = [[BPMyPregnancyControlsViewController alloc] init];
    controlsController.date = [BPDate dateWithDate:[NSDate date]];

    __weak __typeof(&*self) weakSelf = self;
    controlsController.handler = ^{
        [weakSelf.navigationController popViewControllerWithDuration:0.3f
                                                          prelayouts:^(UIView *fromView, UIView *toView) {
                                                              [weakSelf updateUI];
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
