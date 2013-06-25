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
#import "DSTPickerView.h"
#import "NSDate-Utilities.h"
#import <QuartzCore/QuartzCore.h>

#define BPSettingsViewCellIdentifier @"BPSettingsViewCellIdentifier"
#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"

@interface BPSettingsAlarmViewController () <DSTPickerViewDataSource, DSTPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, BPSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DSTPickerView *pickerView;
@property (nonatomic, strong) NSDate *fireDate;
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
    
    self.pickerView = [[DSTPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - BPPickerViewHeight - self.tabBarController.tabBar.frame.size.height, self.view.bounds.size.width, BPPickerViewHeight)];
    self.pickerView.elementDistance = 0.f;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.backgroundGradientEndColor = RGB(52, 52, 52);
    self.pickerView.backgroundGradientStartColor = RGB(226, 226, 226);
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    
    NSArray *alarms = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.fireDate = [NSDate date];
    
    for (UILocalNotification *notification in alarms) {
        if ([notification.userInfo[@"guid"] intValue] == BPAlarmGuid) {
            self.canScheduleAlarm = YES;
            self.fireDate = notification.fireDate;
            break;
        }
    }
    
    DLog(@"fireDate = %@", self.fireDate);
    
    self.fireDate = [self.fireDate dateByAddingMinutes:(self.fireDate.minute % 5 == 0 ? 0 : (5 - self.fireDate.minute % 5))];
    DLog(@"fireDate = %@", self.fireDate);
    [self.pickerView selectRow:self.fireDate.hour inComponent:0 animated:NO];
    DLog(@"fireDate = %@", self.fireDate);
    [self.pickerView selectRow:self.fireDate.minute/5 inComponent:1 animated:NO];
    DLog(@"fireDate = %@", self.fireDate);
        
    self.data = @[
                  @[ @{@"title": BPLocalizedString(@"Alarm"), @"subtitle" : @""},
                     @{@"title": BPLocalizedString(@"Sound"), @"subtitle" : @"Marimba"}]
                  ];
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

#pragma mark - DSTPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(DSTPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(DSTPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component == 0 ? 24 : 12);
}

#pragma mark - DSTPickerViewDelegate

- (void)pickerView:(DSTPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);

    if (component == 0) {
        self.fireDate = [[[self.fireDate dateAtStartOfDay] dateByAddingHours:row] dateByAddingMinutes:self.fireDate.minute];
    } else {
        self.fireDate = [[[self.fireDate dateAtStartOfDay] dateByAddingHours:self.fireDate.hour] dateByAddingMinutes:5*row];
    }
    [self scheduleAlarm:self.canScheduleAlarm];
    
    DLog(@"active alarms = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

- (CGFloat)pickerView:(DSTPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 120.f;
}

- (UIView *)pickerView:(DSTPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    NSInteger value = row;
    if (component == 1) {
        value *= 5;
    }
    
    label.text = [NSString stringWithFormat:@"%@%i", (value < 10 ? @"0" : @""), value];
    
    return label;
}

- (CGFloat)pickerView:(DSTPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
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
    // cancel all alarms
    NSArray *alarms = [[UIApplication sharedApplication] scheduledLocalNotifications];
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
        notification.repeatInterval = NSCalendarUnitDay;
        
        notification.alertBody = [NSString stringWithFormat:BPLocalizedString(@"It's time to get up")];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
