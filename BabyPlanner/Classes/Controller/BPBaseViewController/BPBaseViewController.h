//
//  BPBaseViewController.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPBaseViewController : UIViewController

@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

- (void)updateUI;

- (void)languageDidChanged:(NSNotification *)notification;
- (void)settingsDidChanged:(NSNotification *)notification;
- (void)themeDidChanged:(NSNotification *)notification;

@end
