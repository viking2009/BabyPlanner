//
//  BPStatsCollectionViewHeader.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPStatsCollectionViewHeader.h"
#import "BPUtils.h"

@interface BPStatsCollectionViewHeader ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation BPStatsCollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
        self.titleLabel.textColor = RGB(0, 0, 0);
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.titleLabel.text.length)
        self.titleLabel.frame = CGRectInset(self.bounds, floorf(1.5f*BPDefaultCellInset), 0);
    else
        self.titleLabel.frame = CGRectZero;
}


@end
