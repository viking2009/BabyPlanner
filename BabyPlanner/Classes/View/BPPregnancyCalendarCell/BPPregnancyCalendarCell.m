//
//  BPPregnancyCalendarCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 5/25/14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPPregnancyCalendarCell.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"

#define BPWeekInfoLabelLeftPadding 18.f
#define BPWeekInfoLabelBottomPadding 28.f
#define BPBabyViewTop 28.f
#define BPSectionTitleHPadding 100.f
#define BPSectionTitleBottomPadding 2.f
#define BPSectionTextPadding 10.f
#define BPSectionLabelPadding 5.f

@interface BPPregnancyCalendarCell ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *weekInfoBackground;
@property (nonatomic, strong) UILabel *weekInfoLabel;
@property (nonatomic, strong) UIImageView *babyView;
@property (nonatomic, strong) UILabel *babySizeTitleLabel;
@property (nonatomic, strong) UILabel *babySizeValueLabel;
@property (nonatomic, strong) UILabel *babyWeightTitleLabel;
@property (nonatomic, strong) UILabel *babyWeightValueLabel;
@property (nonatomic, strong) UIView *sectionsBackground;
@property (nonatomic, strong) UIImageView *firstSectionBackground;
@property (nonatomic, strong) UILabel *firstSectionTitleLabel;
@property (nonatomic, strong) UILabel *firstSectionDescriptionLabel;
@property (nonatomic, strong) UIImageView *secondSectionBackground;
@property (nonatomic, strong) UILabel *secondSectionTitleLabel;
@property (nonatomic, strong) UILabel *secondSectionDescriptionLabel;

@end

