//
//  BPMyChartsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsViewController.h"
#import "BPUtils.h"
#import "BPStatsCollectionViewCell.h"
#import "BPCycleInfoCell.h"
#import "BPStatsCollectionViewHeader.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"
#import "BPCyclesManager.h"
#import "BPCycle+Additions.h"

#define BPStatsCollectionViewCellIdentifier @"BPStatsCollectionViewCellIdentifier"
#define BPCycleInfoCellIdentifier @"BPCycleInfoCellIdentifier"
#define BPStatsCollectionViewHeaderIdentifier @"BPStatsCollectionViewHeaderIdentifier"

@interface BPMyChartsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation BPMyChartsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"My Charts";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_mycharts_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_mycharts_unselected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	//[collectionViewFlowLayout setItemSize:CGSizeMake(self.view.width - 20, 320.0)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f - self.tabBarController.tabBar.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPStatsCollectionViewCell class] forCellWithReuseIdentifier:BPStatsCollectionViewCellIdentifier];
    [self.collectionView registerClass:[BPCycleInfoCell class] forCellWithReuseIdentifier:BPCycleInfoCellIdentifier];
    [self.collectionView registerClass:[BPStatsCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPStatsCollectionViewHeaderIdentifier];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    BPCyclesManager *sharedManager = [BPCyclesManager sharedManager];
    // TODO: set data
    self.data = @[ @[@{@"title": BPLocalizedString(@"Number of all your cycles"), @"subtitle": [NSString stringWithFormat:@"%u", sharedManager.numberOfCycles]},
                     @{@"title": BPLocalizedString(@"Your cycle length on average"), @"subtitle": [NSString stringWithFormat:@"%u", sharedManager.avgCycleLength]},
                     @{@"title": BPLocalizedString(@"Your length of high level on average"), @"subtitle": @"12"},
                     @{@"title": BPLocalizedString(@"Your mono-phases\n(of the last 20 cycles)"), @"subtitle": @"1%"},
                     @{@"title": BPLocalizedString(@"Corpus luteum insufficiency"), @"subtitle": @"1%"}]];
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return 5;
    else
        return [BPCyclesManager sharedManager].numberOfCycles;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPStatsCollectionViewCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCycleInfoCellIdentifier forIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
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
    }
    
    if (indexPath.section == 0) {
        NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
        BPStatsCollectionViewCell *statsCell = (BPStatsCollectionViewCell *)cell;
        statsCell.titleLabel.text = dataItem[@"title"];
        statsCell.subtitleLabel.text = dataItem[@"subtitle"];
    } else {
        BPCyclesManager *sharedManager = [BPCyclesManager sharedManager];
        BPCycle *cycle = sharedManager.cycles[indexPath.item];

        BPCycleInfoCell *cycleInfoCell = (BPCycleInfoCell *)cell;
        cycleInfoCell.counterLabel.text = [NSString stringWithFormat:@"%@.", cycle.index];
        cycleInfoCell.titleLabel.text = cycle.title;
        cycleInfoCell.subtitleLabel.text = [NSString stringWithFormat:@"%u", cycle.length];
        
        if (indexPath.item == 1 || indexPath.item == 2)
            cycleInfoCell.imageView.image = [BPUtils imageNamed:@"mycharts_icon_ovulation"];
        else
            cycleInfoCell.imageView.image = nil;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPStatsCollectionViewHeader *collectionViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPStatsCollectionViewHeaderIdentifier forIndexPath:indexPath];
        collectionViewHeader.titleLabel.text = BPLocalizedString(@"Planning statistics");
        return collectionViewHeader;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        BPMyTemperatureSelectViewController *temperatureSelectViewController = [[BPMyTemperatureSelectViewController alloc] init];
//        temperatureSelectViewController.selectedDate = self.date;
//        [self.navigationController pushViewController:temperatureSelectViewController animated:YES];
//    }
//    else if (indexPath.section == 1) {
//        switch (indexPath.item) {
//            case 2: {
//                BPMyTemperatureSymptomsAndMoodViewController *temperatureSymptomsAndMoodViewController = [[BPMyTemperatureSymptomsAndMoodViewController alloc] init];
//                temperatureSymptomsAndMoodViewController.date = self.date;
//                [self.navigationController pushViewController:temperatureSymptomsAndMoodViewController animated:YES];
//            }
//                break;
//            case 3: {
//                BPMyTemperatureNotationsViewController *temperatureNotationsViewController = [[BPMyTemperatureNotationsViewController alloc] init];
//                temperatureNotationsViewController.date = self.date;
//                [self.navigationController pushViewController:temperatureNotationsViewController animated:YES];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    } else if (indexPath.section == 2 &indexPath.row == 0) {
//        BPSettings *sharedSettings = [BPSettings sharedSettings];
//        sharedSettings[BPSettingsProfileIsPregnantKey] = @(![sharedSettings[BPSettingsProfileIsPregnantKey] boolValue]);
//    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    CGFloat maxWidth = 302.f;
    
    if (indexPath.section == 0) {
        NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
        CGSize titleSize = [dataItem[@"title"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15]
                                          constrainedToSize:CGSizeMake(maxWidth - (BPDefaultCellInset + BPStatsCellSubtitleWidth), CGFLOAT_MAX)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        height = ceilf(titleSize.height) + 2*BPStatsCellInset;
    } else if (indexPath.section == 1) {
        if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
            height = 46.f;
        } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
            height = 45.f;
        } else {
            height = 44.f;
        }
    }
    
    return CGSizeMake(maxWidth, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10.f, 0, 10.f, 0);
    if (section == 0)
        edgeInsets.top = 0;
    
    if (section < [collectionView numberOfSections] - 1)
        edgeInsets.bottom = 0;
    
    return edgeInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (section == 0 ? CGSizeMake(collectionView.frame.size.width, 36.f) : CGSizeZero);
}

@end
