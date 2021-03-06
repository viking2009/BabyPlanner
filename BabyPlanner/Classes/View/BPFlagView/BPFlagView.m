//
//  BPFlagView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPFlagView.h"
#import "BPUtils.h"
#import "BPLanguageManager.h"
#import "UIView+Sizes.h"

@interface BPFlagView()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;

- (void)refreshDate;

@end

@implementation BPFlagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
        self.dayLabel.textColor = RGB(255, 255, 255);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];
        
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.monthLabel.textColor = RGB(255, 255, 255);
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.monthLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat top = 3.f;
    self.dayLabel.frame = CGRectMake(0, top, self.width, 22.f);
    top += self.dayLabel.height;
    
    self.monthLabel.frame = CGRectMake(0, top, self.width, ceilf(self.monthLabel.font.lineHeight));
}

- (void)setDate:(NSDate *)date
{
    if (_date != date) {
        _date = date;
        
        [self refreshDate];
    }
}

- (void)refreshDate
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
        dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    [dateFormatter setDateFormat:@"d"];
    self.dayLabel.text = [dateFormatter stringFromDate:self.date];
    
    [dateFormatter setDateFormat:@"MMM"];
    self.monthLabel.text = [dateFormatter stringFromDate:self.date];
}

- (void)updateUI
{
    [self refreshDate];
}

@end
