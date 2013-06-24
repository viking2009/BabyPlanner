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
#import "BPSettingsCell.h"
#import <QuartzCore/QuartzCore.h>

#define BPSettingsViewCellIdentifier @"BPSettingsViewCellIdentifier"
#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"

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
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f - self.tabBarController.tabBar.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPSettingsCell class] forCellWithReuseIdentifier:BPSettingsViewCellIdentifier];
    [self.collectionView registerClass:[BPSwitchCell class] forCellWithReuseIdentifier:BPSwitchCellIdentifier];

    self.data = @[
                  @[ @{@"title": BPLocalizedString(@"Termometer"), @"subtitle" : @""},
                     @{@"title": BPLocalizedString(@"Mesurement"), @"subtitle" : @"C"}],
                  @[ @{@"title": BPLocalizedString(@"Language"), @"subtitle" : @"English"},
                     @{@"title": BPLocalizedString(@"Theme"), @"subtitle" : @""},
                     @{@"title": BPLocalizedString(@"Alarm"), @"subtitle" : @"Off"},
                     @{@"title": BPLocalizedString(@"My Profile"), @"subtitle" : @""}],
                  ];
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
    NSLog(@"[self.data count] = %i", [self.data count]);
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BPSettingsViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BPSettingsViewCellIdentifier];
    }
    
    NSLog(@"cell = %@", cell);
    NSDictionary *item = self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *accessorySwitch = [[UISwitch alloc] init];
        cell.accessoryView = accessorySwitch;
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
    NSLog(@"indexPath = %@", indexPath);
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
    UICollectionViewCell *cell;
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSwitchCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSettingsViewCellIdentifier forIndexPath:indexPath];
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
    
    NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
    if (indexPath.section == 0 && indexPath.item == 0) {
        BPSwitchCell *switchCell = (BPSwitchCell *)cell;
        switchCell.titleLabel.text = dataItem[@"title"];
        switchCell.delegate = self;
        switchCell.toggleView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"temp"];
    } else {
        BPSettingsCell *settingsCell = (BPSettingsCell *)cell;
        settingsCell.titleLabel.text = dataItem[@"title"];
        settingsCell.subtitleLabel.text = dataItem[@"subtitle"];
        
        if (indexPath.section == 1 && indexPath.item == 2) {
            // TODO: alarm 
            NSUInteger alarmsCount = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
            if (alarmsCount) {
                settingsCell.subtitleLabel.text = BPLocalizedString(@"On");
            } else {
                settingsCell.subtitleLabel.text = BPLocalizedString(@"Off");
            }
        }
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@", indexPath);
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
    NSLog(@"%s %i", __PRETTY_FUNCTION__, cell.toggleView.on);
    [[NSUserDefaults standardUserDefaults] setBool:cell.toggleView.on forKey:@"temp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
