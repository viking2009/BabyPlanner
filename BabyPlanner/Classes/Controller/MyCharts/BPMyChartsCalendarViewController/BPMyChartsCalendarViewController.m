//
//  BPMyChartsCalendarViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsCalendarViewController.h"
#import "BPCalendarCell.h"
#import "BPCalendarHeader.h"
#import "BPUtils.h"
#import "NSDate-Utilities.h"

#define BPCalendarCellIdentifier @"BPCalendarCellIdentifier"
#define BPCalendarHeaderIdentifier @"BPCalendarHeaderIdentifier"

@interface BPMyChartsCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPCalendarHeaderDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BPMyChartsCalendarViewController

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
    
    self.statusBarView.backgroundColor = [UIColor clearColor];

    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[collectionViewFlowLayout setItemSize:CGSizeMake(46.f, 46.f)];
	[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320.f, 88.f)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
//	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectInset(self.view.bounds, -1, 0);

    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
//    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.delaysContentTouches = NO;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[BPCalendarCell class] forCellWithReuseIdentifier:BPCalendarCellIdentifier];
    [self.collectionView registerClass:[BPCalendarHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPCalendarHeaderIdentifier];
    
    [self updateUI];
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

- (void)updateUI
{
    [super updateUI];
    
    [self.collectionView reloadData];
}

#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 35.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCalendarCellIdentifier forIndexPath:indexPath];

    if (indexPath.item < 10)
        cell.backgroundView.backgroundColor = RGBA(138, 220, 208, 0.85);
    else if (indexPath.item < 13)
        cell.backgroundView.backgroundColor = RGBA(235, 72, 0, 0.85);
    else if (indexPath.item == 13) {
        cell.backgroundView.backgroundColor = RGBA(230, 11, 5, 0.85);
        cell.sexualIntercourse = @YES;
        cell.ovulation = @YES;
    }
    else if (indexPath.item < 17)
        cell.backgroundView.backgroundColor = RGBA(235, 72, 0, 0.85);
    else if (indexPath.item < 26)
        cell.backgroundView.backgroundColor = RGBA(138, 220, 208, 0.85);
    else if (indexPath.item == 26)
        cell.backgroundView.backgroundColor = RGBA(231, 231, 141, 0.9);
    else
        cell.backgroundView.backgroundColor = RGBA(138, 220, 208, 0.85);
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%i", (indexPath.item % 30 + 1)];
    cell.dayLabel.textColor = (indexPath.item < 28 ? RGB(255, 255, 255) : RGB(42, 192, 169));

    if (indexPath.item < 3 || (indexPath.item > 27 && indexPath.item < 31))
        cell.menstruation = @YES;
    
    if (indexPath.item == 25) {
        cell.sexualIntercourse = @YES;
        cell.pregnant = @YES;
    }
    
    if (indexPath.item == 15)
        cell.sexualIntercourse = @YES;
    
    if (indexPath.item == 27)
        cell.childBirth = @YES;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    BPCalendarHeader *calendarHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarHeaderIdentifier forIndexPath:indexPath];
    calendarHeader.delegate = self;
    
    NSDateFormatter *dateFormatter = [BPUtils dateFormatter];
    NSDate *now = [NSDate date];
    calendarHeader.monthLabel.text = [dateFormatter standaloneMonthSymbols][now.month-1];
    calendarHeader.yearLabel.text = [NSString stringWithFormat:@"%i", now.year];
    
    [calendarHeader updateDayOfWeekLabels];
    
    return calendarHeader;
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
//    if (indexPath.section == 1) {
//        switch (indexPath.item) {
//            case 0:
//                [self.navigationController pushViewController:[BPSettingsLanguageViewController new] animated:YES];
//                break;
//            case 1:
//                [self.navigationController pushViewController:[BPSettingsThemeViewController new] animated:YES];
//                break;
//            case 2:
//                [self.navigationController pushViewController:[BPSettingsAlarmViewController new] animated:YES];
//                break;
//            case 3:
//                [self.navigationController pushViewController:[BPSettingsProfileViewController new] animated:YES];
//                break;
//                
//            default:
//                break;
//        }
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

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

#pragma mark - BPCalendarHeaderDelegate

- (void)calendarHeaderDidTapPrevButton:(BPCalendarHeader *)calendarHeader
{
    DLog();
}

- (void)calendarHeaderDidTapNextButton:(BPCalendarHeader *)calendarHeader
{
    DLog();
}

@end
