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
#import "UIImage+Additions.h"

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

- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath;
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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:calendarLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    self.collectionView.delaysContentTouches = NO;
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
//    [CURRENT_CALENDAR setLocale:[BPLanguageManager sharedManager].currentLocale];
//    NSInteger numberOfWeaks = [CURRENT_CALENDAR rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.selectedMonth].length;
//    
//    DLog(@"numberOfWeaks: %i", numberOfWeaks);
//    
//    NSInteger numberOfDays = 7 * numberOfWeaks;
//    NSDate *lastDate = [self.firstDate dateByAddingDays:numberOfDays];
//    
//    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.selectedMonth];
//    components.month++;
//    NSDate *nextMonth = [CURRENT_CALENDAR dateFromComponents:components];
//
//    if ([lastDate isEarlierThanDate:nextMonth])
//        numberOfDays += 7;

//    return numberOfDays;
    
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCalendarCellIdentifier forIndexPath:indexPath];

    // бага для дня, когда переводят часы
//    BPDate *date = [BPDate dateWithDate:[self.firstDate dateByAddingDays:indexPath.item]];
    NSDateComponents *comps = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.firstDate];
    comps.day += indexPath.item;
    BPDate *date = [BPDate dateWithDate:[CURRENT_CALENDAR dateFromComponents:comps]];
    
    NSString *imageName = @"mycharts_calendar_cell_background_green";
    UIColor *backgroundColor = RGBA(136, 219, 207, 0.85);
//    BOOL inCycle = [cell.date.cycle isEqual:self.cycle];
    NSUInteger dateIndex = [self.datesManager indexForDate:date.date];
    BOOL inCycle = (dateIndex != NSNotFound && dateIndex < self.cycle.length);
    if (inCycle) {
        cell.date = self.datesManager[dateIndex];
        if ([date.imageName isEqualToString:@"point_yellow"]) {
//            imageName = @"mycharts_calendar_cell_background_yellow";
            backgroundColor = RGBA(243, 233, 134, 0.85);
        }
        else if ([date.imageName isEqualToString:@"point_red"]) {
//            imageName = @"mycharts_calendar_cell_background_red";
            backgroundColor = RGBA(230, 11, 5, 0.85);
        }
        else if ([date.imageName isEqualToString:@"point_ovulation"]) {
//            imageName = @"mycharts_calendar_cell_background_ovulation";
            backgroundColor = RGBA(230, 11, 5, 0.85);
        }
    } else {
        cell.date = date;
    }
    
    cell.backgroundColor = backgroundColor;
    
    cell.enabled = inCycle;
    
    if (indexPath.item < 7)
        imageName = @"mycharts_calendar_cell_background_clear_top";
    else
        imageName = @"mycharts_calendar_cell_background_clear";

    UIImage *activeImage = [BPUtils imageNamed:[NSString stringWithFormat:@"%@_active", imageName]];
    cell.imageView.image = [BPUtils imageNamed:imageName];
    cell.imageView.highlightedImage = [cell.imageView.image imageAddingImage:activeImage offset:CGPointZero];
//    cell.imageView.highlightedImage = activeImage;
    
    if (self.selectedDate && cell.enabled)
        [cell setSelected:[cell.date isEqual:self.selectedDate]];

    BPSettings *sharedSettings = [BPSettings sharedSettings];
    NSDate *birthday = sharedSettings[BPSettingsProfileChildBirthdayKey];
    
    cell.childBirth = @(birthday && [cell.date.date isEqualToDateIgnoringTime:birthday]);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
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
    return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self canSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    BPCalendarCell *cell = (BPCalendarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    if (cell.isEnabled) {
        self.selectedDate = cell.date;
        [self updateCollectionView];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(46.f, indexPath.item < 7 ? 47.f : 46.f);
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

- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    BPCalendarCell *cell = (BPCalendarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    DLog(@"%i", cell.isEnabled);
    
    return cell.isEnabled;
}

- (void)updateCollectionView
{
    [self updateFirstDate];
    
    [self.collectionView reloadData];
}

@end
