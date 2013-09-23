//
//  BPLabel.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPLabel.h"
#import "BPUtils.h"

@implementation BPLabel

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.textColor = RGB(76, 86, 108);
    self.shadowColor = RGBA(255, 255, 255, 0.75f);
    self.shadowOffset = CGSizeMake(0, 1);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self setup];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    
    return self;
}

#pragma mark - UILabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    if (self.contentMode == UIViewContentModeTop)
        textRect.size.height = MIN(bounds.size.height, textRect.size.height);
    else if (self.contentMode == UIViewContentModeBottom) {
        textRect.origin.y = MAX(0, bounds.size.height - textRect.size.height);
        textRect.size.height = MIN(bounds.size.height, textRect.size.height);
    }

    return textRect;
}

- (void)drawTextInRect:(CGRect)rect
{
    CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:CGRectIntegral(textRect)];
}



@end
