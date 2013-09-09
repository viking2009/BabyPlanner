//
//  BPCollectionViewHeader.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 09.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCollectionViewHeader.h"
#import "BPUtils.h"

@interface BPCollectionViewHeader ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation BPCollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.titleLabel.text.length) {
        self.titleLabel.frame = CGRectInset(self.bounds, 2*BPDefaultCellInset, 0);
    } else {
        self.titleLabel.frame = CGRectZero;
    }
}

@end
