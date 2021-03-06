//
//  BPDiagramHeaderCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramColumnHeaderCell.h"
#import "BPDate+Additions.h"
#import "NSDate-Utilities.h"
#import "UIView+Sizes.h"

#define BPDiagramColumnHeaderCellTop 36.0f

@interface BPDiagramColumnHeaderCell ()

@property (nonatomic, strong) UILabel *dayLabel;

@end


@implementation BPDiagramColumnHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        self.dayLabel.textColor = RGB(2, 106, 80);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dayLabel.frame = CGRectMake(0, BPDiagramColumnHeaderCellTop, self.width - 2.0f, self.height - BPDiagramColumnHeaderCellTop);
}

#pragma mark - Public

- (void)setDate:(BPDate *)date
{
    //    if (_date != date) {
    _date = date;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%i", _date.date.day];
    
    [self setNeedsLayout];
    //    }
}

@end
