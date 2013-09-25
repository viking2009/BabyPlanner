//
//  BPCalendarFooter.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarFooter.h"
#import "BPLanguageManager.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"
#import "BPDate+Additions.h"

#define BPCalendarFooterDayTop      38.f
#define BPCalendarFooterFirstLine   30.f
#define BPCalendarFooterSecondLine  58.f
#define BPCalendarFooterPadding     12.f
#define BPCalendarFooterDayLabelHeight 20.f
#define BPCalendarFooterNotesLabelHeight 30.f
#define BPCalendarFooterLinesHorizontalPadding 15.f
#define BPCalendarFooterLinesTopPadding 28.f
#define BPCalendarFooterLinesBottomPadding 5.f

@interface BPCalendarFooter ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *linesImageView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *boyView;
@property (nonatomic, strong) UIImageView *menstruationView;
@property (nonatomic, strong) UIImageView *ovulationView;
@property (nonatomic, strong) UIImageView *sexualIntercourseView;
@property (nonatomic, strong) UIImageView *pregnantView;
@property (nonatomic, strong) UIImageView *childBirthView;
@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UILabel *notesLabel;

@end

@implementation BPCalendarFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImage = [BPUtils imageNamed:@"mycharts_calendar_notes_background"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:self.backgroundImageView];

        UIImage *linesImage = [BPUtils imageNamed:@"mycharts_calendar_notes_lines"];
        self.linesImageView = [[UIImageView alloc] initWithImage:[linesImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30.f, 0, 0)]];
        [self addSubview:self.linesImageView];

        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        self.dayLabel.textColor = RGB(1, 81, 61);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];

        self.boyView = [[UIImageView alloc] init];
        [self addSubview:self.boyView];
        
        self.menstruationView = [[UIImageView alloc] init];
        [self addSubview:self.menstruationView];
        
        self.ovulationView = [[UIImageView alloc] init];
        [self addSubview:self.ovulationView];

        self.sexualIntercourseView = [[UIImageView alloc] init];
        [self addSubview:self.sexualIntercourseView];

        self.pregnantView = [[UIImageView alloc] init];
        [self addSubview:self.pregnantView];
        
        self.childBirthView = [[UIImageView alloc] init];
        [self addSubview:self.childBirthView];

        self.girlView = [[UIImageView alloc] init];
        [self addSubview:self.girlView];
        
        self.notesLabel = [[UILabel alloc] init];
        self.notesLabel.backgroundColor = [UIColor clearColor];
        self.notesLabel.font = [UIFont fontWithName:@"Gabriola" size:23];
        self.notesLabel.textColor = RGB(132, 219, 205);
        self.notesLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.notesLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.center = CGPointMake(floorf(self.width/2), floorf(self.height/2));
    
    self.linesImageView.frame = CGRectMake(self.backgroundImageView.left + BPCalendarFooterLinesHorizontalPadding, self.backgroundImageView.top + BPCalendarFooterLinesTopPadding, self.backgroundImageView.width - 2*BPCalendarFooterLinesHorizontalPadding, self.backgroundImageView.height - (BPCalendarFooterLinesTopPadding + BPCalendarFooterLinesBottomPadding));
    
    CGFloat left = BPCalendarFooterPadding;
    CGFloat top = BPCalendarFooterFirstLine;
    
    self.boyView.frame = CGRectMake(BPCalendarFooterPadding, top, self.boyView.image.size.width, self.boyView.image.size.height);
    left += self.boyView.width + 20.f;
    self.girlView.frame = CGRectMake(self.width - (self.girlView.image.size.width + BPCalendarFooterPadding), top, self.girlView.image.size.width, self.girlView.image.size.height);

    top = BPCalendarFooterSecondLine;
    self.menstruationView.frame = CGRectMake(left, top, self.menstruationView.image.size.width, self.menstruationView.image.size.height);
    left += self.menstruationView.width + 14.f;

    self.ovulationView.frame = CGRectMake(left, top, self.ovulationView.image.size.width, self.ovulationView.image.size.height);
    left += self.ovulationView.width + 2.f;
    
    self.sexualIntercourseView.frame = CGRectMake(left, top, self.sexualIntercourseView.image.size.width, self.sexualIntercourseView.image.size.height);
    left += self.sexualIntercourseView.width + 15.f;
    
    self.pregnantView.frame = CGRectMake(left, top, self.pregnantView.image.size.width, self.pregnantView.image.size.height);
    left += self.pregnantView.width + 13.f;
    
    self.childBirthView.frame = CGRectMake(left, top, self.childBirthView.image.size.width, self.childBirthView.image.size.height);

    left = BPCalendarFooterPadding;
    CGFloat maxWidth = self.width - 2*left;
    self.notesLabel.frame = CGRectMake(left, self.boyView.bottom, maxWidth, BPCalendarFooterNotesLabelHeight);
    
    maxWidth -= (MAX(self.boyView.width, self.girlView.width) + 2*BPCalendarFooterPadding);
    left = floorf(self.width/2 - maxWidth/2);
    self.dayLabel.frame = CGRectMake(left, BPCalendarFooterDayTop, maxWidth, BPCalendarFooterDayLabelHeight);
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dayLabel.text = nil;
    self.notesLabel.text = nil;
}

#pragma mark - Public

- (void)setDate:(BPDate *)date
{
//    if (_date != date) {
        _date = date;
        
        NSString *imageName = @"mycharts_calendar_notes_icon_boy";
        if ([_date.boy boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.boyView.image = [BPUtils imageNamed:imageName];

        imageName = @"mycharts_calendar_notes_icon_menstruation";
        if ([_date.menstruation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.menstruationView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mycharts_calendar_notes_icon_ovulation";
        if ([_date.ovulation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.ovulationView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mycharts_calendar_notes_icon_sexualintercourse";
        if ([_date.sexualIntercourse boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.sexualIntercourseView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mycharts_calendar_notes_icon_pregnant";
        if ([_date.pregnant boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.pregnantView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mycharts_calendar_notes_icon_girl";
        if ([_date.girl boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.girlView.image = [BPUtils imageNamed:imageName];

    DLog(@"_date: %@", _date);
        self.notesLabel.text = _date.notations;
    
        [self updateUI];
//    }
}

- (void)setChildBirth:(NSNumber *)childBirth
{
//    if (_childBirth != childBirth) {
        _childBirth = childBirth;
    
        NSString *imageName = @"mycharts_calendar_notes_icon_childbirth";
        if ([_childBirth boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.childBirthView.image = [BPUtils imageNamed:imageName];
//    }
}

- (void)updateUI
{
    if ([self.date.day integerValue])
        self.dayLabel.text = [NSString stringWithFormat:BPLocalizedString(@"%@ day of cycle"), [BPUtils ordinalStringFromNumber:self.date.day]];
}

@end
