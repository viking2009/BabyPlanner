//
//  BPSelectButton.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSelectButton.h"
#import "BPUtils.h"

#define BPSelectButtonImageOffset 8.f

@implementation BPSelectButton

- (void)setup
{
    UIImage *backgroundImage = [[BPUtils imageNamed:@"selectbutton_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [self setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    [self setImage:[BPUtils imageNamed:@"selectbutton_arrow"] forState:UIControlStateNormal];
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

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect.size.height -= BPSelectButtonImageOffset - 4.f;
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.y = contentRect.size.height - BPSelectButtonImageOffset;
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    contentRect.origin.x = floorf(contentRect.size.width/2 - image.size.width/2);
    contentRect.size = image.size;
    
    return contentRect;
}

@end
