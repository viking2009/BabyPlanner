//
//  BPMyPregnancyKickHistoryListViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 01.06.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyPregnancyKickHistoryListViewController.h"
#import "BPPregnancyKickCell.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"
#import "UIView+Sizes.h"
#import "BPUtils.h"

#define BPPregnancyKickCellIdentifier @"BPPregnancyKickCellIdentifier"

@interface BPMyPregnancyKickHistoryListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation BPMyPregnancyKickHistoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Kick history";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_main_girl2"]];
    self.girlView.frame = CGRectMake(50.f, 62.f, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];

    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	//[collectionViewFlowLayout setItemSize:CGSizeMake(self.view.width - 20, 320.0)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.width, self.view.height - 64.f - self.tabBarController.tabBar.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPPregnancyKickCell class] forCellWithReuseIdentifier:BPPregnancyKickCellIdentifier];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] lastObject] animated:YES];
}

- (void)loadData
{
    // TODO: set data
    self.data = @[@{@"date": @"21.08.2013", @"count": @9, @"time" : @"10:00"},
                  @{@"date": @"20.07.2013", @"count": @10, @"time" : @"12:07"},
                  @{@"date": @"19.06.2013", @"count": @10, @"time" : @"11:50"},
                  @{@"date": @"18.05.2013", @"count": @10, @"time" : @"12:00"},];
}

- (void)updateUI
{
    [super updateUI];
    
    [self loadData];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPPregnancyKickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPPregnancyKickCellIdentifier forIndexPath:indexPath];
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
    
    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_single"];
    } else if (indexPath.item == 0) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_top"];
    } else if (indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_bottom"];
    } else {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_middle"];
    }
    
    selectedBackgroundView.image = [backgroundView.image tintedImageWithColor:[BPThemeManager sharedManager].currentThemeColor style:UIImageTintedStyleKeepingAlpha];
    
    cell.backgroundView = backgroundView;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    NSDictionary *kickInfo = _data[indexPath.item];
    
    cell.titleLabel.text = kickInfo[@"date"];
    cell.subtitleLabel.text = kickInfo[@"time"];
    
    NSNumber *kickCount = kickInfo[@"count"];
    cell.countLabel.text = [kickCount description];
    
    if ([kickCount integerValue] < 10) {
        cell.countBackgroundView.image = [BPUtils imageNamed:@"mypregnancy_kick_redcount"];
    } else {
        cell.countBackgroundView.image = [BPUtils imageNamed:@"mypregnancy_kick_greencount"];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: open Kick History Details
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    CGFloat maxWidth = 302.f;
    
    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        height = 46.f;
    } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        height = 45.f;
    } else {
        height = 44.f;
    }
    
    return CGSizeMake(maxWidth, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(self.girlView.height, 0, 10.f, 0);
}

@end
