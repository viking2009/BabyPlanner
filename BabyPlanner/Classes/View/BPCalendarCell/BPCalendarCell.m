//
//  BPCalendarCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarCell.h"
#import "UIView+Sizes.h"
#import "BPUtils.h"
#import "BPDate+Additions.h"
#import "BPSettings+Additions.h"
#import "NSDate-Utilities.h"
#import "BPCyclesManager.h"
#import "BPCycle+Additions.h"

#define BPCalendarCellPadding 1.f

@interface BPCalendarCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *topRightImageView;
@property (nonatomic, strong) UIImageView *bottomLeftImageView;
//@property (nonatomic, assign) NSUInteger position;

@end

@implementation BPCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = NO;
        
        self.topRightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.topRightImageView];

        self.bottomLeftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bottomLeftImageView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
//        self.backgroundView = [[UIView alloc] init];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    if (self.topRightImageView.image)
        self.topRightImageView.frame = CGRectMake(self.contentView.right - (BPCalendarCellPadding + self.topRightImageView.image.size.width), BPCalendarCellPadding, self.topRightImageView.image.size.width, self.topRightImageView.image.size.height);
    else
        self.topRightImageView.frame = CGRectZero;
    
    if (self.bottomLeftImageView.image)
        self.bottomLeftImageView.frame = CGRectMake([self.date.pregnant boolValue] ? - 1.f : BPCalendarCellPadding, self.contentView.bottom - (([self.date.pregnant boolValue] ? 0 : BPCalendarCellPadding) + self.bottomLeftImageView.image.size.height), self.bottomLeftImageView.image.size.width, self.bottomLeftImageView.image.size.height);
    else
        self.bottomLeftImageView.frame = CGRectZero;

    self.titleLabel.frame = self.contentView.bounds;
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
    self.topRightImageView.image = nil;
    self.bottomLeftImageView.image = nil;
}

//#pragma mark - UICollectionViewCell
//
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    
//    if (selected) {
//        self.position = [self.superview.subviews indexOfObject:self];
//        [self.superview bringSubviewToFront:self];
//    }
//    else
//        [self.superview insertSubview:self atIndex:self.position];
//}
//
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//    
//    if (highlighted) {
//        self.position = [self.superview.subviews indexOfObject:self];
//        [self.superview bringSubviewToFront:self];
//    }
//    else
//        [self.superview insertSubview:self atIndex:self.position];
//}

#pragma mark - Public

- (void)setDate:(BPDate *)date
{
//    if (_date != date) {
        _date = date;
    
        if ([_date.menstruation boolValue])
            self.topRightImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_menstruation"];
    
        BPSettings *sharedSettings = [BPSettings sharedSettings];
    
        NSDate *lastOvulationDate = sharedSettings[BPSettingsProfileLastOvulationDateKey];
        if (!lastOvulationDate) {
            BPCycle *current = [BPCyclesManager sharedManager].currentCycle;
            NSInteger ovulationIndex = current.ovulationIndex;
            if (ovulationIndex != NSNotFound)
                lastOvulationDate = [current.startDate dateByAddingDays:ovulationIndex];
        }
    
        if ([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue] && lastOvulationDate) {
            NSDate *childBirthday = sharedSettings[BPSettingsProfileChildBirthdayKey] ? : [lastOvulationDate dateByAddingDays:BPPregnancyPeriod];

            if (/*_date.date.weekday == lastOvulationDate.weekday &&*/ [_date.date isLaterThanDate:lastOvulationDate] && [_date.date isEarlierThanDate:childBirthday])
                        self.bottomLeftImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_pregnant"];
        } else {
            if ([_date.pregnant boolValue])
                self.bottomLeftImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_pregnant"];
        }
    
        if ([_date.sexualIntercourse boolValue]) {
            if ([_date.pregnant boolValue])
                self.topRightImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"];
            else
                self.bottomLeftImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"];
        }
        
        if ([_date.ovulation boolValue] || [_date.imageName isEqualToString:@"point_ovulation"])
            self.topRightImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_ovulation"];

        self.titleLabel.text = [NSString stringWithFormat:@"%i", _date.date.day];
    
        [self setNeedsLayout];
//    }
}

- (void)setChildBirth:(NSNumber *)childBirth
{
//    if (_childBirth != childBirth) {
        _childBirth = childBirth;
    
        if ([_childBirth boolValue])
            self.bottomLeftImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_childbirth"];
        
        [self setNeedsLayout];
//    }
}

- (void)setEnabled:(BOOL)enabled
{
//    if (_enabled != enabled) {
        _enabled = enabled;
        
//        self.titleLabel.textColor = (enabled ? RGB(255, 255, 255) : RGB(42, 192, 169));

//        self.backgroundColor =
//        self.enabled ? UIColor.whiteColor : [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
//    }
}

@end
