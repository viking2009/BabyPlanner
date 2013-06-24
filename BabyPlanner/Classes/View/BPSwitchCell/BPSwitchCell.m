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

@implementation BPSwitchCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        [self.contentView addSubview:self.titleLabel];
        
        self.toggleView = [[TTSwitch alloc] initWithFrame:CGRectMake(0, 0, BPDefaultSwitchWidth, BPDefaultSwitchHeight)];
        [self.toggleView addTarget:self action:@selector(didToggle) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.toggleView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(BPDefaultCellInset, 0,
                                       self.contentView.frame.size.width - BPDefaultSwitchWidth - 3*BPDefaultCellInset,
                                       self.contentView.frame.size.height);
    
    self.toggleView.frame = CGRectMake(self.contentView.frame.size.width - BPDefaultSwitchWidth - BPDefaultCellInset,
                                       floorf(self.contentView.frame.size.height/2 - BPDefaultSwitchHeight/2),
                                       BPDefaultSwitchWidth, BPDefaultSwitchHeight);
}

- (void)didToggle
{
    if ([self.delegate respondsToSelector:@selector(switchCellDidToggle:)]) {
        [self.delegate performSelector:@selector(switchCellDidToggle:) withObject:self];
    }
}

@end
