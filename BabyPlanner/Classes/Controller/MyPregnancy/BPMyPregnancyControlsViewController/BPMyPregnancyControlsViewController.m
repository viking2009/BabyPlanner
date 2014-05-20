//
//  BPMyPregnancyControlsViewController.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 13.05.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyPregnancyControlsViewController.h"
#import "BPMyPregnancyMainViewController.h"
#import "BPMyPregnancyViewController.h"
#import "BPUtils.h"
#import "BPSwitchCell.h"
#import "BPCollectionViewCell.h"
#import "BPCollectionViewHeader.h"
#import "BPMyTemperatureSelectViewController.h"
#import "BPMyTemperatureSymptomsAndMoodViewController.h"
#import "BPMyTemperatureNotationsViewController.h"
#import "BPSettings+Additions.h"
#import "BPLanguageManager.h"
#import "BPThemeManager.h"
#import "UIImage+Additions.h"
#import "BPDate.h"
#import "NSDate-Utilities.h"
#import "ObjectiveRecord.h"
#import "BPCyclesManager.h"
#import "BPCycle+Additions.h"
#import "UIView+Sizes.h"

#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"
#define BPCollectionViewCellIdentifier @"BPCollectionViewCellIdentifier"
#define BPCollectionViewHeaderIdentifier @"BPCollectionViewHeaderIdentifier"

@interface BPMyPregnancyControlsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@property (nonatomic, strong) NSArray *data;

- (void)doneButtonTapped;

@end

@implementation BPMyPregnancyControlsViewController

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
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_controls_bubble"]];
    bubbleView.frame = CGRectMake(96, 64, bubbleView.image.size.width, bubbleView.image.size.height);
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectOffset(bubbleView.frame, 0, -10.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.selectLabel.textColor = RGB(0, 0, 0);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
//    self.selectLabel.shadowColor = RGB(255, 255, 255);
//    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.view addSubview:self.selectLabel];
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mypregnancy_controls_girl"]];
    self.girlView.frame = CGRectMake(self.view.width - self.girlView.image.size.width, 60.f, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	//[collectionViewFlowLayout setItemSize:CGSizeMake(self.view.width - 20, 320.0)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectMake(0, 57.f, self.view.width, self.view.height - 57.f - self.tabBarController.tabBar.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPSwitchCell class] forCellWithReuseIdentifier:BPSwitchCellIdentifier];
    [self.collectionView registerClass:[BPCollectionViewCell class] forCellWithReuseIdentifier:BPCollectionViewCellIdentifier];
    [self.collectionView registerClass:[BPCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPCollectionViewHeaderIdentifier];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonTapped)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];

    UIImageView *topView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_controls_button_background"]];
    topView.frame = CGRectMake(0, 0, topView.image.size.width, topView.image.size.height);
    [self.view addSubview:topView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68.f, 20.f, self.view.width - 2*68.f, 34.f)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGB(255, 255, 255);
    [self.view addSubview:self.titleLabel];
    
    UIImage *greenImage = [BPUtils imageNamed:@"green_button"];
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    self.doneButton.frame = CGRectMake(self.view.width - 10.f - greenImage.size.width, 24.f, greenImage.size.width, greenImage.size.height);
    [self.doneButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    self.doneButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
    self.doneButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [self.doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];

    [self loadData];
    [self updateUI];
    [self localize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] lastObject] animated:YES];
}

- (void)loadData
{
    // TODO: set data for self.date;
    self.data = @[ @[@{@"title": @"Pregnancy calendar", @"image": @"mypregnancy_icon_pregnancycalendar"}],
                   @[@{@"title": @"Kick history", @"image": @"mypregnancy_icon_kickhistory"},
                     @{@"title": @"Weight", @"image": @"mypregnancy_icon_weight"},
                     @{@"title": @"Symptoms and mood", @"image": @"mytemperature_icon_symptoms_and_mood"},
                     @{@"title": @"Notations", @"image": @"mytemperature_icon_notations"},
                     @{@"title": @"Doctor visits", @"image": @"mypregnancy_icon_doctorvisits"}],
                   @[@{@"title": @"Childbirth", @"image": @"mypregnancy_icon_childbirth"}]
                  ];
}

- (void)updateUI
{
    [super updateUI];
    
    DLog(@"self.date:%@", self.date);
    
    [self.collectionView reloadData];
}

