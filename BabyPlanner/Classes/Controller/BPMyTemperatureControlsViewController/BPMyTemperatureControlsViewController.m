//
//  BPMyTemperatureControlsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureControlsViewController.h"
#import "BPUtils.h"
#import "BPSwitchCell.h"
#import "BPSegmentCell.h"
#import "BPSettingsCell.h"
#import "BPSettingsLanguageViewController.h"
#import "BPSettingsThemeViewController.h"
#import "BPMyTemperatureSymptomsAndMoodViewController.h"
#import "BPMyTemperatureNotationsViewController.h"
#import "BPSettings.h"
#import "BPLanguageManager.h"

#define BPSwitchCellIdentifier @"BPSwitchCellIdentifier"
#define BPSegmentCellIdentifier @"BPSegmentCellIdentifier"
#define BPSettingsCellIdentifier @"BPSettingsViewCellIdentifier"

@interface BPMyTemperatureControlsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@property (nonatomic, strong) NSArray *data;

- (void)myControlsButtonTapped;

@end

@implementation BPMyTemperatureControlsViewController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.myControlsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myControlsButtonBackgroundImage = [BPUtils imageNamed:@"mytemperature_controls_button_background"];
    [self.myControlsButton setBackgroundImage:myControlsButtonBackgroundImage forState:UIControlStateNormal];
    self.myControlsButton.frame = CGRectMake(0, 0, myControlsButtonBackgroundImage.size.width, myControlsButtonBackgroundImage.size.height);
    self.myControlsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [self.myControlsButton addTarget:self action:@selector(myControlsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myControlsButton];
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_controls_bubble"]];
    bubbleView.frame = CGRectMake(78, 74, bubbleView.image.size.width, bubbleView.image.size.height);
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectOffset(bubbleView.frame, 0, -10.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.selectLabel.textColor = RGB(76, 86, 108);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
//    self.selectLabel.shadowColor = RGB(255, 255, 255);
//    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.view addSubview:self.selectLabel];
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_controls_girl"]];
    self.girlView.frame = CGRectMake(0, 36, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
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
    
    [self.collectionView registerClass:[BPSwitchCell class] forCellWithReuseIdentifier:BPSwitchCellIdentifier];
    [self.collectionView registerClass:[BPSegmentCell class] forCellWithReuseIdentifier:BPSegmentCellIdentifier];
    [self.collectionView registerClass:[BPSettingsCell class] forCellWithReuseIdentifier:BPSettingsCellIdentifier];
    
    [self updateUI];

    [self loadData];
}

- (void)loadData
{
    NSString *language = [BPLanguageManager sharedManager].currentLanguage;
    DLog(@"language: %@", language);
    
    self.data = @[ @{@"title": BPLocalizedString(@"Menstruation")},
                   @{@"title": BPLocalizedString(@"Sexual intercourse")},
                   @{@"title": BPLocalizedString(@"Symptoms and mood")},
                   @{@"title": BPLocalizedString(@"Notations")}
                  ];
}

- (void)updateUI
{
    [super updateUI];
    
    self.selectLabel.text = BPLocalizedString(@"Please, enter your data!");
    [self.myControlsButton setTitle:BPLocalizedString(@"My controls") forState:UIControlStateNormal];
    
    [self loadData];
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

#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    
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
    DLog(@"indexPath = %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (section == 0 ? 1 : [_data count]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    UICollectionViewCell *cell;
//    if (indexPath.section == 0 && indexPath.item == 0) {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSwitchCellIdentifier forIndexPath:indexPath];
//    } else if (indexPath.section == 0 && indexPath.item == 1) {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSegmentCellIdentifier forIndexPath:indexPath];
//    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSettingsCellIdentifier forIndexPath:indexPath];
//    }
    
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
    
    NSDictionary *dataItem = _data[indexPath.item];
//    if (indexPath.section == 0 && indexPath.item == 0) {
//        BPSwitchCell *switchCell = (BPSwitchCell *)cell;
//        switchCell.titleLabel.text = dataItem[@"title"];
//        switchCell.delegate = self;
//        switchCell.toggleView.on = [sharedSettings[BPSettingsShowTemperatureKey] boolValue];
//    } else if (indexPath.section == 0 && indexPath.item == 1) {
//        BPSegmentCell *segmentCell = (BPSegmentCell *)cell;
//        segmentCell.titleLabel.text = dataItem[@"title"];
//        segmentCell.segmentView = [[SVSegmentedControl alloc] initWithSectionTitles:[[BPLanguageManager sharedManager] supportedMetrics]];
//        [segmentCell.segmentView setSelectedSegmentIndex:[[BPLanguageManager sharedManager] currentMetric] animated:NO];
//        segmentCell.segmentView.changeHandler = ^(NSUInteger newIndex) {
//            [BPLanguageManager sharedManager].currentMetric = newIndex;
//        };
//    } else{
        BPSettingsCell *settingsCell = (BPSettingsCell *)cell;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        settingsCell.titleLabel.text = BPLocalizedString(@"Temperature");
    } else {
        settingsCell.titleLabel.text = dataItem[@"title"];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog()
    if (indexPath.section == 1) {
        switch (indexPath.item) {
            case 0:
                [self.navigationController pushViewController:[BPSettingsLanguageViewController new] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[BPSettingsThemeViewController new] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[BPMyTemperatureSymptomsAndMoodViewController new] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[BPMyTemperatureNotationsViewController new] animated:YES];
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
    
    if (section == 0) {
        edgeInsets.top = 120.f;
    }
    
    return edgeInsets;
}

#pragma mark - BPSwitchCellDelegate

- (void)switchCellDidToggle:(BPSwitchCell *)cell
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsShowTemperatureKey] = @(cell.toggleView.on);
}

#pragma mark - Private

- (void)myControlsButtonTapped
{
    if (self.handler)
        self.handler();
}


@end
