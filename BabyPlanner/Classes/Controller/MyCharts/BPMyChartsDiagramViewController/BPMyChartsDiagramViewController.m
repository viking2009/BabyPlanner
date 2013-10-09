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
#import "MDSpreadView.h"

@interface BPMyChartsDiagramViewController () <MDSpreadViewDataSource, MDSpreadViewDelegate>

@property (nonatomic, strong) MDSpreadView *spreadView;

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
    self.spreadView.dataSource = nil;
    self.spreadView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.statusBarView.backgroundColor = [UIColor clearColor];
    
    self.spreadView = [[MDSpreadView alloc] initWithFrame:self.view.bounds];
    self.spreadView.backgroundColor = [UIColor clearColor];
    self.spreadView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.spreadView.dataSource = self;
    self.spreadView.delegate = self;
    [self.view addSubview:self.spreadView];
    
    [self updateUI];
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

- (void)updateUI
{
    [super updateUI];
    
    [self.spreadView reloadData];
}

#pragma mark - MDSpreadViewDataSource

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfColumnsInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0 ? 6 : 4);
}

- (NSInteger)numberOfColumnSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

- (NSInteger)numberOfRowSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 2;
}

// Comment these out to use normal values (see MDSpreadView.h)
- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(MDIndexPath *)indexPath
{
    return 30.f;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowHeaderInSection:(NSInteger)rowSection
{
    //    if (rowSection == 2) return 0; // uncomment to hide this header!
    return 30.f;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath
{
    return 30.f;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
{
    //    if (columnSection == 2) return 0; // uncomment to hide this header!
    return 38.f;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    if (rowPath.row >= 25) return nil; // use spreadView:objectValueForRowAtIndexPath:forColumnAtIndexPath below instead
    
    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Test Row %d-%d (%d-%d)", rowPath.section+1, rowPath.row+1, columnPath.section+1, columnPath.row+1];
    cell.textLabel.textColor = [UIColor colorWithRed:(arc4random()%100)/200. green:(arc4random()%100)/200. blue:(arc4random()%100)/200. alpha:1];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSString *backgroundImageName = ((rowPath.row + columnPath.column) % 2 ? @"mycharts_diagram_cell_background_2" : @"mycharts_diagram_cell_background_1");
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:backgroundImageName]];
    cell.backgroundView = backgroundView;
    
    return cell;
}

//
//- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)rowSection forColumnSection:(NSInteger)columnSection
//{
//    static NSString *cellIdentifier = @"CornerHeaderCell";
//
//    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleCorner reuseIdentifier:cellIdentifier] autorelease];
//    }
//
//    cell.textLabel.text = [NSString stringWithFormat:@"Cor %d-%d", columnSection+1, rowSection+1];
//
//    return cell;
//}
//
//- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
//{
//    static NSString *cellIdentifier = @"RowHeaderCell";
//
//    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleRow reuseIdentifier:cellIdentifier] autorelease];
//    }
//
//    cell.textLabel.text = [NSString stringWithFormat:@"Row Header %d (%d-%d)", section+1, columnPath.section+1, columnPath.row+1];
//
//    return cell;
//}
//
//- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
//{
//    static NSString *cellIdentifier = @"ColumnHeaderCell";
//
//    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleColumn reuseIdentifier:cellIdentifier] autorelease];
//    }
//
//    cell.textLabel.text = [NSString stringWithFormat:@"%d (%d-%d)", section+1, rowPath.section+1, rowPath.row+1];
//
//    return cell;
//}

// either do that ^^ for advanced customization, or this vv and let the cell take care of all the details
// both can be combined if you wanted, by returning nil to the above methods

#pragma mark - MDSpreadViewDelegate

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)rowSection forColumnSection:(NSInteger)columnSection
{
    return nil;// [NSString stringWithFormat:@"Cor %d-%d", columnSection+1, rowSection+1];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return [NSString stringWithFormat:@"%d", columnPath.row+1];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    return [NSString stringWithFormat:@"%d", section + 1];
}

- (id)spreadView:(MDSpreadView *)aSpreadView objectValueForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    return [NSString stringWithFormat:@"A Test Row %d-%d (%d-%d)", rowPath.section+1, rowPath.row+1, columnPath.section+1, columnPath.row+1];
}

- (void)spreadView:(MDSpreadView *)spreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    [spreadView deselectCellForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath animated:YES];
    NSLog(@"Selected %@ x %@", rowPath, columnPath);
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return nil;// [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];
}
@end
