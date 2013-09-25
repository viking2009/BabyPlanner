//
//  BPMyTemperatureMainViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureMainViewController.h"
#import "BPMyTemperatureControlsViewController.h"
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

#import <QuartzCore/QuartzCore.h>

#define BPCircleCellIdentifier @"BPCircleCellIdentifier"

@interface BPMyTemperatureMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPFlagView *leftFlagView;
@property (nonatomic, strong) BPFlagView *rightFlagView;
@property (nonatomic, strong) BPDateIndicatorsView *indicatorsView;
@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@property (nonatomic, strong) BPDatesManager *datesManager;
@property (nonatomic, strong) BPDate *selectedDate;

@end

@implementation BPMyTemperatureMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Temperature";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mytemperature_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mytemperature_unselected"]];

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:BPDatesManagerDidChangeContentNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.clipsToBounds = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 8.f)];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topView.backgroundColor = RGB(13, 134, 116);
    [self.view addSubview:topView];
    
    UIImage *redFlagImage = [BPUtils imageNamed:@"mytemperature_main_flag_red"];
    self.leftFlagView = [[BPFlagView alloc] initWithFrame:CGRectMake(6.f, 20.f, redFlagImage.size.width, redFlagImage.size.height)];
    self.leftFlagView.imageView.image = redFlagImage;

    UIImage *pinkFlagImage = [BPUtils imageNamed:@"mytemperature_main_flag_pink"];
    self.rightFlagView = [[BPFlagView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - pinkFlagImage.size.width -  6.f, 20.f, pinkFlagImage.size.width, pinkFlagImage.size.height)];
    self.rightFlagView.imageView.image = pinkFlagImage;
    self.rightFlagView.hidden = YES;
    // TODO: add property for controller

    UIImageView *bottomView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_button_background"]];
    bottomView.frame = CGRectMake(0.f, self.view.bounds.size.height - 55.f - self.tabBarController.tabBar.frame.size.height, bottomView.image.size.width, bottomView.image.size.height);
    [self.view addSubview:bottomView];
    
    self.myControlsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myControlsButtonBackgroundImage = [BPUtils imageNamed:@"mytemperature_main_button_edit"];
    [self.myControlsButton setBackgroundImage:myControlsButtonBackgroundImage forState:UIControlStateNormal];
    self.myControlsButton.frame = CGRectMake(self.view.bounds.size.width - 61.f, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height - myControlsButtonBackgroundImage.size.height - 8.f, myControlsButtonBackgroundImage.size.width, myControlsButtonBackgroundImage.size.height);
    [self.myControlsButton addTarget:self action:@selector(myControlsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myControlsButton];
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_girl"]];

    CGFloat offset = MAX(330.f, self.view.bounds.size.height - self.girlView.image.size.height);
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_bubble"]];
    bubbleView.frame = CGRectMake(3, offset, bubbleView.image.size.width, bubbleView.image.size.height);
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectOffset(bubbleView.frame, 0, -10.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.selectLabel.textColor = RGB(76, 86, 108);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
    //    self.selectLabel.shadowColor = RGB(255, 255, 255);
    //    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.view addSubview:self.selectLabel];
    
    self.girlView.frame = CGRectMake(97, offset, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
    BPCircleLayout *collectionViewCircleLayout = [[BPCircleLayout alloc] init];
    collectionViewCircleLayout.radius = 124.f;
    collectionViewCircleLayout.cellsPerCircle = 28;
    collectionViewCircleLayout.itemSize = CGSizeMake(BPCircleCellImageSize, BPCircleCellImageSize);
    collectionViewCircleLayout.distance = 18.f;
    
    CGRect collectionViewRect = CGRectMake(0, MAX(32.f, self.girlView.frame.origin.y - self.view.bounds.size.width) - 10.f, self.view.bounds.size.width, self.view.bounds.size.width);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewCircleLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[BPCircleCell class] forCellWithReuseIdentifier:BPCircleCellIdentifier];
    
    self.indicatorsView = [[BPDateIndicatorsView alloc] initWithFrame:collectionViewRect];
    [self.view addSubview:self.indicatorsView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.leftFlagView];
    [self.view addSubview:self.rightFlagView];

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myControlsButtonTapped)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UITapGestureRecognizer *tapLeftFlagView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftFlagViewTapped)];
    [self.leftFlagView addGestureRecognizer:tapLeftFlagView];
    
    [self updateUI];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    DLog();
    
    self.datesManager = [[BPDatesManager alloc] init];

    NSInteger selectedDay = (self.selectedDate ? [self.datesManager indexForDate:self.selectedDate.date] : self.datesManager.todayIndex);
    
    if (selectedDay == NSNotFound)
        selectedDay = 0;
    
    BPDate *date = [self datesManager][selectedDay];

    self.indicatorsView.date = date;
    
