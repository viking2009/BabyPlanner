//
//  BPSegmentCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 26.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSegmentCell.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"

#define BPDefaultSegmentWidth 152.f
#define BPDefaultSegmentHeight 28.f

@implementation BPSegmentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(BPDefaultCellInset, 0,
                                       self.contentView.width - BPDefaultSegmentWidth - 3*BPDefaultCellInset,
                                       self.contentView.height);
    
    self.segmentView.frame = CGRectMake(self.contentView.width - self.segmentView.width - BPDefaultCellInset,
                                       floorf(self.contentView.height/2 - BPDefaultSegmentHeight/2) - 2.f,
                                       self.segmentView.width, self.segmentView.height);
}

- (void)setSegmentView:(SVSegmentedControl *)segmentView
{
    if (_segmentView != segmentView) {
        [_segmentView removeFromSuperview];
        
        _segmentView = segmentView;
        _segmentView.backgroundImage = [[BPUtils imageNamed:@"segmented_control_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.crossFadeLabelsOnDrag = YES;
        _segmentView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        _segmentView.textColor = RGB(127, 127, 127);
        _segmentView.textShadowColor = RGBA(255, 255, 255, 0.75);
        _segmentView.textShadowOffset = CGSizeMake(0, 1);
        _segmentView.thumbEdgeInset = UIEdgeInsetsZero;
        _segmentView.thumb.backgroundImage = [[BPUtils imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.thumb.highlightedBackgroundImage = [[BPUtils imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.thumb.textShadowColor = RGBA(255, 255, 255, 0.75);
        _segmentView.thumb.textShadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_segmentView];
        [self setNeedsLayout];
    }
}


@end
