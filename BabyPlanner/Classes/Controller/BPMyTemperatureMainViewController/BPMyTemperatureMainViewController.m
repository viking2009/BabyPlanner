//
//  BPMyTemperatureMainViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureMainViewController.h"
#import "BPUtils.h"
#import "BPThemeManager.h"
#import "BPCircleLayout.h"
#import "BPCircleCell.h"
#import "BPFlagView.h"
#import "BPDateIndicatorsView.h"
#import "NSDate-Utilities.h"
#import <QuartzCore/QuartzCore.h>

#define BPCircleCellIdentifier @"BPCircleCellIdentifier"

@interface BPMyTemperatureMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPFlagView *flagView;
@property (nonatomic, strong) BPDateIndicatorsView *indicatorsView;
@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@end

@implementation BPMyTemperatureMainViewController

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
    
    self.view.clipsToBounds = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 8.f)];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topView.backgroundColor = RGB(13, 134, 116);
    [self.view addSubview:topView];
    
    UIImage *flagImage = [BPUtils imageNamed:@"mytemperature_main_flag"];
    self.flagView = [[BPFlagView alloc] initWithFrame: CGRectMake(6.f, 20.f, flagImage.size.width, flagImage.size.height)];
    self.flagView.imageView.image = flagImage;
    // TODO: add property for controller
    self.flagView.date = [NSDate date];
    [self.view addSubview:self.flagView];
    
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
    
    // demo
    self.indicatorsView.day = 18;
    self.indicatorsView.pregnant = @NO;
    self.indicatorsView.menstruation = @NO;
    self.indicatorsView.temperature = @36.65;
    self.indicatorsView.boy = @YES;
    self.indicatorsView.girl = @NO;
    self.indicatorsView.sexualIntercourse = @YES;
    self.indicatorsView.ovulation = @NO;
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:17 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)updateUI
{
    [super updateUI];
    
    [self.flagView updateUI];
    [self.indicatorsView updateUI];
    
    self.selectLabel.text = BPLocalizedString(@"!Ta-da!");
    
//    self.view.backgroundColor = [BPThemeManager sharedManager].currentThemeColor;
    self.view.backgroundColor = [[BPThemeManager sharedManager] themeColorForTheme:@"Classic"];
    
    [self loadData];
    [self.collectionView reloadData];
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
    return 56.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BPCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCircleCellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = @"point_4";
    
    if (indexPath.item < 12)
        imageName = @"point_1";
    else if (indexPath.item < 18)
        imageName = @"point_2";
    else if (indexPath.item < 28)
        imageName = @"point_3";
    else
        imageName = @"point_4";
    
    if (indexPath.item == 13)
        imageName = @"point_5";
    
    cell.imageView.image = [BPUtils imageNamed:imageName];
    cell.imageView.highlightedImage = [BPUtils imageNamed:[NSString stringWithFormat:@"%@_active", imageName]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog()
}

#pragma mark - Private

- (void)myControlsButtonTapped
{
    if (self.handler)
        self.handler();
}

@end
