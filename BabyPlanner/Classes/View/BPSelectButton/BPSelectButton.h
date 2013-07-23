//
//  BPSelectButton.h
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BPSelectButtonHeigth 34.f
#define BPProfileSelectButtonWidth 153.f

@interface BPSelectButton : UIButton

// NOTE: set subtitleLabel.text before setTitle:forState
@property (nonatomic, readonly, strong) UILabel *subtitleLabel;

- (CGRect)subtitleRectForContentRect:(CGRect)contentRect;

@end
