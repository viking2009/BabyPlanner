//
//  BPThemeCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPThemeCell.h"
#import "BPUtils.h"

@implementation BPThemeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.titleLabel.textColor = RGB(0, 0, 0);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect rect = self.contentView.bounds;
    
    rect.size.height -= BPThemeDefaultTitleHeight;
    self.imageView.frame = rect;
    
    rect.origin.y = rect.size.height;
    rect.size.height = BPThemeDefaultTitleHeight;
    self.titleLabel.frame = rect;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    else
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    else
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
}

@end
