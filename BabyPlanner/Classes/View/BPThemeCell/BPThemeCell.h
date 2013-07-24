//
//  BPThemeCell.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BPThemeDefaultImageWidth 106.f
#define BPThemeDefaultImageHeight 112.f
#define BPThemeDefaultTitleHeight 28.f

@interface BPThemeCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
