//
//  BPPregnancyInfoView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPPregnancyInfoView.h"
#import "BPUtils.h"
#import "BPLanguageManager.h"
#import "UIView+Sizes.h"

@interface BPPregnancyInfoView()

@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dayLabel;

- (void)refreshDate;

@end

@implementation BPPregnancyInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.weekLabel = [[UILabel alloc] init];
        self.weekLabel.backgroundColor = [UIColor clearColor];
        self.weekLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:27];
        self.weekLabel.textColor = RGB(255, 255, 255);
        self.weekLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.weekLabel];
        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        self.dayLabel.textColor = RGB(255, 255, 255);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.numberOfLines = 2;
        [self addSubview:self.dayLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat top = 3.f;
    self.weekLabel.frame = CGRectMake(0, top, self.width, 25.f);
    top += self.weekLabel.height;
    
    self.dayLabel.frame = CGRectMake(0, top, self.width, 2*ceilf(self.dayLabel.font.lineHeight));
}

- (void)setDate:(NSDate *)date
{
    if (_date != date) {
        _date = date;
        
        [self refreshDate];
    }
}

- (void)setDay:(NSNumber *)day {
    if (_day != day) {
        _day = day;
        
        [self refreshDate];
    }
}

- (void)refreshDate
{
    DLog(@"%@", self.date);
/*
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit)
                                                   fromDate:self.date];
    
    DLog(@"%@", dateComponents);

    self.weekLabel.text = [NSString stringWithFormat:@"%i", dateComponents.day/7];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@\n%i %@", BPLocalizedString(@"week"), dateComponents.day%7, BPLocalizedString(@"day")];
 */
    self.weekLabel.text = [NSString stringWithFormat:@"%i", [self.day integerValue]/7 + 1];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@\n%i %@", BPLocalizedString(@"week"), [self.day integerValue] % 7 + 1, BPLocalizedString(@"day")];
}

- (void)updateUI
{
    [self refreshDate];
}

@end