- (void)localize
{
    [super localize];
    
    self.titleLabel.text = BPLocalizedString(@"My controls");
    self.selectLabel.text = BPLocalizedString(@"Please, enter\nyour data!");
    [self.doneButton setTitle:BPLocalizedString(@"Done") forState:UIControlStateNormal];
    
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
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BPCollectionViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BPCollectionViewCellIdentifier];
    }
    
    DLog(@"cell = %@", cell);
    NSDictionary *item = self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = BPLocalizedString(item[@"title"]);
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
    DLog(@"indexPath = %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSections = [_data count];
    
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    NSDate *conceiving = sharedSettings[BPSettingsProfileConceivingKey];
    if (conceiving && [conceiving isLaterThanDate:self.date.date] && [sharedSettings[BPSettingsProfileIsPregnantKey] boolValue])
        numberOfSections--;
    
    DLog(@"conceiving: %@, isPregnant: %@", conceiving, sharedSettings[BPSettingsProfileIsPregnantKey]);
    
    return numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    BPSettings *sharedSettings = [BPSettings sharedSettings];

    switch (section) {
        case 0:
//            if ([sharedSettings[BPSettingsThermometrKey] boolValue])
//                return 0;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    
    return [_data[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCollectionViewCellIdentifier forIndexPath:indexPath];
    
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
    
    NSDictionary *dataItem = _data[indexPath.section][indexPath.item];
    BPCollectionViewCell *settingsCell = (BPCollectionViewCell *)cell;
    settingsCell.imageView.image = [BPUtils imageNamed:dataItem[@"image"]];
    settingsCell.titleLabel.text = BPLocalizedString(dataItem[@"title"]);
    
//    if (indexPath.section == 2) {
//        BPSettings *sharedSettings = [BPSettings sharedSettings];
//        settingsCell.accessoryView.image = ([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue] ? [BPUtils imageNamed:@"cell_checkmark"] : nil);
//    } else {
        settingsCell.accessoryView.image = [BPUtils imageNamed:@"cell_disclosureIndicator"];
//    }
    settingsCell.accessoryView.highlightedImage = [settingsCell.accessoryView.image tintedImageWithColor:RGB(255, 255, 255) style:UIImageTintedStyleKeepingAlpha];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    if (indexPath.section == 2 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPCollectionViewHeader *collectionViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCollectionViewHeaderIdentifier forIndexPath:indexPath];
        collectionViewHeader.titleLabel.text = BPLocalizedString(@"Please check if you have given birth");
        return collectionViewHeader;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog();
    if (indexPath.section == 0 && indexPath.row == 0) {
        // TODO: show Pregnancy calendar
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == 1) {
        switch (indexPath.item) {
            case 0: {
                // TODO: show Kick history
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
                break;
            case 1: {
                // TODO: show Weight controller
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
                break;
            case 2: {
                BPMyTemperatureSymptomsAndMoodViewController *temperatureSymptomsAndMoodViewController = [[BPMyTemperatureSymptomsAndMoodViewController alloc] init];
                temperatureSymptomsAndMoodViewController.date = self.date;
                [self.navigationController pushViewController:temperatureSymptomsAndMoodViewController animated:YES];
            }
                break;
            case 3: {
                BPMyTemperatureNotationsViewController *temperatureNotationsViewController = [[BPMyTemperatureNotationsViewController alloc] init];
                temperatureNotationsViewController.date = self.date;
                [self.navigationController pushViewController:temperatureNotationsViewController animated:YES];
            }
                break;
            case 4: {
                // TODO: show Doctor visits
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2 &indexPath.row == 0) {
        // TODO: show datebirth selection?
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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
    
    if (section == 0)
        edgeInsets.top = 136.f;
    else if (section == 2)
        edgeInsets.top = 0.f;
    
    return edgeInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (section == 2 ? CGSizeMake(collectionView.width, 32.f) : CGSizeZero);
}

#pragma mark - BPSwitchCellDelegate

- (void)switchCellDidToggle:(BPSwitchCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    DLog(@"indexPath: %@", indexPath);

    if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            DLog(@"self.date.menstruation: %@", self.date.menstruation);
            self.date.menstruation = @(cell.toggleView.on);
            self.date.mmenstruation = @YES;
            DLog(@"self.date.menstruation: %@", self.date.menstruation);
            
            // change cycle
            if ([self.date.menstruation boolValue] && [self.date.day integerValue] > 20) {
                BPSettings *sharedSettings = [BPSettings sharedSettings];
                BPCyclesManager *sharedManager = [BPCyclesManager sharedManager];
                BPCycle *currentCycle = sharedManager.currentCycle;
                
                currentCycle.endDate = [self.date.date dateBySubtractingDays:1];
                [currentCycle save];
                
                BPCycle *cycle = [BPCycle cycleWithIndex:@([currentCycle.index integerValue] + 1)];
                
                NSDate *startDate = self.date.date;
                cycle.startDate = [startDate dateAtStartOfDay];
                
                NSInteger lengthOfCycle = [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
                cycle.endDate = [cycle.startDate dateByAddingDays:lengthOfCycle - 1];
                
                self.date.cycle = cycle;
                
                [cycle save];

                sharedSettings[BPSettingsProfileIsPregnantKey] = @NO;
                sharedSettings[BPSettingsProfileLastMenstruationDateKey] = self.date.date;
            }
        }
        else if (indexPath.item == 1) {
            DLog(@"self.date.sexualIntercourse: %@", self.date.sexualIntercourse);
            self.date.sexualIntercourse = @(cell.toggleView.on);
            DLog(@"self.date.sexualIntercourse: %@", self.date.sexualIntercourse);
        }
        
        [self.date save];
    }
}

#pragma mark - Private

- (void)doneButtonTapped
{
    if (self.handler)
        self.handler();
}


@end
