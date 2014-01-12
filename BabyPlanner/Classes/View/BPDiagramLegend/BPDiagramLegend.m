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
#import "BPDatesManager.h"

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
        CGRect iconRect = CGRectMake([day integerValue]*BPDiagramLayoutItemSize - floorf(firstIcon.size.width/2 - BPDiagramLayoutItemSize/2 + BPDiagramLayoutPadding/2), floorf(self.height/2 - firstIcon.size.height/2), firstIcon.size.width, firstIcon.size.height);
        [firstIcon drawInRect:iconRect];
    }
    
    if (self.icons.count == 1)
        return;

    // second icon
    UIImage *secondIcon = [BPUtils imageNamed:@"mycharts_diagram_legend_icon_second"];
    [RGBA(222, 36, 35, 0.85) setFill];
    for (NSNumber *day in _icons[1]) {
        CGRect fertileRect = CGRectMake(([day integerValue] - kBPDatesManagerFertileBefore)*BPDiagramLayoutItemSize - floorf(BPDiagramLayoutPadding/2), 0, (kBPDatesManagerFertileBefore + 1 + kBPDatesManagerFertileAfter)*BPDiagramLayoutItemSize, self.height);
        UIRectFill(fertileRect);
        CGRect iconRect = CGRectMake([day integerValue]*BPDiagramLayoutItemSize - floorf(secondIcon.size.width/2 - BPDiagramLayoutItemSize/2 + BPDiagramLayoutPadding/2), floorf(self.height/2 - secondIcon.size.height/2), secondIcon.size.width, secondIcon.size.height);
        [secondIcon drawInRect:iconRect];
    }
    
    if (self.icons.count == 2)
        return;

    // pregnancy icon
    UIImage *thirdIcon = [BPUtils imageNamed:@"mycharts_diagram_legend_icon_pregnant"];
    [RGB(255, 255, 255) setFill];
    NSUInteger weeknumber = 1;
    for (NSNumber *day in _icons[2]) {
        CGRect iconRect = CGRectMake([day integerValue]*BPDiagramLayoutItemSize - floorf(thirdIcon.size.width/2 - BPDiagramLayoutItemSize/2 + BPDiagramLayoutPadding/2), floorf(self.height/2 - thirdIcon.size.height/2), thirdIcon.size.width, thirdIcon.size.height);
        [thirdIcon drawInRect:iconRect];
        NSString *weeknumberString = [NSString stringWithFormat:@"%i", weeknumber];
        iconRect.origin.x += 14.f;
        iconRect.origin.y += 1.f;
        iconRect.size.width -= 14.f;
        [weeknumberString drawInRect:iconRect withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        weeknumber++;
    }
}

- (void)setIcons:(NSArray *)icons {
//    if (_icons != icons) {
        _icons = icons;
        [self setNeedsDisplay];
//    }
}

@end
