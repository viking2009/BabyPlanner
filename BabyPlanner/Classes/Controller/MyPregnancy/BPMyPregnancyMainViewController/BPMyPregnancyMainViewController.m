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
#import "BPPregnancyInfoView.h"
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

@property (nonatomic, strong) UILabel *firstTrimesterLabel;
@property (nonatomic, strong) UILabel *secondTrimesterLabel;
@property (nonatomic, strong) UILabel *thirdTrimesterLabel;
@property (nonatomic, strong) BPPregnancyInfoView *infoView;
@property (nonatomic, strong) UIImageView *babyView;
@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UIImageView *bubbleView;

@property (nonatomic, assign) NSUInteger day;

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
    
    UIImageView *trimesterView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_main_trimester_background"]];
    trimesterView.frame = CGRectMake(0.f, self.statusBarView.bottom, trimesterView.image.size.width, trimesterView.image.size.height);
    [self.view addSubview:trimesterView];
    
    CGRect trimesterRect = trimesterView.frame;
    trimesterRect.size = CGSizeMake(110.f, trimesterRect.size.height - 2.f);
    self.firstTrimesterLabel = [[UILabel alloc] initWithFrame:trimesterRect];
    self.firstTrimesterLabel.backgroundColor = [UIColor clearColor];
    self.firstTrimesterLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.firstTrimesterLabel.textColor = RGB(72, 72, 72);
    self.firstTrimesterLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.firstTrimesterLabel];

    trimesterRect = CGRectOffset(trimesterRect, trimesterRect.size.width, 0);
    trimesterRect.size.width = 105.f;
    self.secondTrimesterLabel = [[UILabel alloc] initWithFrame:trimesterRect];
    self.secondTrimesterLabel.backgroundColor = [UIColor clearColor];
    self.secondTrimesterLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.secondTrimesterLabel.textColor = RGB(72, 72, 72);
    self.secondTrimesterLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.secondTrimesterLabel];

    trimesterRect = CGRectOffset(trimesterRect, trimesterRect.size.width, 0);
    self.thirdTrimesterLabel = [[UILabel alloc] initWithFrame:trimesterRect];
    self.thirdTrimesterLabel.backgroundColor = [UIColor clearColor];
    self.thirdTrimesterLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.thirdTrimesterLabel.textColor = RGB(72, 72, 72);
    self.thirdTrimesterLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.thirdTrimesterLabel];

    UIImage *redFlagImage = [BPUtils imageNamed:@"mypregnancy_main_flag_red"];
    self.infoView = [[BPPregnancyInfoView alloc] initWithFrame:CGRectMake(0, trimesterView.bottom - 2.f, redFlagImage.size.width, redFlagImage.size.height)];
    self.infoView.imageView.image = redFlagImage;
    [self.view addSubview:self.infoView];
    
    self.babyView = [[UIImageView alloc] init];
    [self.view addSubview:self.babyView];
    
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
    self.girlView = [[UIImageView alloc] init];
    [self.view addSubview:self.girlView];

    self.bubbleView = [[UIImageView alloc] init];
    [self.view addSubview:self.bubbleView];
    
    self.selectLabel = [[UILabel alloc] init];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.textColor = RGB(0, 0, 0);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
//    self.selectLabel.layer.borderWidth = 1.0f;
//    self.selectLabel.layer.borderColor = [UIColor redColor].CGColor;
    //    self.selectLabel.shadowColor = RGB(255, 255, 255);
    //    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 3;
    [self.bubbleView addSubview:self.selectLabel];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myControlsButtonTapped)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UITapGestureRecognizer *demoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDay)];
    demoTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:demoTap];
    
    self.day = 47;

//    [self loadData];
    [self updateUI];
    [self localize];
    [self customize];
    
}

- (void)changeDay {
    if (self.day == 47)
        self.day = 120;
    else
        self.day = 47;
    
    [self updateUI];
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

- (void)updateUI
{
    [super updateUI];
    
    if (self.isViewLoaded) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit)
                                                       fromDate:[NSDate date]];
        dateComponents.day = self.day;
        self.infoView.date = [calendar dateFromComponents:dateComponents];
        [self.infoView updateUI];
        
        DLog(@"%@", dateComponents);
        
        // TODO: check pregnancy week, set frames
        if (self.day < 90) {
            self.infoView.left = 10.f;
            
            self.babyView.image = [BPUtils imageNamed:@"mypregnancy_main_baby_6w"];

            self.girlView.image = [BPUtils imageNamed:@"mypregnancy_main_girl1"];
            self.girlView.frame = CGRectMake(168, self.view.height - self.girlView.image.size.height - self.tabBarController.tabBar.height - 27.f, self.girlView.image.size.width, self.girlView.image.size.height);

            self.bubbleView.image = [BPUtils imageNamed:@"mypregnancy_main_bubble1"];
            self.bubbleView.frame = CGRectMake(64, self.girlView.top + 120.f, self.bubbleView.image.size.width, self.bubbleView.image.size.height);

            self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
            self.selectLabel.frame = CGRectMake(18.f, 15.f, self.bubbleView.width - 36.f, self.bubbleView.height - 20.f);
            self.selectLabel.text = BPLocalizedString(@"Your are pregnant!");
        } else if (self.day < 180) {
            self.infoView.left = 120.f;
            
            self.babyView.image = [BPUtils imageNamed:@"mypregnancy_main_baby_3m"];
            
            self.girlView.image = [BPUtils imageNamed:@"mypregnancy_main_girl2"];
            self.girlView.frame = CGRectMake(2, self.view.height - self.girlView.image.size.height - self.tabBarController.tabBar.height - 2.f, self.girlView.image.size.width, self.girlView.image.size.height);
            
            self.bubbleView.image = [BPUtils imageNamed:@"mypregnancy_main_bubble3"];
            self.bubbleView.frame = CGRectMake(120.f, self.girlView.top, self.bubbleView.image.size.width, self.bubbleView.image.size.height);
            
            self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            self.selectLabel.frame = CGRectMake(5.f, 0, self.bubbleView.width - 10.f, self.bubbleView.height - 20.f);
            self.selectLabel.text = BPLocalizedString(@"Every time you feel kick, click on my tummy!");
        }
        
        self.babyView.frame = CGRectMake(self.infoView.left - floor(self.babyView.image.size.width/2 - self.infoView.width/2), self.infoView.top + 60.f, self.babyView.image.size.width, self.self.babyView.image.size.height);
    }
}

- (void)localize
{
    [super localize];
    
    self.firstTrimesterLabel.text = BPLocalizedString(@"1st trimester");
    self.secondTrimesterLabel.text = BPLocalizedString(@"2nd trimester");
    self.thirdTrimesterLabel.text = BPLocalizedString(@"3rd trimester");
    
    // TODO: check pregnancy week, set frames
    if (self.day < 90) {
        self.selectLabel.text = BPLocalizedString(@"Your are pregnant!");
    } else if (self.day < 180) {
        self.selectLabel.text = BPLocalizedString(@"Every time you feel kick, click on my tummy!");
    }
    
    [self.infoView updateUI];
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
