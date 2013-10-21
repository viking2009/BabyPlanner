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
#import "BPCalendarView.h"
#import "UIView+Sizes.h"

#define BPCalendarCellIdentifier @"BPCalendarCellIdentifier"
#define BPCalendarHeaderIdentifier @"BPCalendarHeaderIdentifier"
#define BPCalendarFooterIdentifier @"BPCalendarFooterIdentifier"

@interface BPMyChartsCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BPCalendarHeaderDelegate>

@property (nonatomic, strong) BPCalendarView *calendarView;
@property (nonatomic, strong) BPDatesManager *datesManager;
@property (nonatomic, strong, readwrite) BPDate *selectedDate;
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
    
    self.calendarView = [[BPCalendarView alloc] initWithFrame:self.view.bounds collectionViewLayout:calendarLayout];
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    self.calendarView.backgroundView = nil;
    self.calendarView.backgroundColor = [UIColor clearColor];
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
//    self.collectionView.delaysContentTouches = NO;
//    self.collectionView.bounces = NO;
    [self.view addSubview:self.calendarView];
    
    [self.calendarView registerClass:[BPCalendarCell class] forCellWithReuseIdentifier:BPCalendarCellIdentifier];
    [self.calendarView registerClass:[BPCalendarFooter class] forCellWithReuseIdentifier:BPCalendarFooterIdentifier];
    [self.calendarView registerClass:[BPCalendarHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BPCalendarHeaderIdentifier];
    
    [self updateUI];
//    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.calendarView.dataSource = nil;
    self.calendarView.delegate = nil;
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

- (void)localize
{
    [super localize];
    
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
    return 2;
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
    
    return (section == 0 ? 35 : 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPCalendarCellIdentifier forIndexPath:indexPath];
        
        // бага для дня, когда переводят часы
        //    BPDate *date = [BPDate dateWithDate:[self.firstDate dateByAddingDays:indexPath.item]];
        NSDateComponents *comps = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.firstDate];
        comps.day += indexPath.item;
        BPDate *date = [BPDate dateWithDate:[CURRENT_CALENDAR dateFromComponents:comps]];
        
        NSString *imageName = @"mycharts_calendar_cell_background_green";
        UIColor *textColor = RGB(43, 192, 170);
        //    BOOL inCycle = [cell.date.cycle isEqual:self.cycle];
        NSUInteger dateIndex = [self.datesManager indexForDate:date.date];
        BOOL inCycle = (dateIndex != NSNotFound && dateIndex < self.cycle.length);
        if (inCycle) {
            cell.date = self.datesManager[dateIndex];
            if ([date.imageName isEqualToString:@"point_yellow"]) {
                //            imageName = @"mycharts_calendar_cell_background_yellow";
                textColor = RGB(243, 233, 134);
            }
            else if ([date.imageName isEqualToString:@"point_red"]) {
                //            imageName = @"mycharts_calendar_cell_background_red";
                textColor = RGB(230, 11, 5);
            }
            else if ([date.imageName isEqualToString:@"point_ovulation"]) {
                //            imageName = @"mycharts_calendar_cell_background_ovulation";
                textColor = RGB(230, 11, 5);
            } else
                textColor = RGB(255, 255, 255);
        } else {
            cell.date = date;
        }
        
        cell.backgroundColor = ([cell.date.date isToday] ? RGBA(43, 192, 170, 0.85) : RGBA(136, 219, 207, 0.85));
        cell.titleLabel.textColor = textColor;
        
        cell.enabled = inCycle;
        
        if (indexPath.item < 7)
            imageName = @"mycharts_calendar_cell_background_clear_top";
        else
            imageName = @"mycharts_calendar_cell_background_clear";
        
        UIImage *normalImage = [BPUtils imageNamed:imageName];
        UIImage *activeImage = [BPUtils imageNamed:[NSString stringWithFormat:@"%@_active", imageName]];
        activeImage = [normalImage imageAddingImage:activeImage offset:CGPointZero];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:imageName]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:activeImage];
        
        if (self.selectedDate && cell.enabled && [cell.date isEqual:self.selectedDate]) {
            [cell setSelected:[cell.date isEqual:self.selectedDate]];
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        BPSettings *sharedSettings = [BPSettings sharedSettings];
        NSDate *birthday = sharedSettings[BPSettingsProfileChildBirthdayKey];
        
        cell.childBirth = @(birthday && [cell.date.date isEqualToDateIgnoringTime:birthday]);
        
        return cell;
    } else {
        BPCalendarFooter *calendarFooter = [collectionView dequeueReusableCellWithReuseIdentifier:BPCalendarFooterIdentifier forIndexPath:indexPath];
        
        BPSettings *sharedSettings = [BPSettings sharedSettings];
        NSDate *birthday = sharedSettings[BPSettingsProfileChildBirthdayKey];
        
        calendarFooter.date = self.selectedDate;
        calendarFooter.childBirth = @(birthday && [self.selectedDate.date isEqualToDateIgnoringTime:birthday]);
        
        [calendarFooter updateUI];
        
        return calendarFooter;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BPCalendarHeader *calendarHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPCalendarHeaderIdentifier forIndexPath:indexPath];
        calendarHeader.delegate = self;
        
        calendarHeader.titleLabel.text = [BPUtils monthStringFromDate:self.selectedMonth];
        calendarHeader.prevButton.enabled = (self.selectedMonth.month > self.cycle.startDate.month);
        calendarHeader.nextButton.enabled = (self.selectedMonth.month < self.cycle.endDate.month);
        
        [calendarHeader updateDayOfWeekLabels];
        
        return calendarHeader;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
//    return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
//    return [self canSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    BPCalendarCell *cell = (BPCalendarCell *)[self.calendarView cellForItemAtIndexPath:indexPath];

    if (/*cell.isEnabled && */indexPath.section == 0) {
        self.selectedDate = cell.date;
//        [self updateCollectionView];
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
        
        [CATransaction commit];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BPCalendarCell *cell = (BPCalendarCell *)[self.calendarView cellForItemAtIndexPath:indexPath];
//    cell.selected = NO;
//}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return CGSizeMake(46.f, indexPath.item < 7 ? 47.f : 46.f);
    else {
        CGFloat height = [BPCalendarFooter heightForDate:self.selectedDate limitedToWidth:collectionView.width - 16.f];
        return CGSizeMake(collectionView.width - 16.f, height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0)
        return UIEdgeInsetsMake(0, -1, 0, -1);
    else
        return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGSizeMake(collectionView.width, 53.f);
    else
        return CGSizeZero;
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

    if (indexPath.section == 1)
        return NO;
    
    BPCalendarCell *cell = (BPCalendarCell *)[self.calendarView cellForItemAtIndexPath:indexPath];

    DLog(@"%i", cell.isEnabled);
    
    return cell.isEnabled;
}

- (void)updateCollectionView
{
    [self updateFirstDate];
    
    [self.calendarView reloadData];
}

@end
