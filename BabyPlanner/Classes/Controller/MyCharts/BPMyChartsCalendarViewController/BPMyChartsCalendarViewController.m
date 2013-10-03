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
#import "BPSettings+Additions.h"

#define BPCalendarCellIdentifier @"BPCalendarCellIdentifier"
#define BPCalendarHeaderIdentifier @"BPCalendarHeaderIdentifier"
#define BPCalendarFooterIdentifier @"BPCalendarFooterIdentifier"

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)

@interface BPMyChartsCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPCalendarHeaderDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BPDatesManager *datesManager;
@property (nonatomic, strong) BPDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedMonth;
@property (nonatomic, strong) NSDate *firstDate;

- (void)updateFirstDate;
- (void)updateCollectionView;

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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.statusBarView.backgroundColor = [UIColor clearColor];

    BPCalendarLayout *calendarLayout = [[BPCalendarLayout alloc] init];
	[calendarLayout setItemSize:CGSizeMake(46.f, 46.f)];
	[calendarLayout setHeaderReferenceSize:CGSizeMake(320.f, 53.f)];
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
//    self.collectionView.bounces = NO;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DLog(@"self.view: %@", self.view);
}

- (void)loadData
{
    self.datesManager = [[BPDatesManager alloc] initWithCycle:self.cycle];
}

- (void)updateUI
{
    [super updateUI];
    
    [self loadData];
    
    if (!self.selectedDate && self.datesManager.todayIndex != NSNotFound) {
        BPDate *today = self.datesManager[self.datesManager.todayIndex];
        if ([today.cycle isEqual:self.cycle])
            self.selectedDate = today;
    }
    
    if (!self.selectedMonth) {
        if (self.selectedDate)
            self.selectedMonth = self.selectedDate.date;
        else
            self.selectedMonth = self.cycle.startDate;
        
        NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.selectedMonth];
        components.day = 1;
        self.selectedMonth = [CURRENT_CALENDAR dateFromComponents:components];
    }
    
    [self updateCollectionView];
    
    if (self.selectedDate) {
        NSInteger dayIndex = [self.selectedDate.date daysAfterDate:self.firstDate];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:dayIndex inSection:0];
        [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    DLog();
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [CURRENT_CALENDAR setLocale:[BPLanguageManager sharedManager].currentLocale];
    NSInteger numberOfWeaks = [CURRENT_CALENDAR rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.selectedMonth].length;
    
    NSInteger numberOfDays = 7 * numberOfWeaks;
    NSDate *lastDate = [self.firstDate dateByAddingDays:numberOfDays];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.selectedMonth];
    components.month++;
    NSDate *nextMonth = [CURRENT_CALENDAR dateFromComponents:components];

    if ([lastDate isEarlierThanDate:nextMonth])
        numberOfDays += 7;
    
    return numberOfDays;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCalendarCellIdentifier forIndexPath:indexPath];

    NSString *imageName = @"mycharts_calendar_cell_background_green";

    BOOL inCycle = NO;
    cell.date = [BPDate dateWithDate:[self.firstDate dateByAddingDays:indexPath.item]];

    NSUInteger indexOfDate = [self.datesManager indexForDate:cell.date.date];
    if (indexOfDate != NSNotFound) {
        BPDate *date = self.datesManager[indexOfDate];
//        inCycle = ([date.cycle isEqual:self.cycle]);
        inCycle = (!([date.date isEarlierThanDate:self.cycle.startDate] || [date.date isLaterThanDate:self.cycle.endDate]));
        if (inCycle) {
            if ([date.imageName isEqualToString:@"point_yellow"])
                imageName = @"mycharts_calendar_cell_background_yellow";
            else if ([date.imageName isEqualToString:@"point_red"])
                imageName = @"mycharts_calendar_cell_background_red";
            else if ([date.imageName isEqualToString:@"point_ovulation"])
                imageName = @"mycharts_calendar_cell_background_ovulation";
        }
    }
    cell.enabled = inCycle;
    
    cell.imageView.image = [BPUtils imageNamed:imageName];
    cell.imageView.highlightedImage = [BPUtils imageNamed:[NSString stringWithFormat:@"%@_active", imageName]];
    
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    NSDate *birthday = sharedSettings[BPSettingsProfileChildBirthdayKey];
    
    cell.childBirth = @(birthday && [cell.date.date isEqualToDateIgnoringTime:birthday]);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPCalendarHeader *calendarHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarHeaderIdentifier forIndexPath:indexPath];
        calendarHeader.delegate = self;
        
        calendarHeader.titleLabel.text = [BPUtils monthStringFromDate:self.selectedMonth];
        calendarHeader.prevButton.enabled = (self.selectedMonth.month > self.cycle.startDate.month);
        calendarHeader.nextButton.enabled = (self.selectedMonth.month < self.cycle.endDate.month);
        
        [calendarHeader updateDayOfWeekLabels];
        
        return calendarHeader;
    } else {
        BPCalendarFooter *calendarFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarFooterIdentifier forIndexPath:indexPath];

        BPSettings *sharedSettings = [BPSettings sharedSettings];
        NSDate *birthday = sharedSettings[BPSettingsProfileChildBirthdayKey];

        calendarFooter.date = self.selectedDate;
        calendarFooter.childBirth = @(birthday && [self.selectedDate.date isEqualToDateIgnoringTime:birthday]);
        
        [calendarFooter updateUI];
        
        return calendarFooter;
    }
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCalendarCell *cell = (BPCalendarCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];

    return cell.enabled;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCalendarCell *cell = (BPCalendarCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    return cell.enabled;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    BPDate *selectedDate = [BPDate dateWithDate:[self.firstDate dateByAddingDays:indexPath.item]];
    
    BOOL inCycle = (!([selectedDate.date isEarlierThanDate:self.cycle.startDate] || [selectedDate.date isLaterThanDate:self.cycle.endDate]));
    if (inCycle)
        self.selectedDate = selectedDate;
    else
        self.selectedDate = nil;

    [self updateCollectionView];
}

#pragma mark - BPCalendarHeaderDelegate

- (void)calendarHeaderDidTapPrevButton:(BPCalendarHeader *)calendarHeader
{
    DLog();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.selectedMonth];
    components.month--;
    self.selectedMonth = [CURRENT_CALENDAR dateFromComponents:components];
    self.selectedDate = nil;
    
    [self updateCollectionView];
}

- (void)calendarHeaderDidTapNextButton:(BPCalendarHeader *)calendarHeader
{
    DLog();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.selectedMonth];
    components.month++;
    self.selectedMonth = [CURRENT_CALENDAR dateFromComponents:components];
    self.selectedDate = nil;

    [self updateCollectionView];
}

- (void)updateFirstDate
{
    DLog(@"self.selectedMonth: %@", self.selectedMonth);
    self.firstDate = self.selectedMonth;
    
    DLog(@"self.selectedMonth.weekday: %i", self.selectedMonth.weekday);
    
    NSDateComponents *compsFirstDayInMonth = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self.selectedMonth];
    NSInteger weekDayOffset = ([[BPLanguageManager sharedManager].currentLanguage isEqualToString:@"en"] ? 1 : 2);
    NSInteger daysOffset = (compsFirstDayInMonth.weekday - 1 - weekDayOffset + 8) % 7;

    self.firstDate = [self.firstDate dateBySubtractingDays:daysOffset];
}

- (void)updateCollectionView
{
    [self updateFirstDate];
    
    [self.collectionView reloadData];
}

@end
