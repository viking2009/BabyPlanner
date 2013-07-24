//
//  BPSettingsThemeViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsThemeViewController.h"
#import "BPUtils.h"
#import "BPThemeCell.h"
#import "BPThemeManager.h"
#import "BPSettings.h"

#define BPThemeCellIdentifier @"BPThemeCellIdentifier"

@interface BPSettingsThemeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *themes;

@end

@implementation BPSettingsThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Theme";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[collectionViewFlowLayout setItemSize:CGSizeMake(BPThemeDefaultImageWidth, BPThemeDefaultImageHeight + BPThemeDefaultTitleHeight)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:20];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f - self.tabBarController.tabBar.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPThemeCell class] forCellWithReuseIdentifier:BPThemeCellIdentifier];

    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    [super updateUI];

    self.themes = [BPThemeManager sharedManager].supportedThemes;
    [self.collectionView reloadData];
    
    NSUInteger selectedThemeIndex = [self.themes indexOfObject:[BPThemeManager sharedManager].currentTheme];
    if (selectedThemeIndex != NSNotFound) {
        NSIndexPath *selectedPath = [NSIndexPath indexPathForItem:selectedThemeIndex inSection:0];
        [self.collectionView selectItemAtIndexPath:selectedPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_themes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPThemeCellIdentifier forIndexPath:indexPath];

    NSString *theme = _themes[indexPath.item];
    cell.imageView.image = [[BPThemeManager sharedManager] iconImageForTheme:theme highlighted:NO];
    cell.imageView.highlightedImage = [[BPThemeManager sharedManager] iconImageForTheme:theme highlighted:YES];
    cell.titleLabel.text = theme;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
    
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsThemeKey] = _themes[indexPath.item];
}

//#pragma mark - UICollectionViewDelegateFlowLayout
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat height = 0.f;
//    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
//        height = 46.f;
//    } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
//        height = 45.f;
//    } else {
//        height = 44.f;
//    }
//    
//    return CGSizeMake(302.f, height);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10.f, 0, 10.f, 0);
//    if (section < [collectionView numberOfSections] - 1) {
//        edgeInsets.bottom = 0;
//    }
//    
//    return edgeInsets;
//}

@end
