//
//  BPTextField.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPTextField.h"
#import "BPUtils.h"

//#define USE_FIXED_BOUND

@implementation BPTextField

- (void)setup
{
    self.contentVerticalAlignment = UIViewContentModeCenter;
    
    self.borderStyle = UITextBorderStyleNone;
    self.background = [[BPUtils imageNamed:@"textfield_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(BPTextFieldPadding, BPTextFieldPadding, BPTextFieldPadding, BPTextFieldPadding) resizingMode:UIImageResizingModeStretch];
    
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.textColor = RGB(76, 86, 108);
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

- (CGRect)fixedBoundsForBounds:(CGRect)bounds
{
#ifdef USE_FIXED_BOUND
    CGRect fixedBounds = CGRectInset(bounds, BPTextFieldPadding, floorf(bounds.size.height/2 - self.font.lineHeight/2));
    if (fixedBounds.size.height == 0)
        fixedBounds.origin.y += BPTextFieldPadding;
    
    return fixedBounds;
#else
    CGFloat yOffset = (bounds.size.height ? 0 : floorf(bounds.size.height/2 - self.font.lineHeight/2));
    return CGRectInset(bounds, BPTextFieldPadding, yOffset);
#endif
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self fixedBoundsForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self fixedBoundsForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self fixedBoundsForBounds:bounds];
}

//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.textColor setFill];
//    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
//}

@end
