//
//  BPControlTipsView.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 25.04.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPControlTipsView.h"
#import "BPLanguageManager.h"
#import "UIView+Sizes.h"

#define BPControlTipsViewLabelMargin 10.f
#define BPControlTipsViewLabelSpacing 1.f
#define BPControlTipsViewLabelLeftPadding 190.f
#define BPControlTipsViewLabelHeight 22.f

@interface BPControlTipsView ()

@property (nonatomic, strong) UILabel *menstruationLabel;
@property (nonatomic, strong) UILabel *infertileLabel;
@property (nonatomic, strong) UILabel *fertileLabel;
@property (nonatomic, strong) UILabel *ovulationLabel;
@property (nonatomic, strong) UILabel *notDefinedLabel;

@end

@implementation BPControlTipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.menstruationLabel = [[UILabel alloc] init];
        self.menstruationLabel.backgroundColor = [UIColor clearColor];
        self.menstruationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.menstruationLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.menstruationLabel];

        self.infertileLabel = [[UILabel alloc] init];
        self.infertileLabel.backgroundColor = [UIColor clearColor];
        self.infertileLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.infertileLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.infertileLabel];

        self.fertileLabel = [[UILabel alloc] init];
        self.fertileLabel.backgroundColor = [UIColor clearColor];
        self.fertileLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.fertileLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.fertileLabel];

        self.ovulationLabel = [[UILabel alloc] init];
        self.ovulationLabel.backgroundColor = [UIColor clearColor];
        self.ovulationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.ovulationLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.ovulationLabel];

        self.notDefinedLabel = [[UILabel alloc] init];
        self.notDefinedLabel.backgroundColor = [UIColor clearColor];
        self.notDefinedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.notDefinedLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.notDefinedLabel];
        
        [self updateUI];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat left = BPControlTipsViewLabelLeftPadding;
    CGFloat top = 0;
    CGFloat maxWidth = self.width - left - BPControlTipsViewLabelMargin;
    
    self.menstruationLabel.frame = CGRectMake(left, top, maxWidth, BPControlTipsViewLabelHeight);
    top += self.menstruationLabel.height + BPControlTipsViewLabelSpacing;
    
    self.infertileLabel.frame = CGRectMake(left, top, maxWidth, BPControlTipsViewLabelHeight);
    top += self.infertileLabel.height + BPControlTipsViewLabelSpacing;

    self.fertileLabel.frame = CGRectMake(left, top, maxWidth, BPControlTipsViewLabelHeight);
    top += self.fertileLabel.height + BPControlTipsViewLabelSpacing;

    self.ovulationLabel.frame = CGRectMake(left, top, maxWidth, BPControlTipsViewLabelHeight);
    top += self.ovulationLabel.height + BPControlTipsViewLabelSpacing;

    self.notDefinedLabel.frame = CGRectMake(left, top, maxWidth, BPControlTipsViewLabelHeight);
    top += self.notDefinedLabel.height;
}

- (void)updateUI
{
    self.menstruationLabel.text = BPLocalizedString(@"Menstruation day");
    self.infertileLabel.text = BPLocalizedString(@"Infertile day");
    self.fertileLabel.text = BPLocalizedString(@"Fertile day");
    self.ovulationLabel.text = BPLocalizedString(@"Ovulation day");
    self.notDefinedLabel.text = BPLocalizedString(@"Not defined day");
}

@end
