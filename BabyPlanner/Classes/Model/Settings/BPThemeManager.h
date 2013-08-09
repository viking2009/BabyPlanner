//
//  BPThemeManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BPThemeDidChangeNotification;

@interface BPThemeManager : NSObject

+ (BPThemeManager *)sharedManager;

@property (nonatomic, strong) NSString* currentTheme;
@property (nonatomic, readonly) NSArray* supportedThemes;

@property (nonatomic, readonly) UIImage *backgroundImage;
@property (nonatomic, readonly) UIImage *navigationBarBackgroundImage;
@property (nonatomic, readonly) UIImage *navigationBarBackButtonImage;

@property (nonatomic, readonly) UIColor *currentThemeColor;

- (UIColor *)themeColorForTheme:(NSString *)theme;
- (UIImage *)iconImageForTheme:(NSString *)theme highlighted:(BOOL)highlighted;

@end
