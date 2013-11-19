//
//  BPDiagramChart.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 10.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramChart.h"
#import "UIView+Sizes.h"
#import "BPDiagramLayout.h"

#define BPDiagramChartLineWidth 3.0f
#define BPDiagramChartMaxTemperature 38
#define BPDiagramChartMinTemperature 35

@implementation BPDiagramChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.temperatures.count == 0)
        return;
    
    // Drawing code
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = BPDiagramChartLineWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    CGFloat scale = self.height/(BPDiagramChartMaxTemperature - BPDiagramChartMinTemperature);
    
    CGFloat hShift = floorf(BPDiagramLayoutItemSize/2 + BPDiagramLayoutPadding/2 + BPDiagramChartLineWidth/2);

    NSDictionary *firstTemperatureDict = _temperatures[0];
    NSInteger lastDay = [firstTemperatureDict[@"day"] integerValue];
    CGPoint startPoint = CGPointZero;
    startPoint.x = lastDay * BPDiagramLayoutItemSize - hShift;
    startPoint.y = self.height - floorf(scale * ([firstTemperatureDict[@"temperature"] floatValue] - BPDiagramChartMinTemperature));
    
    [bezierPath moveToPoint:startPoint];
    for (NSDictionary *temperatureDict in self.temperatures) {
        lastDay = [temperatureDict[@"day"] integerValue];
        CGPoint point = CGPointZero;
        point.x = lastDay * BPDiagramLayoutItemSize - hShift;
        point.y = self.height - floorf(scale * ([temperatureDict[@"temperature"] floatValue] - BPDiagramChartMinTemperature));
        [bezierPath addLineToPoint:point];
    }
//
//    CGPoint startPoint
//    [bezierPath addLineToPoint:CGPointMake(self.bounds.size.width - BPDiagramChartItemSize - BPDiagramChartItemHShift, self.bounds.size.height - BPDiagramChartItemSize - BPDiagramChartItemVShift)];
    
    [RGB(201, 59, 49) setStroke];
    
    [bezierPath stroke];
}

- (void)setTemperatures:(NSArray *)temperatures {
//    if (_temperatures != temperatures) {
        _temperatures = temperatures;
        [self setNeedsDisplay];
//    }
}

@end
