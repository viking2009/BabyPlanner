//
//  BPDiagramLayout.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "MSCollectionViewCalendarLayout.h"

extern NSString *const BPDiagramElementKindColumnHeader;
extern NSString *const BPDiagramElementKindRowHeader;
extern NSString *const BPDiagramElementKindChart;
extern NSString *const BPDiagramElementKindLegend;

//@interface BPDiagramLayout : MSCollectionViewCalendarLayout
@interface BPDiagramLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat columnHeaderWidth;
@property (nonatomic, assign) CGFloat rowHeaderHeight;

@end
