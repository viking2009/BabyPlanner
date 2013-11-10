//
//  BPDiagramLayout.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramLayout.h"
#import "ObjectiveSugar.h"
#import "UIView+Sizes.h"

#define BPDiagramLayoutLegendHeight 37.0f
#define BPDiagramLayoutChartHeight 180.0f

NSString *const BPDiagramElementKindColumnHeaderBackground = @"BPDiagramElementKindColumnHeaderBackground";
NSString *const BPDiagramElementKindColumnHeader = @"BPDiagramElementKindColumnHeader";
NSString *const BPDiagramElementKindRowHeader = @"BPDiagramElementKindRowHeader";
NSString *const BPDiagramElementKindChart = @"BPDiagramElementKindChart";
NSString *const BPDiagramElementKindLegend = @"BPDiagramElementKindLegend";

@interface BPDiagramLayout ()

@property (strong, nonatomic) NSMutableArray *allAttributes;
@property (strong, nonatomic) NSMutableArray *cellAttributes;
@property (strong, nonatomic) NSMutableArray *headerAttributes;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *headerBackgroundAttributes;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *rowHeaderAttributes;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *legendAttributes;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *chartAttributes;

@end

@implementation BPDiagramLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(30.f, 330.f);
        self.columnHeaderWidth = 320.f - 9*self.itemSize.width;
        self.rowHeaderHeight = 60.0f;
    }
    
    return self;
}

#pragma mark - UICollectionViewLayout (SubclassingHooks)

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.cellAttributes = [[NSMutableArray alloc] init];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.cellAttributes addObject:layoutAttributes];
    }
    
    self.headerAttributes = [[NSMutableArray alloc] init];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:BPDiagramElementKindColumnHeader atIndexPath:indexPath];
        if (layoutAttributes)
            [self.headerAttributes addObject:layoutAttributes];
    }

    NSIndexPath *zeroPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.headerBackgroundAttributes = [self layoutAttributesForSupplementaryViewOfKind:BPDiagramElementKindColumnHeaderBackground atIndexPath:zeroPath];
    self.rowHeaderAttributes = [self layoutAttributesForSupplementaryViewOfKind:BPDiagramElementKindRowHeader atIndexPath:zeroPath];
    self.legendAttributes = [self layoutAttributesForSupplementaryViewOfKind:BPDiagramElementKindLegend atIndexPath:zeroPath];    
    self.chartAttributes = [self layoutAttributesForSupplementaryViewOfKind:BPDiagramElementKindChart atIndexPath:zeroPath];
    
    self.allAttributes = [[NSMutableArray alloc] init];
    [self.allAttributes addObjectsFromArray:self.headerAttributes];
    [self.allAttributes addObjectsFromArray:self.cellAttributes];
    [self.allAttributes addObject:self.headerBackgroundAttributes];
    [self.allAttributes addObject:self.rowHeaderAttributes];
    [self.allAttributes addObject:self.legendAttributes];
    [self.allAttributes addObject:self.chartAttributes];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *answer = [[self.allAttributes select:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }] mutableCopy];
    
    if (![answer containsObject:self.headerBackgroundAttributes])
        [answer addObject:self.headerBackgroundAttributes];

    if (![answer containsObject:self.rowHeaderAttributes])
        [answer addObject:self.rowHeaderAttributes];

    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;

    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            [missingSections addIndex:layoutAttributes.indexPath.section];
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
            [missingSections removeIndex:layoutAttributes.indexPath.section];
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes)
            [answer addObject:layoutAttributes];
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:BPDiagramElementKindColumnHeaderBackground]) {
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(
                               contentOffset.y,
                               (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)
                               ),
                           (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
                           );
            
            if (contentOffset.y < 0)
                origin.y = contentOffset.y;
            
//            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = contentOffset,
                .size = layoutAttributes.frame.size
            };
        } else if ([layoutAttributes.representedElementKind isEqualToString:BPDiagramElementKindRowHeader]) {
//            NSInteger section = layoutAttributes.indexPath.section;
//            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
//            
//            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
//            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
//            
//            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
//            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
//            
//            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
//            origin.y = MIN(
//                           MAX(
//                               contentOffset.y,
//                               (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)
//                               ),
//                           (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
//                           );
            
//            if (contentOffset.x < 0)
                origin.x = contentOffset.x;
            
            //            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        } else if ([layoutAttributes.representedElementKind isEqualToString:BPDiagramElementKindColumnHeader]) {
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(
                               contentOffset.y,
                               (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)
                               ),
                           (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
                           );
            
            if (contentOffset.y < 0)
                origin.y = contentOffset.y;
            
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
    
    return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = CGRectMake(self.columnHeaderWidth + self.itemSize.width * indexPath.section, self.rowHeaderHeight - 1.0f, self.itemSize.width, self.itemSize.height);
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{    
    if ([kind isEqualToString:BPDiagramElementKindRowHeader]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(0, self.rowHeaderHeight - 1.0f, self.columnHeaderWidth, self.itemSize.height);
        layoutAttributes.zIndex = 803;
        
        return layoutAttributes;
    } else if ([kind isEqualToString:BPDiagramElementKindLegend]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(self.columnHeaderWidth, self.rowHeaderHeight - 3.0f + 3*self.rowHeaderHeight, self.collectionView.numberOfSections*self.itemSize.width, BPDiagramLayoutLegendHeight);
        layoutAttributes.zIndex = 804;
        
        return layoutAttributes;
    } else if ([kind isEqualToString:BPDiagramElementKindChart]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(self.columnHeaderWidth, self.rowHeaderHeight - 1.0f, self.collectionView.numberOfSections*self.itemSize.width, BPDiagramLayoutChartHeight);
        layoutAttributes.zIndex = 800;
        
        return layoutAttributes;
    } else if ([kind isEqualToString:BPDiagramElementKindColumnHeader]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

        layoutAttributes.frame = CGRectMake(self.columnHeaderWidth + self.itemSize.width * indexPath.section, 0, self.itemSize.width, self.rowHeaderHeight);
        layoutAttributes.zIndex = 802;
        
        return layoutAttributes;
    } else if ([kind isEqualToString:BPDiagramElementKindColumnHeaderBackground]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(0, 0, self.collectionView.width, self.rowHeaderHeight);
        layoutAttributes.zIndex = 801;
        
        return layoutAttributes;
    }


    return nil;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
//
//    layoutAttributes.frame = CGRectZero;
//
//    return layoutAttributes;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
//{
//    return nil;
//}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
//    NSInteger section = proposedContentOffset.x/self.sectionWidth;
//    return CGPointMake(section*self.sectionWidth, self.dayColumnHeaderHeight + item*self.hourHeight);
    NSInteger section = (proposedContentOffset.x)/self.itemSize.width;
    NSInteger item = (proposedContentOffset.y - self.rowHeaderHeight)/30.0f;
    return CGPointMake(section * self.itemSize.width, self.rowHeaderHeight + item*30.f);
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.columnHeaderWidth + self.collectionView.numberOfSections * self.itemSize.width, self.rowHeaderHeight + self.itemSize.height);
}

@end
