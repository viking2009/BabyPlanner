//
//  BPDiagramLegend.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramLegend.h"

@implementation BPDiagramLegend

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(64, 187, 113, 0.85);
        // TODO: add ovulation legend
    }
    
    return self;
}

@end
