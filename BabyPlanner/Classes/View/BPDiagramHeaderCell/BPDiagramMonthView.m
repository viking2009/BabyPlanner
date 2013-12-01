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

@property (nonatomic, strong, readwrite) UILabel *firstMonthLabel;
@property (nonatomic, strong, readwrite) UILabel *secondMonthLabel;

@end

@implementation BPDiagramMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.firstMonthLabel = [[UILabel alloc] init];
        self.firstMonthLabel.backgroundColor = [UIColor clearColor];
        self.firstMonthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        self.firstMonthLabel.textColor = RGB(255, 255, 255);
        [self addSubview:self.firstMonthLabel];

        self.secondMonthLabel = [[UILabel alloc] init];
        self.secondMonthLabel.backgroundColor = [UIColor clearColor];
        self.secondMonthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        self.secondMonthLabel.textColor = RGB(255, 255, 255);
        self.secondMonthLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.secondMonthLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxWidth = self.width - 2*BPDiagramMonthViewPadding;
    self.firstMonthLabel.frame = CGRectMake(BPDiagramMonthViewPadding, 0, floorf(maxWidth/2), self.height);
    self.secondMonthLabel.frame = CGRectMake(self.firstMonthLabel.right, 0, floorf(maxWidth/2), self.height);
}

@end
