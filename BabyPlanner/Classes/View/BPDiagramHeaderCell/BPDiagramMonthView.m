//
//  BPDiagramMonthView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 01.12.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramMonthView.h"
#import "UIView+Sizes.h"

#define BPDiagramMonthViewPadding 4.0f

@interface BPDiagramMonthView ()

@property (nonatomic, strong, readwrite) UILabel *monthLabel;

@end

@implementation BPDiagramMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        self.monthLabel.textColor = RGB(255, 255, 255);
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.monthLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxWidth = self.width - 2*BPDiagramMonthViewPadding;
    self.monthLabel.frame = CGRectMake(BPDiagramMonthViewPadding, 0, maxWidth, self.height);
}

@end
