//
//  BPCycleInfoCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCycleInfoCell.h"
#import "BPUtils.h"
#import "UIImage+Additions.h"
#import "UIView+Sizes.h"

#define BPCycleInfoCounterWidth 24.f
#define BPCycleInfoTitleWidth   150.f
#define BPCycleInfoSubtitleWidth 30.f

@interface BPCycleInfoCell ()

@property (nonatomic, strong) UIImageView *accessoryView;

@end

@implementation BPCycleInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
        
        self.counterLabel = [[UILabel alloc] init];
        self.counterLabel.backgroundColor = [UIColor clearColor];
        self.counterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.counterLabel.textColor = RGB(0, 0, 0);
        self.counterLabel.highlightedTextColor = RGB(255, 255, 255);
        self.counterLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.counterLabel];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        self.titleLabel.highlightedTextColor = RGB(255, 255, 255);
        [self.contentView addSubview:self.titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.subtitleLabel.textColor = RGB(56, 84, 135);
        self.subtitleLabel.highlightedTextColor = RGB(255, 255, 255);
        self.subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subtitleLabel];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"cell_disclosureIndicator"]];
        self.accessoryView.highlightedImage = [self.accessoryView.image tintedImageWithColor:RGB(255, 255, 255) style:UIImageTintedStyleKeepingAlpha];
        [self.contentView addSubview:self.accessoryView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left = BPDefaultCellInset;
    
    if (self.counterLabel.text.length) {
        self.counterLabel.frame = CGRectMake(left, 0, BPCycleInfoCounterWidth, self.contentView.height);
        left += self.counterLabel.width + floorf(BPDefaultCellInset/2);
    } else
        self.counterLabel.frame = CGRectZero;
    
    if (self.titleLabel.text.length)
        self.titleLabel.frame = CGRectMake(left, 0, BPCycleInfoTitleWidth, self.contentView.height);
    else
        self.titleLabel.frame = CGRectZero;

    self.accessoryView.frame = CGRectMake(self.contentView.width - self.accessoryView.image.size.width - BPDefaultCellInset,
                                          floorf(self.contentView.height/2 - self.accessoryView.image.size.height/2),
                                          self.accessoryView.image.size.width, self.accessoryView.image.size.height);
    
    if (self.subtitleLabel.text.length)
        self.subtitleLabel.frame = CGRectMake(self.accessoryView.left - BPDefaultCellInset - BPCycleInfoSubtitleWidth, 0, BPCycleInfoSubtitleWidth, self.contentView.height);
    else
        self.subtitleLabel.frame = CGRectZero;
    
    left = floorf(2.5f*BPDefaultCellInset + BPCycleInfoCounterWidth + BPCycleInfoTitleWidth);
    CGFloat imageWidth = self.accessoryView.left - (left + 2*BPDefaultCellInset + BPCycleInfoSubtitleWidth);
    
    if (self.imageView.image)
        self.imageView.frame = CGRectMake(left, 0, imageWidth, self.contentView.height);
    else
        self.imageView.frame = CGRectZero;
}

@end
