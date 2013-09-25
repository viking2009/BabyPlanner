//
//  BPDateIndicatorsView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDateIndicatorsView.h"
#import "BPLanguageManager.h"
#import "BPUtils.h"
#import "BPDate+Additions.h"
#import "UIView+Sizes.h"

#define BPDateIndicatorsViewDayTop              50.f
#define BPDateIndicatorsViewFirstLine           110.f
#define BPDateIndicatorsViewFirstLinePadding    25.f
#define BPDateIndicatorsViewTemperatureTop      100.f
#define BPDateIndicatorsViewSecondLine          160.f
#define BPDateIndicatorsViewSecondLinePadding   40.f
#define BPDateIndicatorsViewPadding             20.f

@interface BPDateIndicatorsView ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *pregnantView;
@property (nonatomic, strong) UIImageView *menstruationView;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIImageView *boyView;
@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UIImageView *sexualIntercourseView;
@property (nonatomic, strong) UIImageView *ovulationView;

@end

@implementation BPDateIndicatorsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.dayLabel.textColor = RGB(255, 255, 255);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];

        self.pregnantView = [[UIImageView alloc] init];
        [self addSubview:self.pregnantView];
        
        self.menstruationView = [[UIImageView alloc] init];
        [self addSubview:self.menstruationView];
        
        self.temperatureLabel = [[UILabel alloc] init];
        self.temperatureLabel.backgroundColor = [UIColor clearColor];
        self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:50];
        self.temperatureLabel.textColor = RGB(255, 255, 255);
        self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.temperatureLabel];

        self.boyView = [[UIImageView alloc] init];
        [self addSubview:self.boyView];
        
        self.girlView = [[UIImageView alloc] init];
        [self addSubview:self.girlView];

        self.sexualIntercourseView = [[UIImageView alloc] init];
        [self addSubview:self.sexualIntercourseView];
        
        self.ovulationView = [[UIImageView alloc] init];
        [self addSubview:self.ovulationView];
        
//        self.pregnant = @NO;
//        self.menstruation = @NO;
//        self.boy = @NO;
//        self.girl = @NO;
//        self.sexualIntercourse = @NO;
//        self.ovulation = @NO;
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = floorf(self.width/2);
    CGFloat top = BPDateIndicatorsViewDayTop;
    
    self.dayLabel.frame = CGRectMake(0, top, self.width, ceilf(self.dayLabel.font.lineHeight));
    
    top = BPDateIndicatorsViewFirstLine;
    self.pregnantView.frame = CGRectMake(centerX - BPDateIndicatorsViewFirstLinePadding - self.pregnantView.image.size.width, top - self.pregnantView.image.size.height, self.pregnantView.image.size.width, self.pregnantView.image.size.height);
    self.menstruationView.frame = CGRectMake(centerX + BPDateIndicatorsViewFirstLinePadding, top - self.menstruationView.image.size.height, self.menstruationView.image.size.width, self.menstruationView.image.size.height);
    
    top = BPDateIndicatorsViewTemperatureTop;
    self.temperatureLabel.frame = CGRectMake(0, top, self.width, ceilf(self.temperatureLabel.font.lineHeight));
    
    top = BPDateIndicatorsViewSecondLine;
    self.girlView.frame = CGRectMake(centerX - BPDateIndicatorsViewSecondLinePadding - self.boyView.image.size.width, top, self.boyView.image.size.width, self.boyView.image.size.height);
    self.boyView.frame = CGRectMake(centerX + BPDateIndicatorsViewSecondLinePadding, top, self.girlView.image.size.width, self.girlView.image.size.height);

    self.sexualIntercourseView.frame = CGRectMake(centerX - floorf(self.sexualIntercourseView.image.size.width/2), top - 5.f, self.sexualIntercourseView.image.size.width, self.sexualIntercourseView.image.size.height);
    
    top += self.sexualIntercourseView.height + BPDateIndicatorsViewPadding;
    self.ovulationView.frame = CGRectMake(centerX - floorf(self.ovulationView.image.size.width/2) + 10.f, top, self.ovulationView.image.size.width, self.ovulationView.image.size.height);
}

- (void)setDate:(BPDate *)date
{
//    if (_date != date) {
        _date = date;
        
        NSString *imageName = @"mytemperature_main_icon_pregnant";
        if ([_date.pregnant boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.pregnantView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mytemperature_main_icon_menstruation";
        if ([_date.menstruation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.menstruationView.image = [BPUtils imageNamed:imageName];
        
        imageName = @"mytemperature_main_icon_boy";
        if ([_date.boy boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.boyView.image = [BPUtils imageNamed:imageName];

        imageName = @"mytemperature_main_icon_girl";
        if ([_date.girl boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.girlView.image = [BPUtils imageNamed:imageName];

        imageName = @"mytemperature_main_icon_sexualintercourse";
        if ([_date.sexualIntercourse boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.sexualIntercourseView.image = [BPUtils imageNamed:imageName];

        imageName = @"mytemperature_main_icon_ovulation";
        if ([_date.ovulation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        self.ovulationView.image = [BPUtils imageNamed:imageName];

        [self updateUI];
//    }
}

- (void)updateUI
{
    self.dayLabel.text = [NSString stringWithFormat:BPLocalizedString(@"Day %@"), self.date.day];
    self.temperatureLabel.text = [BPUtils temperatureFromNumber:self.date.temperature];
}

@end
