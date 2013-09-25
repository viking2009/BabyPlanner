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

#define BPCalendarCellPadding 1.f

@interface BPCalendarCell ()

@property (nonatomic, strong) UIImageView *topRightImageView;
@property (nonatomic, strong) UIImageView *bottomLeftImageView;

@end

@implementation BPCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = RGB(255, 255, 255).CGColor;
        
        self.topRightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.topRightImageView];

        self.bottomLeftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bottomLeftImageView];

        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLabel];
        
        self.backgroundView = [[UIView alloc] init];
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
        self.bottomLeftImageView.frame = CGRectMake([self.pregnant boolValue] ? - 1.f : BPCalendarCellPadding, self.contentView.bottom - (([self.pregnant boolValue] ? 0 : BPCalendarCellPadding) + self.bottomLeftImageView.image.size.height), self.bottomLeftImageView.image.size.width, self.bottomLeftImageView.image.size.height);
    else
        self.bottomLeftImageView.frame = CGRectZero;

    self.dayLabel.frame = self.contentView.bounds;
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dayLabel.text = nil;
    self.topRightImageView.image = nil;
    self.bottomLeftImageView.image = nil;
}

#pragma mark - Public

- (void)setPregnant:(NSNumber *)pregnant
{
//    if (_pregnant != pregnant) {
        _pregnant = pregnant;
        
        self.bottomLeftImageView.image = [_pregnant boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_pregnant"] : nil;
        
        if ([self.sexualIntercourse boolValue])
            self.topRightImageView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"];
        
        [self setNeedsLayout];
//    }
}

- (void)setMenstruation:(NSNumber *)menstruation
{
//    if (_menstruation != menstruation) {
        _menstruation = menstruation;
        
        self.topRightImageView.image = [_menstruation boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_menstruation"] : nil;
    
        [self setNeedsLayout];
//    }
}

- (void)setSexualIntercourse:(NSNumber *)sexualIntercourse
{
//    if (_sexualIntercourse != sexualIntercourse) {
        _sexualIntercourse = sexualIntercourse;
        
        if ([self.pregnant boolValue])
            self.topRightImageView.image = [_sexualIntercourse boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"] : nil;
        else
            self.bottomLeftImageView.image = [_sexualIntercourse boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"] : nil;
        
        [self setNeedsLayout];
//    }
}

- (void)setOvulation:(NSNumber *)ovulation
{
//    if (_ovulation != ovulation) {
        _ovulation = ovulation;
        
        self.topRightImageView.image = [_ovulation boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_ovulation"] : nil;
    
        [self setNeedsLayout];
//    }
}

- (void)setChildBirth:(NSNumber *)childBirth
{
//    if (_childBirth != childBirth) {
        _childBirth = childBirth;
        
        self.bottomLeftImageView.image = [_childBirth boolValue] ? [BPUtils imageNamed:@"mycharts_calendar_icon_childbirth"] : nil;
        
        [self setNeedsLayout];
//    }
}

@end
