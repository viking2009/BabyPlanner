//
//  BPMyChartsDiagramViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 23.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyChartsDiagramViewController.h"
#import "UIView+Sizes.h"
#import "BPUtils.h"
#import "BPDiagramLayout.h"
#import "BPDatesManager.h"
#import "NSDate-Utilities.h"
#import "BPDate+Additions.h"
#import "BPDiagramCell.h"
#import "BPDiagramLegend.h"
#import "BPDiagramColumnHeaderCell.h"
#import "BPDiagramHeaderView.h"
#import "BPDiagramRowHeaderCell.h"
#import "BPDiagramChart.h"
#import "MSCollectionViewCalendarLayout.h"

#define BPDiagramCellIdentifier @"BPDiagramCellIdentifier"
#define BPDiagramLegendIdentifier @"BPDiagramLegendIdentifier"
#define BPDiagramHeaderCellIdentifier @"BPDiagramHeaderCellIdentifier"
#define BPDiagramHeaderViewIdentifier @"BPDiagramHeaderViewIdentifier"
#define BPDiagramRowHeaderIdentifier @"BPDiagramRowHeaderIdentifier"
#define BPDiagramChartIdentifier @"BPDiagramChartIdentifier"

@interface BPMyChartsDiagramViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MSCollectionViewDelegateCalendarLayout>

@property (nonatomic, strong) UICollectionView *diagramView;
@property (nonatomic, strong) BPDatesManager *datesManager;
@property (nonatomic, strong, readwrite) BPDate *selectedDate;

@end

@implementation BPMyChartsDiagramViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.diagramView.dataSource = nil;
    self.diagramView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.statusBarView.backgroundColor = [UIColor clearColor];
    
    BPDiagramLayout *diagramLayout = [[BPDiagramLayout alloc] init];
//    diagramLayout.delegate = self;
    
    self.diagramView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:diagramLayout];
    self.diagramView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    self.diagramView.backgroundView = nil;
    self.diagramView.backgroundColor = [UIColor clearColor];
    self.diagramView.dataSource = self;
    self.diagramView.delegate = self;
    [self.view addSubview:self.diagramView];
    
    [self.diagramView registerClass:[BPDiagramCell class] forCellWithReuseIdentifier:BPDiagramCellIdentifier];
    [self.diagramView registerClass:[BPDiagramColumnHeaderCell class] forSupplementaryViewOfKind:BPDiagramElementKindColumnHeader withReuseIdentifier:BPDiagramHeaderCellIdentifier];
    [self.diagramView registerClass:[BPDiagramRowHeaderCell class] forSupplementaryViewOfKind:BPDiagramElementKindRowHeader withReuseIdentifier:BPDiagramRowHeaderIdentifier];
    [self.diagramView registerClass:[BPDiagramColumnHeaderCell class] forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:BPDiagramHeaderCellIdentifier];
    [self.diagramView registerClass:[BPDiagramHeaderView class] forSupplementaryViewOfKind:BPDiagramElementKindColumnHeaderBackground withReuseIdentifier:BPDiagramHeaderViewIdentifier];
    [self.diagramView registerClass:[BPDiagramLegend class] forSupplementaryViewOfKind:BPDiagramElementKindLegend withReuseIdentifier:BPDiagramLegendIdentifier];
    [self.diagramView registerClass:[BPDiagramChart class] forSupplementaryViewOfKind:BPDiagramElementKindChart withReuseIdentifier:BPDiagramChartIdentifier];
//    [self.diagramView.collectionViewLayout registerClass:[BPDiagramLegend class] forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];

    [self updateUI];
//    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{

}

- (void)loadData
{
    self.datesManager = [[BPDatesManager alloc] initWithCycle:self.cycle];
}

- (void)updateUI
{
    [super updateUI];
    
    [self loadData];
    [self.diagramView reloadData];
}

- (void)localize
{
    [super localize];
    
    [self.diagramView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.datesManager.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPDiagramCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPDiagramCellIdentifier forIndexPath:indexPath];
    
    NSString *backgroundImageName = (indexPath.item % 2 == 1 ? @"mycharts_diagram_cell_background_2" : @"mycharts_diagram_cell_background_1");
    UIImage *backgroundImage = [[BPUtils imageNamed:backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    cell.backgroundView = backgroundView;
    
    cell.date = self.datesManager[indexPath.section];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if (kind == BPDiagramElementKindColumnHeaderBackground && indexPath.section == 0 && indexPath.item == 0) {
        BPDiagramHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramHeaderViewIdentifier forIndexPath:indexPath];
        headerView.titleLabel.text = [NSString stringWithFormat:BPLocalizedString(@"Cycle %@"), self.cycle.index];
        view = headerView;
    } else if (kind == BPDiagramElementKindRowHeader && indexPath.section == 0 && indexPath.item == 0) {
        BPDiagramRowHeaderCell *rowView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramRowHeaderIdentifier forIndexPath:indexPath];
        rowView.backgroundColor = RGB(64, 187, 166);
        [rowView updateUI];
        view = rowView;
    } else if (kind == BPDiagramElementKindColumnHeader) {
        BPDiagramColumnHeaderCell *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramHeaderCellIdentifier forIndexPath:indexPath];
        dayColumnHeader.date = self.datesManager[indexPath.section];
        view = dayColumnHeader;
    } else if (kind == BPDiagramElementKindChart && indexPath.section == 0 && indexPath.item == 0) {
        BPDiagramChart *chart = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramChartIdentifier forIndexPath:indexPath];
        NSMutableArray *temperatures = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.datesManager.count; i ++) {
            BPDate *date = self.datesManager[i];
            if ([date.temperature integerValue])
                [temperatures addObject:@{@"day": date.day, @"temperature": date.temperature}];
        }
        
        chart.temperatures = temperatures;
        view = chart;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        BPDiagramColumnHeaderCell *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramHeaderCellIdentifier forIndexPath:indexPath];
        dayColumnHeader.date = self.datesManager[indexPath.section];
        view = dayColumnHeader;
    } else if (kind == BPDiagramElementKindLegend && indexPath.section == 0 && indexPath.item == 0) {
        BPDiagramLegend *legend = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BPDiagramLegendIdentifier forIndexPath:indexPath];
//        legend.backgroundColor = RGB(64, 187, 113);
        view = legend;
    }
    return view;
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
    DLog(@"%@", indexPath);
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    BPDate *date = self.datesManager[section];
    return date.date;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPDate *date = self.datesManager[indexPath.section];
    return date.date;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPDate *date = self.datesManager[indexPath.section];
    return [date.date dateByAddingHours:11];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return [NSDate date];
}

@end
