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
    
    CGFloat maxWidth = self.contentView.frame.size.width - BPDefaultCellInset;
    
    if (self.subtitleLabel.text.length) {
        CGSize subtitleSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                                  constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                      lineBreakMode:NSLineBreakByWordWrapping];
        self.subtitleLabel.frame = CGRectMake(maxWidth - ceilf(subtitleSize.width - 0.5f*BPDefaultCellInset), 1, ceilf(subtitleSize.width), self.contentView.frame.size.height);
        maxWidth -= self.subtitleLabel.frame.size.width + BPDefaultCellInset;
    } else
        self.subtitleLabel.frame = CGRectZero;
    
    if (self.titleLabel.text.length)
        self.titleLabel.frame = CGRectMake(floorf(0.5f*BPDefaultCellInset), 0, maxWidth, self.contentView.frame.size.height);
    else
        self.titleLabel.frame = CGRectZero;
}

@end
