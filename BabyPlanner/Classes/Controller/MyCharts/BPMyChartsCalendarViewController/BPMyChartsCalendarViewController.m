//
//  BPMyChartsCalendarViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsCalendarViewController.h"
#import "BPCalendarLayout.h"
#import "BPCalendarCell.h"
#import "BPCalendarHeader.h"
#import "BPCalendarFooter.h"
#import "BPUtils.h"
#import "NSDate-Utilities.h"
#import "BPDatesManager.h"
#import "BPDate+Additions.h"

#define BPCalendarCellIdentifier @"BPCalendarCellIdentifier"
#define BPCalendarHeaderIdentifier @"BPCalendarHeaderIdentifier"
#define BPCalendarFooterIdentifier @"BPCalendarFooterIdentifier"

@interface BPMyChartsCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPCalendarHeaderDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPDatesManager *datesManager;
@property (nonatomic, strong) BPDate *selectedDate;

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

    BPCalendarLayout *calendarLayout = [[BPCalendarLayout alloc] init];
	[calendarLayout setItemSize:CGSizeMake(46.f, 46.f)];
	[calendarLayout setHeaderReferenceSize:CGSizeMake(320.f, 88.f)];
	[calendarLayout setFooterReferenceSize:CGSizeMake(320.f, 150.f)];
	//[calendarLayout setMinimumInteritemSpacing:20];
	[calendarLayout setMinimumInteritemSpacing:0];
	[calendarLayout setMinimumLineSpacing:0];
//	[calendarLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGRect collectionViewRect = CGRectInset(self.view.bounds, -1, 0);

    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:calendarLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.delaysContentTouches = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPCalendarCell class] forCellWithReuseIdentifier:BPCalendarCellIdentifier];
    [self.collectionView registerClass:[BPCalendarHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPCalendarHeaderIdentifier];
    [self.collectionView registerClass:[BPCalendarFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BPCalendarFooterIdentifier];
    
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

- (void)loadData
{
    self.datesManager = [[BPDatesManager alloc] initWithCycle:self.cycle];
}

- (void)updateUI
{
    [super updateUI];
    
    [self loadData];
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

    BPDate *date = self.datesManager[indexPath.item];
    cell.date = date;
    BOOL inCycle = ([self.datesManager indexForDate:date.date] != NSNotFound);
    cell.dayLabel.textColor = (inCycle ? RGB(255, 255, 255) : RGB(42, 192, 169));
    
    if ([date.imageName isEqualToString:@"point_yellow"])
        cell.backgroundView.backgroundColor = RGBA(231, 231, 141, 0.9);
    else if ([date.imageName isEqualToString:@"point_red"])
        cell.backgroundView.backgroundColor = RGBA(235, 72, 0, 0.85);
    else if ([date.imageName isEqualToString:@"point_ovulation"])
        cell.backgroundView.backgroundColor = RGBA(230, 11, 5, 0.85);
    else
        cell.backgroundView.backgroundColor = RGBA(138, 220, 208, 0.85);

    if (indexPath.item == 27)
        cell.childBirth = @YES;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPCalendarHeader *calendarHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarHeaderIdentifier forIndexPath:indexPath];
        calendarHeader.delegate = self;
        
        NSDateFormatter *dateFormatter = [BPUtils dateFormatter];
        NSDate *now = [NSDate date];
        calendarHeader.monthLabel.text = [dateFormatter standaloneMonthSymbols][now.month-1];
        calendarHeader.yearLabel.text = [NSString stringWithFormat:@"%i", now.year];
        
        [calendarHeader updateDayOfWeekLabels];
        
        return calendarHeader;
    } else {
        BPCalendarFooter *calendarFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarFooterIdentifier forIndexPath:indexPath];

        calendarFooter.date = self.selectedDate;
        
        NSIndexPath *indexPath = collectionView.indexPathsForSelectedItems.lastObject;
        calendarFooter.childBirth = @(indexPath.item == 27);
        
        [calendarFooter updateUI];
        
        return calendarFooter;
    }
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    BPDate *date = self.datesManager[indexPath.item];
    self.selectedDate = date;
    
    [self.collectionView reloadData];
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
