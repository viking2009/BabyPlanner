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
#define BPCalendarHeaderDayOfWeekLabelWidth 46.f
#define BPCalendarHeaderDayOfWeekLabelHeight 23.f

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
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:23];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = RGB(255, 255, 255);
        [self addSubview:self.titleLabel];
        
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
            dayOfWeekLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
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
    
    self.prevButton.frame = CGRectMake(left, floorf(BPCalendarHeaderBackgroundImageHeight/2 - buttonSize/2), buttonSize, buttonSize);
    left += self.prevButton.width;

    self.titleLabel.frame = CGRectMake(left, 0, maxWidth, BPCalendarHeaderBackgroundImageHeight - 8.f);
    left += self.titleLabel.width;
    
    self.nextButton.frame = CGRectMake(left, floorf(BPCalendarHeaderBackgroundImageHeight/2 - buttonSize/2), buttonSize, buttonSize);
    
    [self.dayOfWeekLabels enumerateObjectsUsingBlock:^(UILabel *dayOfWeekLabel, NSUInteger idx, BOOL *stop) {
        dayOfWeekLabel.frame = CGRectMake(-1 + idx*BPCalendarHeaderDayOfWeekLabelWidth, BPCalendarHeaderBackgroundImageHeight - BPCalendarHeaderDayOfWeekLabelHeight, BPCalendarHeaderDayOfWeekLabelWidth, BPCalendarHeaderDayOfWeekLabelHeight);
    }];
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
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
