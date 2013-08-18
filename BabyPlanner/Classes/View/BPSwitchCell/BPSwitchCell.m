//
//  BPSwitchCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSwitchCell.h"
#import "BPUtils.h"

#define BPDefaultSwitchWidth 76.f
#define BPDefaultSwitchHeight 28.f
#define BPDefaultSubtitleWidth 80.f

@implementation BPSwitchCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        [self.contentView addSubview:self.titleLabel];

        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.subtitleLabel.textColor = RGB(56, 84, 135);
        self.subtitleLabel.highlightedTextColor = RGB(255, 255, 255);
        self.subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subtitleLabel];
        
//        self.toggleView = [[TTSwitch alloc] initWithFrame:CGRectMake(0, 0, BPDefaultSwitchWidth, BPDefaultSwitchHeight)];
//        self.toggleView.onLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
//        self.toggleView.onLabel.textColor = RGB(255, 255, 255);
//        self.toggleView.onLabel.shadowColor = RGBA(0, 0, 0, 0.2);
//        self.toggleView.onLabel.shadowOffset = CGSizeMake(0, -1);
//        self.toggleView.offLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
//        self.toggleView.offLabel.textColor = RGB(127, 127, 127);
//        self.toggleView.offLabel.shadowColor = RGBA(255, 255, 255, 0.75);
//        self.toggleView.offLabel.shadowOffset = CGSizeMake(0, -1);
//        self.toggleView.labelsEdgeInsets = UIEdgeInsetsMake(0, BPDefaultCellInset, 0, 2*BPDefaultCellInset);
        self.toggleView = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(0, 0, BPDefaultSwitchWidth, BPDefaultSwitchHeight)];
        [self.toggleView addTarget:self action:@selector(didToggle) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.toggleView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left = BPDefaultCellInset;
    CGFloat right = self.contentView.frame.size.width - BPDefaultCellInset - BPDefaultSwitchWidth;
    CGFloat maxWidth = self.contentView.frame.size.width - BPDefaultSwitchWidth - 3*BPDefaultCellInset;
    
    if (self.imageView.image) {
        self.imageView.frame = CGRectMake(left, floorf(self.contentView.frame.size.height/2 - self.imageView.image.size.height/2), self.imageView.image.size.width, self.imageView.image.size.height);
        left += self.imageView.frame.size.width + BPDefaultCellInset - 2.f;
        maxWidth -= self.imageView.frame.size.width + BPDefaultCellInset - 2.f;
    } else {
        self.imageView.frame = CGRectZero;
    }
    
    if (self.subtitleLabel.text.length) {
        self.subtitleLabel.frame = CGRectMake(right - BPDefaultCellInset - BPDefaultSubtitleWidth, 0, BPDefaultSubtitleWidth, self.contentView.frame.size.height);
        maxWidth -= self.subtitleLabel.frame.size.width + BPDefaultCellInset;
    } else {
        self.subtitleLabel.frame = CGRectZero;
    }
    
    if (self.titleLabel.text.length) {
        self.titleLabel.frame = CGRectMake(left, 0, maxWidth, self.contentView.frame.size.height);
        left += self.titleLabel.frame.size.width + BPDefaultCellInset;
    } else {
        self.titleLabel.frame = CGRectZero;
    }
    
    self.toggleView.frame = CGRectMake(right, floorf(self.contentView.frame.size.height/2 - BPDefaultSwitchHeight/2),
                                       BPDefaultSwitchWidth, BPDefaultSwitchHeight);
}

- (void)didToggle
{
    if ([self.delegate respondsToSelector:@selector(switchCellDidToggle:)]) {
        [self.delegate performSelector:@selector(switchCellDidToggle:) withObject:self];
    }
}

@end
