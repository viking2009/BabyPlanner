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

#define BPDateIndicatorsViewDayTop              50.f
#define BPDateIndicatorsViewFirstLine           110.f
#define BPDateIndicatorsViewFirstLinePadding    25.f
#define BPDateIndicatorsViewTemperatureTop      100.f
#define BPDateIndicatorsViewSecondLine          160.f
#define BPDateIndicatorsViewSecondLinePadding   40.f
#define BPDateIndicatorsViewPadding             20.f

@interface BPDateIndicatorsView()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *pregnantView;
@property (nonatomic, strong) UIImageView *menstruationView;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIImageView *boyView;
@property (nonatomic, strong) UIImageView *girlView;
@property (nonatomic, strong) UIImageView *sexualIntercourseView;
@property (nonatomic, strong) UIImageView *ovulationView;

- (void)refreshDay;
- (void)refreshTemperature;

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
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat centerX = floorf(bounds.size.width/2);
    CGFloat top = BPDateIndicatorsViewDayTop;
    
    self.dayLabel.frame = CGRectMake(0, top, bounds.size.width, ceilf(self.dayLabel.font.lineHeight));
    
    top = BPDateIndicatorsViewFirstLine;
    self.pregnantView.frame = CGRectMake(centerX - BPDateIndicatorsViewFirstLinePadding - self.pregnantView.image.size.width, top - self.pregnantView.image.size.height, self.pregnantView.image.size.width, self.pregnantView.image.size.height);
    self.menstruationView.frame = CGRectMake(centerX + BPDateIndicatorsViewFirstLinePadding, top - self.menstruationView.image.size.height, self.menstruationView.image.size.width, self.menstruationView.image.size.height);
    
    top = BPDateIndicatorsViewTemperatureTop;
    self.temperatureLabel.frame = CGRectMake(0, top, bounds.size.width, ceilf(self.temperatureLabel.font.lineHeight));
    
    top = BPDateIndicatorsViewSecondLine;
    self.boyView.frame = CGRectMake(centerX - BPDateIndicatorsViewSecondLinePadding - self.boyView.image.size.width, top, self.boyView.image.size.width, self.boyView.image.size.height);
    self.girlView.frame = CGRectMake(centerX + BPDateIndicatorsViewSecondLinePadding, top, self.girlView.image.size.width, self.girlView.image.size.height);

    self.sexualIntercourseView.frame = CGRectMake(centerX - floorf(self.sexualIntercourseView.image.size.width/2), top - 5.f, self.sexualIntercourseView.image.size.width, self.sexualIntercourseView.image.size.height);
    
    top += self.sexualIntercourseView.frame.size.height + BPDateIndicatorsViewPadding;
    self.ovulationView.frame = CGRectMake(centerX - floorf(self.ovulationView.image.size.width/2) + 10.f, top, self.ovulationView.image.size.width, self.ovulationView.image.size.height);
}

- (void)setDay:(NSNumber *)day
{
    if (_day != day) {
        _day = day;
        
        [self refreshDay];
    }
}

- (void)setPregnant:(NSNumber *)pregnant
{
    if (_pregnant != pregnant) {
        _pregnant = pregnant;
        
        NSString *imageName = @"mytemperature_main_icon_pregnant";
        if ([pregnant boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        
        self.pregnantView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)setMenstruation:(NSNumber *)menstruation
{
    if (_menstruation != menstruation) {
        _menstruation = menstruation;
        
        NSString *imageName = @"mytemperature_main_icon_menstruation";
        if ([menstruation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];

        self.menstruationView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)setTemperature:(NSNumber *)temperature
{
    if (_temperature != temperature) {
        _temperature = temperature;
        
        [self refreshTemperature];
    }
}

- (void)setBoy:(NSNumber *)boy
{
    if (_boy != boy) {
        _boy = boy;
        
        NSString *imageName = @"mytemperature_main_icon_boy";
        if ([boy boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        
        self.boyView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)setGirl:(NSNumber *)girl
{
    if (_girl != girl) {
        _girl = girl;
        
        NSString *imageName = @"mytemperature_main_icon_girl";
        if ([girl boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        
        self.girlView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)setSexualIntercourse:(NSNumber *)sexualIntercourse
{
    if (_sexualIntercourse != sexualIntercourse) {
        _sexualIntercourse = sexualIntercourse;
        
        NSString *imageName = @"mytemperature_main_icon_sexualintercourse";
        if ([sexualIntercourse boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        
        self.sexualIntercourseView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)setOvulation:(NSNumber *)ovulation
{
    if (_ovulation != ovulation) {
        _ovulation = ovulation;
        
        NSString *imageName = @"mytemperature_main_icon_ovulation";
        if ([ovulation boolValue])
            imageName = [imageName stringByAppendingString:@"_active"];
        
        self.ovulationView.image = [BPUtils imageNamed:imageName];
    }
}

- (void)refreshDay
{
    self.dayLabel.text = [NSString stringWithFormat:BPLocalizedString(@"Day %@"), self.day];
}

- (void)refreshTemperature
{
    DLog(@"self.temperature = %@", self.temperature);
    
    if (self.temperature) {
        NSString *temperatureSign = [BPLanguageManager sharedManager].currentMetric ? @"C" :@"F";
        float temperature = [self.temperature floatValue];
        if ([BPLanguageManager sharedManager].currentMetric == 0)
            temperature = temperature * 9/5 + 32.f;
        
        self.temperatureLabel.text = [NSString stringWithFormat:@"%.2f °%@", temperature, temperatureSign];
    } else
        self.temperatureLabel.text = nil;
}

- (void)updateUI
{
    [self refreshDay];
    [self refreshTemperature];
}

@end
