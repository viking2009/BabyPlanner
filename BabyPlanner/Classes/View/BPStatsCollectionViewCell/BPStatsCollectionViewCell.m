//
//  BPStatsCollectionViewCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPStatsCollectionViewCell.h"
#import "BPUtils.h"

@implementation BPStatsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[BPLabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        self.subtitleLabel = [[BPLabel alloc] init];
        self.subtitleLabel.numberOfLines = 0;
        self.subtitleLabel.contentMode = UIViewContentModeBottom;
        self.subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxWidth = self.contentView.frame.size.width;
    
    if (self.subtitleLabel.text.length) {
        self.subtitleLabel.frame = CGRectMake(maxWidth - BPStatsCellSubtitleWidth, BPStatsCellInset, BPStatsCellSubtitleWidth, self.contentView.frame.size.height - 2*BPStatsCellInset);
        maxWidth -= self.subtitleLabel.frame.size.width + BPDefaultCellInset;
    } else
        self.subtitleLabel.frame = CGRectZero;
    
    if (self.titleLabel.text.length)
        self.titleLabel.frame = CGRectMake(0, 0, maxWidth, self.contentView.frame.size.height);
    else
        self.titleLabel.frame = CGRectZero;
}

@end
