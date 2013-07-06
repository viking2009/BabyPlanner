//
//  BPSettingLanguageViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsAlarmViewController.h"

#import "BPUtils.h"
#import "BPSwitchCell.h"
#import "BPSettingsCell.h"
#import "BPValuePicker.h"
#import <QuartzCore/QuartzCore.h>

#define BPSettingsViewCellIdentifier @"BPSettingsViewCellIdentifier"
#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"

@interface BPSettingsAlarmViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPValuePicker *pickerView;
@property (nonatomic, strong) UIImageView *alarmView;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) NSString *soundName;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL canScheduleAlarm;

- (void)scheduleAlarm:(BOOL)schedule;

@end

@implementation BPSettingsAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Alarm";
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
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(280.f, self.view.bounds.size.height - BPPickerViewHeight - self.tabBarController.tabBar.frame.size.height), self.view.bounds.size.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pickerView];
    
    self.alarmView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_alarm"]];
    self.alarmView.frame = CGRectMake(floorf(self.view.bounds.size.width/2 - self.alarmView.image.size.width/2), self.pickerView.frame.origin.y - self.alarmView.image.size.height + 5.f, self.alarmView.image.size.width, self.alarmView.image.size.height);
    [self.view insertSubview:self.alarmView belowSubview:self.pickerView];
    
    NSArray *alarms = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.fireDate = [NSDate date];
    
    for (UILocalNotification *notification in alarms) {
        DLog(@"notification: %@", notification);
        if ([notification.userInfo[@"guid"] intValue] == BPAlarmGuid) {
            self.canScheduleAlarm = YES;
            self.fireDate = notification.fireDate;
            self.soundName = notification.soundName?:@"Marimba";
            break;
        }
    }
    
    DLog(@"fireDate = %@", self.fireDate);

    self.pickerView.valuePickerMode = BPValuePickerModeTime;
    self.pickerView.value = self.fireDate;

    [self loadData];
    [self updateUI];
}

- (void)loadData {
    
    self.data = @[
                  @[ @{@"title": BPLocalizedString(@"Alarm"), @"subtitle" : @""},
                     @{@"title": BPLocalizedString(@"Sound"), @"subtitle" : self.soundName}]
                  ];
}

- (void)updateUI {
    [self loadData];
    [self.collectionView reloadData];
}

- (void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        switchCell.toggleView.on = self.canScheduleAlarm;
    } else {
        BPSettingsCell *settingsCell = (BPSettingsCell *)cell;
        settingsCell.titleLabel.text = dataItem[@"title"];
        settingsCell.subtitleLabel.text = dataItem[@"subtitle"];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);

    switch (indexPath.item) {
        case 0:
            self.pickerView.valuePickerMode = BPValuePickerModeTime;
            self.pickerView.value = self.fireDate;
            break;

        case 1:
            self.pickerView.valuePickerMode = BPValuePickerModeSound;
            self.pickerView.value = self.soundName;
            break;

        default:
            break;
    }
    
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
    DLog(@"%s %i", __PRETTY_FUNCTION__, cell.toggleView.on);
 
    self.canScheduleAlarm = cell.toggleView.isOn;
    [self scheduleAlarm:self.canScheduleAlarm];
}


- (void)scheduleAlarm:(BOOL)schedule
{
    DLog(@"%i", schedule);
    
    // cancel all alarms
    NSArray *alarms = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DLog(@"alarms = %@", alarms);
    DLog(@"self.fireDate = %@", self.fireDate);

    for (UILocalNotification *notification in alarms) {
        if ([notification.userInfo[@"guid"] intValue] == BPAlarmGuid) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    // reschedule if needed
    if (schedule) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.userInfo = @{@"guid" : @(BPAlarmGuid)};
        
        notification.fireDate = self.fireDate;
        notification.soundName = self.soundName;
//        notification.repeatInterval = NSCalendarUnitDay;
        notification.repeatInterval = kCFCalendarUnitDay;

        notification.alertBody = [NSString stringWithFormat:BPLocalizedString(@"It's time to get up")];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    DLog(@"alarms = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

- (void)pickerViewValueChanged
{
    DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, self.pickerView.value);

    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeTime:
            self.fireDate = self.pickerView.value;
            [self scheduleAlarm:self.canScheduleAlarm];
            break;
        case BPValuePickerModeSound:
            self.soundName = self.pickerView.value;
            [self scheduleAlarm:self.canScheduleAlarm];
            [self updateUI];
            break;
        default:
            break;
    }
}

@end
