//
//  BPCalendarCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCalendarCell.h"

@interface BPCalendarCell ()

@end

@implementation BPCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO: add indicator images
        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLabel];
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.alpha = 0.5f;
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dayLabel.frame = self.contentView.bounds;
}
@end
