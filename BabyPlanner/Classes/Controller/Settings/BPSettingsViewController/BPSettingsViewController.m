//
//  BPSettingsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsViewController.h"
#import "BPUtils.h"
#import "BPSwitchCell.h"
#import "BPSegmentCell.h"
#import "BPSettingsCell.h"
#import "BPSettingsLanguageViewController.h"
#import "BPSettingsThemeViewController.h"
#import "BPSettingsAlarmViewController.h"
#import "BPSettingsProfileViewController.h"
#import "BPSettings+Additions.h"
#import "BPLanguageManager.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"
#import "UIView+Sizes.h"
#import <QuartzCore/QuartzCore.h>

#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"
#define BPSegmentCellIdentifier @"BPSegmentCellIdentifier"
#define BPSettingsCellIdentifier @"BPSettingsViewCellIdentifier"

@interface BPSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation BPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"Settings";
        [self.tabBarItem setFinishedSelectedImage:[BPUtils imageNamed:@"tabbar_settings_selected"]
                      withFinishedUnselectedImage:[BPUtils imageNamed:@"tabbar_settings_unselected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    [self.collectionView registerClass:[BPSwitchCell class] forCellWithReuseIdentifier:BPSwitchCellIdentifier];
    [self.collectionView registerClass:[BPSegmentCell class] forCellWithReuseIdentifier:BPSegmentCellIdentifier];
    [self.collectionView registerClass:[BPSettingsCell class] forCellWithReuseIdentifier:BPSettingsCellIdentifier];

    [self loadData];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] lastObject] animated:YES];
}

- (void)loadData
{
    self.data = @[
                  @[ @{@"title": @"Thermometer", @"subtitle" : @""},
                     @{@"title": @"Measurement", @"subtitle" : @""}],
                  @[ @{@"title": @"Language", @"subtitle" : @""},
                     @{@"title": @"Theme", @"subtitle" : @""},
                     @{@"title": @"Alarm", @"subtitle" : @"Off"},
                     @{@"title": @"My Profile", @"subtitle" : @""}],
                  ];
}

- (void)updateUI
{
    [super updateUI];

    [self.collectionView reloadData];
}

- (void)localize
{
    [super localize];
    
    [self.collectionView reloadData];
}

- (void)customize
{
    [super customize];
    
    [self.collectionView reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLog(@"[self.data count] = %i", [self.data count]);
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BPSettingsCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BPSettingsCellIdentifier];
    }
    
    DLog(@"cell = %@", cell);
    NSDictionary *item = self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = BPLocalizedString(item[@"title"]);
    cell.detailTextLabel.text = item[@"subtitle"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *accessorySwitch = [[UISwitch alloc] init];
        cell.accessoryView = accessorySwitch;
    } if (indexPath.section == 2 && indexPath.row == 0) {
        NSString *language = [BPLanguageManager sharedManager].currentLanguage;
        cell.detailTextLabel.text = BPLocalizedString(language);
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0 ? 10.0f : 5.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == [tableView numberOfSections] - 1 ? 10.0f : 5.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    UICollectionViewCell *cell;
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSwitchCellIdentifier forIndexPath:indexPath];
    } else if (indexPath.section == 0 && indexPath.item == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSegmentCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSettingsCellIdentifier forIndexPath:indexPath];
    }
    
    UIImageView *backgroundView = [[UIImageView alloc] init];

    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_single"];
    } else if (indexPath.item == 0) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_top"];
    } else if (indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_bottom"];
    } else {
        backgroundView.image = [BPUtils imageNamed:@"cell_background_middle"];
    }
    
    cell.backgroundView = backgroundView;
    
    UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
    selectedBackgroundView.image = [backgroundView.image tintedImageWithColor:[BPThemeManager sharedManager].currentThemeColor style:UIImageTintedStyleKeepingAlpha];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
    if (indexPath.section == 0 && indexPath.item == 0) {
        BPSwitchCell *switchCell = (BPSwitchCell *)cell;
        switchCell.titleLabel.text = BPLocalizedString(dataItem[@"title"]);
        switchCell.delegate = self;
        switchCell.toggleView.onText = BPLocalizedString(@"ON");
        switchCell.toggleView.offText = BPLocalizedString(@"OFF");
        switchCell.toggleView.on = [sharedSettings[BPSettingsThermometrKey] boolValue];
    } else if (indexPath.section == 0 && indexPath.item == 1) {
        BPSegmentCell *segmentCell = (BPSegmentCell *)cell;
        segmentCell.titleLabel.text = BPLocalizedString(dataItem[@"title"]);
        segmentCell.segmentView = [[SVSegmentedControl alloc] initWithSectionTitles:[[BPLanguageManager sharedManager] supportedMetrics]];
        [segmentCell.segmentView setSelectedSegmentIndex:[[BPLanguageManager sharedManager] currentMetric] animated:NO];
        segmentCell.segmentView.changeHandler = ^(NSUInteger newIndex) {
            [BPLanguageManager sharedManager].currentMetric = newIndex;
        };
    } else{
        BPSettingsCell *settingsCell = (BPSettingsCell *)cell;
        settingsCell.titleLabel.text = BPLocalizedString(dataItem[@"title"]);
        settingsCell.subtitleLabel.text = dataItem[@"subtitle"];
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            NSString *language = [BPLanguageManager sharedManager].currentLanguage;
            settingsCell.subtitleLabel.text = BPLocalizedString(language);
        } else if (indexPath.section == 1 && indexPath.item == 2) {
            // TODO: alarm 
            NSArray *alarms = [[UIApplication sharedApplication] scheduledLocalNotifications];
            BOOL alarmFound = NO;
            for (UILocalNotification *notification in alarms) {
                if ([notification.userInfo[@"guid"] intValue] == BPAlarmGuid) {
                    alarmFound = YES;
                    break;
                }
            }
            
            if (alarmFound) {
                settingsCell.subtitleLabel.text = BPLocalizedString(@"On");
            } else {
                settingsCell.subtitleLabel.text = BPLocalizedString(@"Off");
            }
        }
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section > 0;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section > 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.item) {
            case 0:
                [self.navigationController pushViewController:[BPSettingsLanguageViewController new] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[BPSettingsThemeViewController new] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[BPSettingsAlarmViewController new] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[BPSettingsProfileViewController new] animated:YES];
                break;
                
            default:
                break;
        }
    }
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

#pragma mark - BPSwitchCellDelegate

- (void)switchCellDidToggle:(BPSwitchCell *)cell
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsThermometrKey] = @(cell.toggleView.on);
}

@end
