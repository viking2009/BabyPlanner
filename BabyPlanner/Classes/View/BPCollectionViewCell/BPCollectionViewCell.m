//
//  BPCollectionViewCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 11.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCollectionViewCell.h"
#import "BPUtils.h"
#import "UIImage+Additions.h"

@interface BPCollectionViewCell()

@end

@implementation BPCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        self.titleLabel.highlightedTextColor = RGB(255, 255, 255);
        [self.contentView addSubview:self.titleLabel];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"cell_disclosureIndicator"]];
        self.accessoryView.highlightedImage = [self.accessoryView.image tintedImageWithColor:RGB(255, 255, 255) style:UIImageTintedStyleKeepingAlpha];
        [self.contentView addSubview:self.accessoryView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left = BPDefaultCellInset;
    CGFloat maxWidth = self.contentView.frame.size.width - (self.accessoryView.image.size.width + 3*BPDefaultCellInset);
    
    if (self.imageView.image) {
        self.imageView.frame = CGRectMake(left, floorf(self.contentView.frame.size.height/2 - self.imageView.image.size.height/2), self.imageView.image.size.width, self.imageView.image.size.height);
        left += self.imageView.frame.size.width + BPDefaultCellInset - 2.f;
        maxWidth -= self.imageView.frame.size.width + BPDefaultCellInset - 2.f;
    } else {
        self.imageView.frame = CGRectZero;
    }
    
    if (self.titleLabel.text.length) {
        self.titleLabel.frame = CGRectMake(left, 0, maxWidth, self.contentView.frame.size.height);
        left += self.titleLabel.frame.size.width + BPDefaultCellInset;
    } else {
        self.titleLabel.frame = CGRectZero;
    }
    
    self.accessoryView.frame = CGRectMake(left, floorf(self.contentView.frame.size.height/2 - self.accessoryView.image.size.height/2),
                                          self.accessoryView.image.size.width, self.accessoryView.image.size.height);
}

@end
