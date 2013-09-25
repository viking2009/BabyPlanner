//
//  BPCalendarHeader.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarHeader.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"
#import "BPLanguageManager.h"

#define BPCalendarHeaderBackgroundImageHeight 53.f
#define BPCalendarHeaderButtonSize 40.f
#define BPCalendarHeaderMonthLabelHeight 23.f
#define BPCalendarHeaderYearLabelHeight 18.f
#define BPCalendarHeaderDayOfWeekLabelWidth 46.f

@interface BPCalendarHeader ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSArray *dayOfWeekLabels;

- (void)didTapPrevButton;
- (void)didTapNextButton;

@end

@implementation BPCalendarHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImage = [BPUtils imageNamed:@"mycharts_calendar_header_background"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:self.backgroundImageView];
        
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:23];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.textColor = RGB(255, 255, 255);
        [self addSubview:self.monthLabel];
        
        self.yearLabel = [[UILabel alloc] init];
        self.yearLabel.backgroundColor = [UIColor clearColor];
        self.yearLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.yearLabel.textAlignment = NSTextAlignmentCenter;
        self.yearLabel.textColor = RGB(255, 255, 255);
        [self addSubview:self.yearLabel];
        
        self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.prevButton setImage:[BPUtils imageNamed:@"mycharts_calendar_button_prev"] forState:UIControlStateNormal];
        [self.prevButton addTarget:self action:@selector(didTapPrevButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.prevButton];

        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextButton setImage:[BPUtils imageNamed:@"mycharts_calendar_button_next"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(didTapNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
        NSDateFormatter *dateFormatter = [BPUtils dateFormatter];
        NSUInteger numberOfLabels = [[dateFormatter shortWeekdaySymbols] count];
        NSMutableArray *labels = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < numberOfLabels; ++i) {
            UILabel *dayOfWeekLabel = [[UILabel alloc] init];
            dayOfWeekLabel.backgroundColor = [UIColor clearColor];
            dayOfWeekLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
            dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
            dayOfWeekLabel.textColor = RGB(255, 255, 255);
            [labels addObject:dayOfWeekLabel];
            [self addSubview:dayOfWeekLabel];
        }
        self.dayOfWeekLabels = labels;
        
        [self updateDayOfWeekLabels];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = CGRectMake(0, 0, self.width, BPCalendarHeaderBackgroundImageHeight);
    
    CGFloat left = 0.f;
    CGFloat buttonSize = MIN(BPCalendarHeaderButtonSize, BPCalendarHeaderBackgroundImageHeight);
    CGFloat maxWidth = self.width - 2 * buttonSize;
    CGFloat top = floorf(BPCalendarHeaderBackgroundImageHeight/2 - (BPCalendarHeaderMonthLabelHeight + BPCalendarHeaderYearLabelHeight)/2);
    
    self.prevButton.frame = CGRectMake(left, floorf(BPCalendarHeaderBackgroundImageHeight/2 - buttonSize/2), buttonSize, buttonSize);
    left += self.prevButton.width;

    self.monthLabel.frame = CGRectMake(left, top, maxWidth, BPCalendarHeaderMonthLabelHeight);
    top += self.monthLabel.height;
    
    self.yearLabel.frame = CGRectMake(left, top, maxWidth, BPCalendarHeaderYearLabelHeight);
    left += self.yearLabel.width;
    
    self.nextButton.frame = CGRectMake(left, floorf(BPCalendarHeaderBackgroundImageHeight/2 - buttonSize/2), buttonSize, buttonSize);
    
    CGFloat dayOfWeekLabelHeight = self.height - BPCalendarHeaderBackgroundImageHeight;
    [self.dayOfWeekLabels enumerateObjectsUsingBlock:^(UILabel *dayOfWeekLabel, NSUInteger idx, BOOL *stop) {
        dayOfWeekLabel.frame = CGRectMake(-1 + idx*BPCalendarHeaderDayOfWeekLabelWidth, BPCalendarHeaderBackgroundImageHeight, BPCalendarHeaderDayOfWeekLabelWidth, dayOfWeekLabelHeight);
    }];
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.monthLabel.text = nil;
    self.yearLabel.text = nil;
}

#pragma mark - Private

- (void)didTapPrevButton
{
    if ([self.delegate respondsToSelector:@selector(calendarHeaderDidTapPrevButton:)])
        [self.delegate performSelector:@selector(calendarHeaderDidTapPrevButton:) withObject:self];
}

- (void)didTapNextButton
{
    if ([self.delegate respondsToSelector:@selector(calendarHeaderDidTapNextButton:)])
        [self.delegate performSelector:@selector(calendarHeaderDidTapNextButton:) withObject:self];
}

- (void)updateDayOfWeekLabels
{
    NSDateFormatter *dateFormatter = [BPUtils dateFormatter];
    NSUInteger numberOfLabels = [[dateFormatter shortWeekdaySymbols] count];
    NSInteger shift = ([[BPLanguageManager sharedManager].currentLanguage isEqualToString:@"ru"] ? 1 : 0);
    [self.dayOfWeekLabels enumerateObjectsUsingBlock:^(UILabel *dayOfWeekLabel, NSUInteger idx, BOOL *stop) {
        NSInteger position = (idx + shift) % numberOfLabels;
        dayOfWeekLabel.text = [[dateFormatter shortWeekdaySymbols][position] uppercaseString];
    }];
}

@end
