//
//  BPMyTemperatureSelectViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 13.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureSelectViewController.h"
#import "BPUtils.h"
#import "BPValuePicker.h"
#import "BPDate.h"
#import "ObjectiveRecord.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"
#import "BPTemperaturesManager.h"
#import "BPSettingsCell.h"
#import "ObjectiveSugar.h"
#import "BPSettings+Additions.h"
#import "UIView+Sizes.h"
#import <QuartzCore/QuartzCore.h>

#define BPSettingsCellIdentifier @"BPSettingsViewCellIdentifier"

@interface BPMyTemperatureSelectViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPValuePicker *pickerView;

@property (nonatomic, strong) BPTemperaturesManager *temperaturesManagerManager;

@end

@implementation BPMyTemperatureSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = BPLocalizedString(@"Temperature");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(BPSettingsPickerMinimalOriginY, self.view.height - BPPickerViewHeight - self.tabBarController.tabBar.height), self.view.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view insertSubview:self.pickerView belowSubview:self.navigationImageView];

    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	//[collectionViewFlowLayout setItemSize:CGSizeMake(self.view.width - 20, 320.0)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.width, self.pickerView.top - 64.f + 44.f); // invisible toolbar for self.pickerView
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view insertSubview:self.collectionView aboveSubview:self.pickerView];
    
    [self.collectionView registerClass:[BPSettingsCell class] forCellWithReuseIdentifier:BPSettingsCellIdentifier];
    
    DLog(@"self.collectionView = %@", self.collectionView);
    DLog(@"self.pickerView = %@", self.pickerView);
    
    [self updateUI];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

- (void)loadData
{
    self.temperaturesManagerManager = [[BPTemperaturesManager alloc] init];
    
    NSInteger selectedDay = (self.selectedDate ? [self.temperaturesManagerManager indexForDate:self.selectedDate.date] : self.temperaturesManagerManager.todayIndex);
    
    if (selectedDay == NSNotFound)
        selectedDay = 0;
    
    self.selectedDate = _temperaturesManagerManager[selectedDay];
}

- (void)updateUI
{
    [super updateUI];
    
    if (self.isViewLoaded) {
        [self loadData];
        [self.collectionView reloadData];
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.temperaturesManagerManager indexForDate:self.selectedDate.date] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        
        self.pickerView.valuePickerMode = BPValuePickerModeNone;
        self.pickerView.valuePickerMode = BPValuePickerModeTemperature;
        self.pickerView.value = [BPUtils temperatureFromNumber:([self.selectedDate.temperature intValue] ? self.selectedDate.temperature : @36.6)];
    }
}

- (void)localize
{
    [super localize];
    
    [self updateUI];
}

- (void)pickerViewValueChanged
{
    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeTemperature: {
            DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, [BPUtils temperatureFromString:self.pickerView.value]);
            self.selectedDate.temperature = [BPUtils temperatureFromString:self.pickerView.value];
            [self.selectedDate save];

            NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems].first;
            BPSettingsCell *selectedCell = (BPSettingsCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            BPDate *date = _temperaturesManagerManager[indexPath.item];
            selectedCell.subtitleLabel.text = [BPUtils temperatureFromNumber:date.temperature];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.temperaturesManagerManager count];
//    BPSettings *sharedSettings = [BPSettings sharedSettings];
//    return [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSettingsCellIdentifier forIndexPath:indexPath];
    
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
    
    BPDate *date = _temperaturesManagerManager[indexPath.item];
    cell.titleLabel.text = [BPUtils shortStringFromDate:date.date];
    cell.subtitleLabel.text = [BPUtils temperatureFromNumber:date.temperature];
    cell.accessoryView.image = nil;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog();
    // TODO: optimize
    self.selectedDate = _temperaturesManagerManager[indexPath.item];
    
    [self updateUI];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        height = 46.f;
    } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        height = 45.f;
    } else {
        height = 44.f;
    }
    
    return CGSizeMake(300.f, height);
}

@end
