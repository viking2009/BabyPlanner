//
//  BPDiagramLayout.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "MSCollectionViewCalendarLayout.h"

#define BPDiagramLayoutItemSize 26.f
#define BPDiagramLayoutPadding 2.f
#define BPDiagramLayoutLegendHeight (BPDiagramLayoutItemSize + 7.f)

extern NSString *const BPDiagramElementKindColumnHeaderBackground;
extern NSString *const BPDiagramElementKindColumnHeader;
extern NSString *const BPDiagramElementKindRowHeader;
extern NSString *const BPDiagramElementKindChart;
extern NSString *const BPDiagramElementKindLegend;
extern NSString *const BPDiagramElementKindMonth;

//@interface BPDiagramLayout : MSCollectionViewCalendarLayout
@interface BPDiagramLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat columnHeaderWidth;
@property (nonatomic, assign) CGFloat rowHeaderHeight;

@end