@implementation BPPregnancyCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.scrollView];
        
        self.weekInfoBackground = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.weekInfoBackground];
        
        self.weekInfoLabel = [[UILabel alloc] init];
        self.weekInfoLabel.backgroundColor = [UIColor clearColor];
        self.weekInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.weekInfoLabel.textColor = RGB(255, 255, 255);
        self.weekInfoLabel.textAlignment = NSTextAlignmentCenter;
        self.weekInfoLabel.numberOfLines = 2;
        [self.weekInfoBackground addSubview:self.weekInfoLabel];
        
        self.babyView = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.babyView];
        
        self.babySizeTitleLabel = [[UILabel alloc] init];
        self.babySizeTitleLabel.backgroundColor = [UIColor clearColor];
        self.babySizeTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.babySizeTitleLabel.textColor = RGB(4, 139, 106);
        [self.scrollView addSubview:self.babySizeTitleLabel];

        self.babySizeValueLabel = [[UILabel alloc] init];
        self.babySizeValueLabel.backgroundColor = [UIColor clearColor];
        self.babySizeValueLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.babySizeValueLabel.textColor = RGB(0, 0, 0);
        [self.scrollView addSubview:self.babySizeValueLabel];

        self.babyWeightTitleLabel = [[UILabel alloc] init];
        self.babyWeightTitleLabel.backgroundColor = [UIColor clearColor];
        self.babyWeightTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.babyWeightTitleLabel.textColor = RGB(4, 139, 106);
        [self.scrollView addSubview:self.babyWeightTitleLabel];

        self.babyWeightValueLabel = [[UILabel alloc] init];
        self.babyWeightValueLabel.backgroundColor = [UIColor clearColor];
        self.babyWeightValueLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.babyWeightValueLabel.textColor = RGB(0, 0, 0);
        [self.scrollView addSubview:self.babyWeightValueLabel];

        self.sectionsBackground = [[UIView alloc] init];
        self.sectionsBackground.backgroundColor = RGBA(171, 234, 223, 0.75);
        [self.scrollView addSubview:self.sectionsBackground];
        
        UIImage *sectionBackgroundImage = [BPUtils imageNamed:@"mypregnancy_calendar_section_background"];

        self.firstSectionBackground = [[UIImageView alloc] initWithImage:sectionBackgroundImage];
        [self.scrollView addSubview:self.firstSectionBackground];
        
        self.firstSectionTitleLabel = [[UILabel alloc] init];
        self.firstSectionTitleLabel.backgroundColor = [UIColor clearColor];
        self.firstSectionTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.firstSectionTitleLabel.textColor = RGB(255, 255, 255);
        self.firstSectionTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.firstSectionBackground addSubview:self.firstSectionTitleLabel];
        
        self.firstSectionDescriptionLabel = [[UILabel alloc] init];
        self.firstSectionDescriptionLabel.backgroundColor = [UIColor clearColor];
        self.firstSectionDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.firstSectionDescriptionLabel.textColor = RGB(0, 0, 0);
        self.firstSectionDescriptionLabel.numberOfLines = 0;
        [self.scrollView addSubview:self.firstSectionDescriptionLabel];

        self.secondSectionBackground = [[UIImageView alloc] initWithImage:sectionBackgroundImage];
        [self.scrollView addSubview:self.secondSectionBackground];

        self.secondSectionTitleLabel = [[UILabel alloc] init];
        self.secondSectionTitleLabel.backgroundColor = [UIColor clearColor];
        self.secondSectionTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.secondSectionTitleLabel.textColor = RGB(255, 255, 255);
        self.secondSectionTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.secondSectionBackground addSubview:self.secondSectionTitleLabel];
        
        self.secondSectionDescriptionLabel = [[UILabel alloc] init];
        self.secondSectionDescriptionLabel.backgroundColor = [UIColor clearColor];
        self.secondSectionDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.secondSectionDescriptionLabel.textColor = RGB(0, 0, 0);
        self.secondSectionDescriptionLabel.numberOfLines = 0;
        [self.scrollView addSubview:self.secondSectionDescriptionLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.contentView.bounds;
    
    self.weekInfoBackground.frame = CGRectMake(self.scrollView.width - self.weekInfoBackground.image.size.width, 0, self.weekInfoBackground.image.size.width, self.weekInfoBackground.image.size.height);
    self.weekInfoLabel.frame = CGRectMake(BPWeekInfoLabelLeftPadding, 0, self.weekInfoBackground.width - BPWeekInfoLabelLeftPadding, self.weekInfoBackground.height - BPWeekInfoLabelBottomPadding);
    
    self.babyView.frame = CGRectMake(0, BPBabyViewTop, self.babyView.image.size.width, self.babyView.image.size.height);
    
    self.babySizeTitleLabel.origin = CGPointMake(self.babyView.right + BPSectionLabelPadding, self.babyView.center.y);
    [self.babySizeTitleLabel sizeToFit];
    
    self.babySizeValueLabel.origin = CGPointMake(self.babySizeTitleLabel.right + BPSectionLabelPadding, self.babySizeTitleLabel.top);
    [self.babySizeValueLabel sizeToFit];
    
    self.babyWeightTitleLabel.origin = CGPointMake(self.babyView.right + BPSectionLabelPadding, self.babySizeTitleLabel.bottom);
    [self.babyWeightTitleLabel sizeToFit];
    
    self.babyWeightValueLabel.origin = CGPointMake(self.babyWeightTitleLabel.right + BPSectionLabelPadding, self.babyWeightTitleLabel.top);
    [self.babyWeightValueLabel sizeToFit];
    
    CGFloat top = self.babyView.bottom;
    
    self.firstSectionBackground.frame = CGRectMake(0, top, self.scrollView.width, self.firstSectionBackground.image.size.height);
    self.firstSectionTitleLabel.frame = CGRectMake(BPSectionTitleHPadding, 0, self.firstSectionBackground.width - 2*BPSectionTitleHPadding, self.firstSectionBackground.height - BPSectionTitleBottomPadding);
    top += self.firstSectionBackground.height;
    
    self.firstSectionDescriptionLabel.frame = CGRectMake(BPSectionTextPadding, top, self.scrollView.width - 2*BPSectionTextPadding, 0);
    [self.firstSectionDescriptionLabel sizeToFit];
    top += self.firstSectionDescriptionLabel.height;
    
    self.secondSectionBackground.frame = CGRectMake(0, top, self.scrollView.width, self.secondSectionBackground.image.size.height);
    self.secondSectionTitleLabel.frame = CGRectMake(BPSectionTitleHPadding, 0, self.secondSectionBackground.width - 2*BPSectionTitleHPadding, self.secondSectionBackground.height - BPSectionTitleBottomPadding);
    top += self.secondSectionBackground.height;

    self.secondSectionDescriptionLabel.frame = CGRectMake(BPSectionTextPadding, top, self.scrollView.width - 2*BPSectionTextPadding, 0);
    [self.secondSectionDescriptionLabel sizeToFit];
    top += self.secondSectionDescriptionLabel.height + BPSectionTextPadding;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, MAX(top, self.scrollView.height));
    
    self.sectionsBackground.frame = CGRectMake(0, self.firstSectionBackground.center.y, self.scrollView.width, self.scrollView.contentSize.height - self.firstSectionBackground.center.y);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.scrollView.contentOffset = CGPointZero;
}

