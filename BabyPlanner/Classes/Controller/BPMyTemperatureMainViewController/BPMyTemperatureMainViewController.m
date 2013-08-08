//
//  BPMyTemperatureMainViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureMainViewController.h"
#import "BPUtils.h"
#import "BPCircleLayout.h"
#import <QuartzCore/QuartzCore.h>

#define BPCircleCellIdentifier @"BPCircleCellIdentifier"

@interface BPMyTemperatureMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    self.myControlsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myControlsButtonBackgroundImage = [BPUtils imageNamed:@"mytemperature_main_button_background"];
    [self.myControlsButton setBackgroundImage:myControlsButtonBackgroundImage forState:UIControlStateNormal];
    self.myControlsButton.frame = CGRectMake(0, self.view.bounds.size.height - 55.f - self.tabBarController.tabBar.frame.size.height, myControlsButtonBackgroundImage.size.width, myControlsButtonBackgroundImage.size.height);
    self.myControlsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.myControlsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.myControlsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10.f, 0, 10.f);
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
    collectionViewCircleLayout.radius = 128.f;
    collectionViewCircleLayout.cellsPerCircle = 28;
    collectionViewCircleLayout.itemSize = CGSizeMake(12.f, 12.f);
    collectionViewCircleLayout.distance = 17.f;
    
    CGRect collectionViewRect = CGRectMake(0, MAX(32.f, self.girlView.frame.origin.y - self.view.bounds.size.width) - 10.f, self.view.bounds.size.width, self.view.bounds.size.width);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewCircleLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:BPCircleCellIdentifier];
    
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
}

- (void)updateUI
{
    [super updateUI];
    
    self.selectLabel.text = BPLocalizedString(@"!Ta-da!");
    [self.myControlsButton setTitle:BPLocalizedString(@"My controls") forState:UIControlStateNormal];
    
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCircleCellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    cell.contentView.layer.cornerRadius = 10.f;
    cell.contentView.layer.borderWidth = 1.f;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    
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
