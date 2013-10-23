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
#import "BPLabel.h"
#import "BPDate+Additions.h"
#import "BPSymptom+Additions.h"
#import "ObjectiveSugar.h"

#define BPCalendarFooterDayTop      30.f
#define BPCalendarFooterFirstLine   24.f
#define BPCalendarFooterSecondLine  51.f
#define BPCalendarFooterPadding     4.f
#define BPCalendarFooterDayLabelHeight 20.f
#define BPCalendarFooterNotesLabelHeight 30.f
#define BPCalendarFooterNotesLabelLeftPadding 35.f
#define BPCalendarFooterNotesLabelRightPadding 5.f
#define BPCalendarFooterNotesMaxNumberOfLines 10
#define BPCalendarFooterLinesHorizontalPadding 7.f
#define BPCalendarFooterLinesTopPadding 28.f
#define BPCalendarFooterLinesBottomPadding 5.f
#define BPCalendarFooterSymptomSize 20.f
#define BPCalendarFooterSymptomPadding 1.f

@interface BPCalendarFooter ()

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

@property (nonatomic, strong) NSMutableArray *symptoms;

+ (NSParagraphStyle *)defaultParagraphStyle;

@end

@implementation BPCalendarFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImage = [BPUtils imageNamed:@"mycharts_calendar_notes_background"];
        self.backgroundView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(25.0f, 20.0f, 25.0f, 20.0f) resizingMode:UIImageResizingModeStretch]];

        UIImage *linesImage = [BPUtils imageNamed:@"mycharts_calendar_notes_lines"];
        self.linesImageView = [[UIImageView alloc] initWithImage:[linesImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30.f, 0, 0)]];
        [self.contentView addSubview:self.linesImageView];

        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        self.dayLabel.textColor = RGB(1, 81, 61);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLabel];

        self.boyView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.boyView];
        
        self.menstruationView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.menstruationView];
        
        self.ovulationView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.ovulationView];

        self.sexualIntercourseView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.sexualIntercourseView];

        self.pregnantView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.pregnantView];
        
        self.childBirthView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.childBirthView];

        self.girlView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.girlView];
        
        self.notesLabel = [[UILabel alloc] init];
        self.notesLabel.backgroundColor = [UIColor clearColor];
        self.notesLabel.font = [UIFont fontWithName:@"Gabriola" size:23];
        self.notesLabel.textColor = RGB(132, 219, 205);
        self.notesLabel.numberOfLines = BPCalendarFooterNotesMaxNumberOfLines;
//        self.notesLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.notesLabel];
        
        self.symptoms = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.linesImageView.frame = CGRectMake(BPCalendarFooterLinesHorizontalPadding, BPCalendarFooterLinesTopPadding, self.contentView.width - 2*BPCalendarFooterLinesHorizontalPadding, self.contentView.height - (BPCalendarFooterLinesTopPadding + BPCalendarFooterLinesBottomPadding));
    
    CGFloat left = BPCalendarFooterPadding;
    CGFloat top = BPCalendarFooterFirstLine;
    
    self.boyView.frame = CGRectMake(BPCalendarFooterPadding, top, self.boyView.image.size.width, self.boyView.image.size.height);
    left += self.boyView.width + 6.f;
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

    left = BPCalendarFooterPadding + BPCalendarFooterNotesLabelLeftPadding;
    CGFloat maxWidth = self.width - (left + BPCalendarFooterPadding + BPCalendarFooterNotesLabelRightPadding);
    CGRect notesRect = CGRectMake(left, self.boyView.bottom - 4.0f + BPCalendarFooterNotesLabelHeight, maxWidth, self.notesLabel.numberOfLines * BPCalendarFooterNotesLabelHeight);
    CGRect notesLabelRect = [self.notesLabel textRectForBounds:notesRect limitedToNumberOfLines:self.notesLabel.numberOfLines];
    notesRect.size.height = notesLabelRect.size.height;
    self.notesLabel.frame = notesRect;
    
    maxWidth -= (MAX(self.boyView.width, self.girlView.width) + 2*BPCalendarFooterPadding);
    left = floorf(self.width/2 - maxWidth/2);
    self.dayLabel.frame = CGRectMake(left, BPCalendarFooterDayTop, maxWidth, BPCalendarFooterDayLabelHeight);
    
    left = BPCalendarFooterNotesLabelLeftPadding - 3.f;
    top = self.notesLabel.top - BPCalendarFooterSymptomSize;
    for (UIImageView *imageView in [self.symptoms copy]) {
        left += BPCalendarFooterSymptomPadding;
        imageView.frame = CGRectMake(left, top, imageView.image.size.width, BPCalendarFooterSymptomSize);
        left += imageView.width;
        if (left > self.width - BPCalendarFooterPadding) {
            [imageView removeFromSuperview];
            [self.symptoms removeObject:imageView];
        }
    }
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
        if ([_date.ovulation boolValue] || [_date.imageName isEqualToString:@"point_ovulation"])
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

        if (_date.notations.length) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.minimumLineHeight = BPCalendarFooterNotesLabelHeight;
            paragraphStyle.maximumLineHeight = BPCalendarFooterNotesLabelHeight;
            paragraphStyle.alignment = self.notesLabel.textAlignment;
            paragraphStyle.lineBreakMode = self.notesLabel.lineBreakMode;
            self.notesLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_date.notations
                                                                                    attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

        } else
            self.notesLabel.text = nil;
    
        [self.symptoms makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.symptoms removeAllObjects];
    
        if ([date.symptoms count]) {
            NSArray *symptoms = [[date.symptoms allObjects] sortBy:@"position"];
            for (BPSymptom *symptom in symptoms) {
                NSString *imageName = [NSString stringWithFormat:@"mycharts_%@", symptom.imageName];
                UIImageView *symptomImageView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:imageName]];
                NSInteger symptomPosition = [symptom.position integerValue];
                symptomImageView.contentMode = ((symptomPosition == 5 || symptomPosition == 11) ? UIViewContentModeBottom : UIViewContentModeTop);
                [self.symptoms addObject:symptomImageView];
                [self.contentView addSubview:symptomImageView];
                [self setNeedsLayout];
            }
        }
    
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

+ (NSParagraphStyle *)defaultParagraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = BPCalendarFooterNotesLabelHeight;
    paragraphStyle.maximumLineHeight = BPCalendarFooterNotesLabelHeight;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    return paragraphStyle;
}

+ (CGFloat)heightForDate:(BPDate *)date limitedToWidth:(CGFloat)width {
    CGFloat height = 160.0f;
    
    if (date.notations.length) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Gabriola" size:23],
                                     NSParagraphStyleAttributeName: [self defaultParagraphStyle]};
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date.notations
                                                                                attributes:attributes];
        CGFloat maxWidth = width - (2 * BPCalendarFooterPadding + + BPCalendarFooterNotesLabelLeftPadding + BPCalendarFooterNotesLabelRightPadding);
        CGSize limitedSize = CGSizeMake(maxWidth, BPCalendarFooterNotesLabelHeight * BPCalendarFooterNotesMaxNumberOfLines);
        CGRect rect = [attributedText boundingRectWithSize:limitedSize
                                                   options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                                   context:nil];
        NSInteger numberOfLines = rect.size.height/BPCalendarFooterNotesLabelHeight;
        if (numberOfLines > 1)
            height += (numberOfLines - 1) * BPCalendarFooterNotesLabelHeight;
    }
    
    return height;
}

@end
