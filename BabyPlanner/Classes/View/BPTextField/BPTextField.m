//
//  BPTextField.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPTextField.h"

#define BPTextFieldPadding 8.f
//#define USE_FIXED_BOUND

@implementation BPTextField

- (void)setup {
    // TODO: theming
    
    self.borderStyle = UITextBorderStyleNone;
    
    self.font = [UIFont fontWithName:@"ArialMT" size:13];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
        [self setup];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    
    return self;
}

- (CGRect)fixedBoundsForBounds:(CGRect)bounds {
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

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self fixedBoundsForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self fixedBoundsForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self fixedBoundsForBounds:bounds];
}

//- (void)drawPlaceholderInRect:(CGRect)rect {
//    [self.textColor setFill];
//    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
//}


@end
