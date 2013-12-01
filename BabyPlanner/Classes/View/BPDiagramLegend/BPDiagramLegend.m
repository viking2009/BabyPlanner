//
//  BPDiagramLegend.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramLegend.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"
#import "BPDiagramLayout.h"

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

- (void)drawRect:(CGRect)rect
{
    if (self.icons.count == 0)
        return;
    
    // Drawing code
    
    // first icon
    UIImage *firstIcon = [BPUtils imageNamed:@"mycharts_diagram_legend_icon_first"];
    for (NSNumber *day in _icons[0]) {
        CGRect iconRect = CGRectMake([day integerValue]*BPDiagramLayoutItemSize, floorf(self.height/2 - firstIcon.size.height/2), firstIcon.size.width, firstIcon.size.height);
        [firstIcon drawInRect:iconRect];
    }
    
    if (self.icons.count == 1)
        return;

    // second icon
    UIImage *secondIcon = [BPUtils imageNamed:@"mycharts_diagram_legend_icon_second"];
    [RGBA(222, 36, 35, 0.85) setFill];
    for (NSNumber *day in _icons[1]) {
        CGRect iconRect = CGRectMake([day integerValue]*BPDiagramLayoutItemSize, floorf(self.height/2 - secondIcon.size.height/2), secondIcon.size.width, secondIcon.size.height);
        UIRectFill(iconRect);
        [secondIcon drawInRect:iconRect];
    }
}

- (void)setIcons:(NSArray *)icons {
//    if (_icons != icons) {
        _icons = icons;
        [self setNeedsDisplay];
//    }
}

@end
