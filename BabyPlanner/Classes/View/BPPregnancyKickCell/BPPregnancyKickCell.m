//
//  BPPregnancyKickCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 6/1/14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPPregnancyKickCell.h"
#import "UIView+Sizes.h"

#define BPPregnancyKickCellCountOffset 180.f
#define BPPregnancyKickCellCountBottomPadding 2.f

@implementation BPPregnancyKickCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countBackgroundView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.countBackgroundView];

        self.countLabel = [[UILabel alloc] init];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.textColor = RGB(255, 255, 255);
        self.countLabel.highlightedTextColor = RGB(255, 255, 255);
        [self.countBackgroundView addSubview:self.countLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.countBackgroundView.frame = CGRectMake(BPPregnancyKickCellCountOffset,
                                                floorf(self.contentView.height/2 - self.countBackgroundView.image.size.height/2),
                                                self.countBackgroundView.image.size.width, self.countBackgroundView.image.size.height);
    self.countLabel.frame = CGRectMake(0, 0, self.countBackgroundView.width, self.countBackgroundView.height - BPPregnancyKickCellCountBottomPadding);
}

@end
