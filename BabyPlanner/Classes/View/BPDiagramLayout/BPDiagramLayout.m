//
//  BPDiagramLayout.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramLayout.h"

@implementation BPDiagramLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
        self.sectionWidth = 30.f;
        self.hourHeight = 30.f;
        self.dayColumnHeaderHeight = 60.0f;
        self.headerLayoutType = MSHeaderLayoutTypeTimeRowAboveDayColumn;
        self.timeRowHeaderWidth = 320 - 9*self.sectionWidth;
        self.currentTimeHorizontalGridlineHeight = 38.f;
    }
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
{
    return nil;
}

@end