- (void)setWeekNumber:(NSNumber *)weekNumber {
//    if (_weekNumber != weekNumber) {
        _weekNumber = weekNumber;
        
        NSInteger weekNumberInteger = [_weekNumber integerValue];
        if (weekNumberInteger < 14) {
            self.weekInfoBackground.image = [BPUtils imageNamed:@"mypregnancy_calendar_weekinfo_green"];
            self.babyView.image = [BPUtils imageNamed:@"mypregnancy_calendar_baby1"];
        } else if (weekNumberInteger < 28) {
            self.weekInfoBackground.image = [BPUtils imageNamed:@"mypregnancy_calendar_weekinfo_yellow"];
            self.babyView.image = [BPUtils imageNamed:@"mypregnancy_calendar_baby2"];
        } else {
            self.weekInfoBackground.image = [BPUtils imageNamed:@"mypregnancy_calendar_weekinfo_red"];
            self.babyView.image = [BPUtils imageNamed:@"mypregnancy_calendar_baby3"];
        }
        
        self.weekInfoLabel.text = [NSString stringWithFormat:@"%@\n%@", BPLocalizedString(@"Week"), _weekNumber];
        
        self.babySizeTitleLabel.text = BPLocalizedString(@"Baby size:");
        
        // TODO: read from file or DB, use cm of ft
        self.babySizeValueLabel.text = @"6 mm";
        
        self.babyWeightTitleLabel.text = BPLocalizedString(@"Baby weight:");
        
        // TODO: read from file or DB, use kg of lb
        self.babyWeightValueLabel.text = @"0.2 gr";
        
        self.firstSectionTitleLabel.text = BPLocalizedString(@"Your baby");
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.hyphenationFactor = 1.0f;
        
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
        
        // TODO: read from file or DB
        NSString *firstSectionDescription = @"By week 6, your baby’s brain and nervous system are developing at a rapid pace. Optic vesicles, which later form the eyes, begin to develop this week on the sides of the head, as do the passageways that will make up the inner ear.";
        self.firstSectionDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:firstSectionDescription attributes:attributes];
        
        self.secondSectionTitleLabel.text = BPLocalizedString(@"Your body");

        // TODO: read from file or DB
        NSString *secondSectionDescription = @"Common pregnancy complaints may hit in full force this week. You may feel extreme fatigue as your body adjusts to the demands of pregnancy. And tender, aching breasts and nausea and vomiting (morning sickness) may leave you feeling less than great. Despite its name, morning sickness can occur at any hour or all day, so don't be surprised if your queasy stomach doesn't pass by noon. Nausea isn't the only thing that has you running to the toilet, though — hormonal changes and other factors, such as your kidneys working extra hard to flush wastes out of your body, cause you to urinate more frequently, too.";
        self.secondSectionDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:secondSectionDescription attributes:attributes];;

        [self setNeedsLayout];
//    }
}

@end
