//
//  BPThemeCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPThemeCell.h"
#import "BPUtils.h"

@implementation BPThemeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
//        self.imageView.contentMode = UIViewContentModeRight;
        [self.contentView addSubview:self.imageView];

//        self.titleLabel = [[UILabel alloc] init];
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
//        self.titleLabel.textColor = RGB(0, 0, 0);
//        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.titleLabel.frame = CGRectMake(BPDefaultCellInset, 0,
//                                       self.contentView.frame.size.width - BPDefaultSwitchWidth - 3*BPDefaultCellInset,
//                                       self.contentView.frame.size.height);
    
    self.imageView.frame = self.contentView.bounds;
}

@end
