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
#define BPSelectButtonContentInset 8.f

@interface BPSelectButton ()

@property (nonatomic, readonly, strong) UIImageView *arrowView;

@end

@implementation BPSelectButton

@synthesize subtitleLabel = _subtitleLabel;
@synthesize arrowView = _arrowView;

- (void)setup
{
    UIImage *backgroundImage = [[BPUtils imageNamed:@"selectbutton_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [self setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    self.subtitleLabel.textColor = RGB(255, 255, 255);
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
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

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, BPSelectButtonContentInset, 0);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect.size.height -= BPSelectButtonImageOffset - 4.f;
    return contentRect;
}

- (CGRect)arrowImageRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.y = contentRect.size.height - BPSelectButtonImageOffset;
    
    UIImage *image = self.arrowView.image;
    contentRect.origin.x = BPSelectButtonContentInset + floorf(contentRect.size.width/2 - image.size.width/2);
    contentRect.size = image.size;
    
    return contentRect;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_subtitleLabel];
    }
    
    return _subtitleLabel;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    self.subtitleLabel.hidden = ![title length];

    if (![title length])
        title = self.subtitleLabel.text;
    
    [super setTitle:title forState:state];
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"selectbutton_arrow"]];
        [self addSubview:_arrowView];
    }
    
    return _arrowView;
}

- (CGRect)subtitleRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.y = contentRect.size.height - BPSelectButtonImageOffset;// - 1.f;
    contentRect.size.height = BPSelectButtonImageOffset;

    return contentRect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    self.subtitleLabel.frame = [self subtitleRectForContentRect:contentRect];
    self.arrowView.frame = [self arrowImageRectForContentRect:contentRect];
}

@end
