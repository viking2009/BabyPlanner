//
//  BPDiagramChart.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 10.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramChart.h"
#import "UIView+Sizes.h"

#define BPDiagramChartItemSize 30.0f
#define BPDiagramChartItemVShift 1.0f
#define BPDiagramChartItemHShift 1.0f
#define BPDiagramChartInternalSize 28.0f
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
//    if (self.temperatures.count == 0)
//        return;
    
    // Drawing code
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 3.0f;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    CGFloat scale = self.height/(BPDiagramChartMaxTemperature - BPDiagramChartMinTemperature);
    DLog(@"scale = %f", scale);
    
    NSDictionary *firstTemperatureDict = _temperatures[0];
    NSInteger lastDay = [firstTemperatureDict[@"day"] integerValue];
    CGPoint startPoint = CGPointZero;
    startPoint.x = lastDay * BPDiagramChartItemSize - BPDiagramChartItemHShift;
    startPoint.y = self.height - floorf(scale * ([firstTemperatureDict[@"temperature"] floatValue] - BPDiagramChartMinTemperature));
    
    [bezierPath moveToPoint:startPoint];
    for (NSDictionary *temperatureDict in self.temperatures) {
        lastDay = [temperatureDict[@"day"] integerValue];
        CGPoint point = CGPointZero;
        point.x = lastDay * BPDiagramChartItemSize - BPDiagramChartItemHShift;
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
