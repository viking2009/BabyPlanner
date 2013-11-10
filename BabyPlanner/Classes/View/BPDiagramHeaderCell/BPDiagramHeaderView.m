//
//  BPDiagramHeaderView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 10.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramHeaderView.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"

#define BPDiagramHeaderViewTitleHeight 30.0f

@interface BPDiagramHeaderView ()

@property (nonatomic, strong, readwrite) UIImageView *backgroundImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation BPDiagramHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [BPUtils imageNamed:@"mycharts_diagram_header_background"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:self.backgroundImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = RGB(255, 255, 255);
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = CGRectInset(self.bounds, -10.0f, 0.0f);
    self.titleLabel.frame = CGRectMake(0, 0, self.width, BPDiagramHeaderViewTitleHeight);
}

@end
