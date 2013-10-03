//
//  BPCalendarLayout.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarLayout.h"
#import "UIView+Sizes.h"

#define BPCalendarLayoutZIndexOffset 800
#define BPCalendarLayoutItemSize 46.f

@implementation BPCalendarLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(BPCalendarLayoutItemSize, BPCalendarLayoutItemSize);
        self.headerReferenceSize = CGSizeMake(320.f, 53.f);
        self.footerReferenceSize = CGSizeMake(320.f, 150.f);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(0, -1, 0, -1);
    }
    
    return self;
}

#pragma mark - UICollectionViewLayout (SubclassingHooks)

- (void)prepareLayout
{
//    CGFloat inset = floorf(self.collectionView.width - 322.f);
//    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    [super prepareLayout];
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
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
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
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
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
    
    return answer;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//    layoutAttributes.zIndex = BPCalendarLayoutZIndexOffset + indexPath.item;
//    
//    return layoutAttributes;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
{
    return nil;
}

@end
