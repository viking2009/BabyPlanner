//
//  BPCalendarView.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 03.10.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarView.h"

@implementation BPCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    DLog();
    [super selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

@end
