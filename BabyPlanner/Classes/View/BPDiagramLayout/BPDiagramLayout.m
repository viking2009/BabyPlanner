//
//  BPDiagramLayout.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramLayout.h"
#import "ObjectiveSugar.h"

NSString *const BPDiagramElementKindColumnHeader = @"BPDiagramElementKindColumnHeader";
NSString *const BPDiagramElementKindRowHeader = @"BPDiagramElementKindRowHeader";
NSString *const BPDiagramElementKindChart = @"BPDiagramElementKindChart";
NSString *const BPDiagramElementKindLegend = @"BPDiagramElementKindLegend";

@interface BPDiagramLayout ()

@property (strong, nonatomic) NSMutableArray *allAttributes;
@property (strong, nonatomic) NSMutableArray *cellAttributes;
@property (strong, nonatomic) NSMutableArray *headerAttributes;

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

    self.allAttributes = [[NSMutableArray alloc] init];
    [self.allAttributes addObjectsFromArray:self.headerAttributes];
    [self.allAttributes addObjectsFromArray:self.cellAttributes];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.allAttributes select:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = CGRectMake(self.columnHeaderWidth + self.itemSize.width * indexPath.section, self.rowHeaderHeight + indexPath.row, self.itemSize.width, self.itemSize.height);
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{    
    if ([kind isEqualToString:BPDiagramElementKindColumnHeader]) {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

        layoutAttributes.frame = CGRectMake(self.columnHeaderWidth + self.itemSize.width * indexPath.section, 0, self.itemSize.width, self.rowHeaderHeight);

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
//    NSInteger item = (proposedContentOffset.y - self.dayColumnHeaderHeight)/self.hourHeight;
//    return CGPointMake(section*self.sectionWidth, self.dayColumnHeaderHeight + item*self.hourHeight);
    NSInteger section = proposedContentOffset.x/self.itemSize.width;
    return CGPointMake(section * self.itemSize.width, proposedContentOffset.y);
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.columnHeaderWidth + self.collectionView.numberOfSections * self.itemSize.width, self.rowHeaderHeight + self.itemSize.height);
}

@end