//    BPSettings *sharedSettings = [BPSettings sharedSettings];
//    self.indicatorsView.boy = sharedSettings[BPSettingsProfileBoyKey];
//    self.indicatorsView.girl = sharedSettings[BPSettingsProfileGirlKey];
    
    self.leftFlagView.date = date.date;
        
    self.selectedDate = date;
}

- (void)updateUI
{
    [super updateUI];
    
    if (self.isViewLoaded) {
        BPSettings *sharedSettings = [BPSettings sharedSettings];
        
        [self.leftFlagView updateUI];
        self.rightFlagView.date = sharedSettings[BPSettingsProfileChildBirthdayKey];
        DLog(@"self.rightFlagView.date: %@", self.rightFlagView.date);
        self.rightFlagView.hidden = !([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue] && sharedSettings[BPSettingsProfileChildBirthdayKey]);
        [self.rightFlagView updateUI];
        [self.indicatorsView updateUI];
        
        self.selectLabel.text = BPLocalizedString(@"!Ta-da!");
        
        //    self.view.backgroundColor = [BPThemeManager sharedManager].currentThemeColor;
        self.view.backgroundColor = [[BPThemeManager sharedManager] themeColorForTheme:@"Classic"];
        
        [self loadData];
        [self.collectionView reloadData];
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.selectedDate.day intValue] - 1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.datesManager count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCircleCellIdentifier forIndexPath:indexPath];
    
    BPDate *date = self.datesManager[indexPath.item];

    cell.imageView.image = [BPUtils imageNamed:date.imageName];
    cell.imageView.highlightedImage = [BPUtils imageNamed:[NSString stringWithFormat:@"%@_active", date.imageName]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
//    BPSettings *sharedSettings = [BPSettings sharedSettings];
//
//    return indexPath.item < [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
//    BPSettings *sharedSettings = [BPSettings sharedSettings];
//    
//    return indexPath.item < [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog();
    BPDate *date = self.datesManager[indexPath.item];
    
    self.indicatorsView.date = date;
    
//    BPSettings *sharedSettings = [BPSettings sharedSettings];
//    self.indicatorsView.boy = sharedSettings[BPSettingsProfileBoyKey];
//    self.indicatorsView.girl = sharedSettings[BPSettingsProfileGirlKey];
    
    self.leftFlagView.date = date.date;
    
    self.selectedDate = date;
}

#pragma mark - Private

- (void)myControlsButtonTapped
{
//    if (self.handler)
//        self.handler();

    BPMyTemperatureControlsViewController *controlsController = [[BPMyTemperatureControlsViewController alloc] init];
    controlsController.date = self.selectedDate;

    __weak __typeof(&*self) weakSelf = self;
    controlsController.handler = ^{
        [weakSelf.navigationController popViewControllerWithDuration:0.3f
                                                          prelayouts:^(UIView *fromView, UIView *toView) {
                                                              [weakSelf updateUI];
                                                          }
                                                          animations:^(UIView *fromView, UIView *toView) {
                                                              fromView.frame = CGRectOffset(toView.bounds, 0, toView.bounds.size.height);
                                                          }
                                                          completion:^(UIView *fromView, UIView *toView) {
                                                              //
                                                          }];
    };

    [self.navigationController pushViewController:controlsController duration:0.3f
                                       prelayouts:^(UIView *fromView, UIView *toView) {
                                           toView.frame = CGRectOffset(fromView.bounds, 0, fromView.bounds.size.height);
                                       }
                                       animations:^(UIView *fromView, UIView *toView) {
                                           toView.frame = fromView.frame;
                                       }
                                       completion:^(UIView *fromView, UIView *toView) {
                                           //
                                       }];
}

- (void)leftFlagViewTapped
{
    DLog();
    self.selectedDate = [BPDate dateWithDate:[NSDate date]];
    [self updateUI];
}


@end
