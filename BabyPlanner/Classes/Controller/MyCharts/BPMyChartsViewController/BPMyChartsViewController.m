//
//  BPMyChartsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsViewController.h"
#import "BPUtils.h"
#import "BPCollectionViewCell.h"
#import "BPCollectionViewHeader.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"

#define BPCollectionViewCellIdentifier @"BPCollectionViewCellIdentifier"
#define BPCollectionViewHeaderIdentifier @"BPCollectionViewHeaderIdentifier"

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
    
    [self.collectionView registerClass:[BPCollectionViewCell class] forCellWithReuseIdentifier:BPCollectionViewCellIdentifier];
    [self.collectionView registerClass:[BPCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPCollectionViewHeaderIdentifier];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    NSString *language = [BPLanguageManager sharedManager].currentLanguage;
    DLog(@"language: %@", language);
    
    // TODO: set data for self.date;
    self.data = @[ @[@{@"title": @"4. 21.08.12-21.09.12", @"subtitle": @"30"},
                     @{@"title": @"3. 20.07.12-20.08.12", @"subtitle": @"30"},
                     @{@"title": @"2. 19.06.12-19.07.12", @"subtitle": @"30"},
                     @{@"title": @"1. 18.05.12-18.06.12", @"subtitle": @"30"}],
                   @[@{@"title": @"4. 21.08.12-21.09.12", @"subtitle": @"30"},
                     @{@"title": @"3. 20.07.12-20.08.12", @"subtitle": @"30"},
                     @{@"title": @"2. 19.06.12-19.07.12", @"subtitle": @"30"},
                     @{@"title": @"1. 18.05.12-18.06.12", @"subtitle": @"30"}]];
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
    return [_data count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_data[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        // TODO: separate UICollectionViewCell subclass for this section
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCollectionViewCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCollectionViewCellIdentifier forIndexPath:indexPath];
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
    
    NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
//    if (indexPath.section == 1) {
//        
//    } else {
        BPCollectionViewCell *settingsCell = (BPCollectionViewCell *)cell;
        settingsCell.titleLabel.text = dataItem[@"title"];
        settingsCell.accessoryView.image = [BPUtils imageNamed:@"cell_disclosureIndicator"];
        settingsCell.accessoryView.highlightedImage = [settingsCell.accessoryView.image tintedImageWithColor:RGB(255, 255, 255) style:UIImageTintedStyleKeepingAlpha];
//    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPCollectionViewHeader *collectionViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCollectionViewHeaderIdentifier forIndexPath:indexPath];
        collectionViewHeader.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
        collectionViewHeader.titleLabel.textColor = RGB(0, 0, 0);
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
    DLog(@"collectionView: %@", [collectionView performSelector:@selector(recursiveDescription)]);

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
    
//    if (indexPath.section == 1) {
        if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
            height = 46.f;
        } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
            height = 45.f;
        } else {
            height = 44.f;
        }
//    }
    
    return CGSizeMake(302.f, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10.f, 0, 10.f, 0);
    if (section < [collectionView numberOfSections] - 1) {
        edgeInsets.bottom = 0;
    }
    
    return edgeInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (section == 0 ? CGSizeMake(collectionView.frame.size.width, 32.f) : CGSizeZero);
}

@end
