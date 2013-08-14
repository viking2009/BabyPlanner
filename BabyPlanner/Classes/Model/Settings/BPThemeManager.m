//
//  BPThemeManager.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPThemeManager.h"
#import "BPSettings+Additions.h"
#import "BPUtils.h"

NSString *const BPThemeDidChangeNotification = @"BPThemeDidChangeNotification";

@interface BPThemeManager()

- (UIImage *)imageNamed:(NSString *)name forTheme:(NSString *)theme;
- (UIImage *)themedImageNamed:(NSString *)name;

@end

@implementation BPThemeManager

+ (BPThemeManager *)sharedManager
{
    static BPThemeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NSString *)currentTheme
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    if (!sharedSettings[BPSettingsThemeKey])
        sharedSettings[BPSettingsThemeKey] = (self.supportedThemes)[0];
    
    return sharedSettings[BPSettingsThemeKey];
}

- (void)setCurrentTheme:(NSString *)aTheme
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsThemeKey] = aTheme;
}

- (NSArray *)supportedThemes
{
    return @[@"Classic", @"Pink", @"Blue"];
}

- (UIImage *)imageNamed:(NSString *)name forTheme:(NSString *)theme
{
    UIImage *themedImage = [BPUtils imageNamed:[theme stringByAppendingPathComponent:name]];
    if (!themedImage)
        themedImage = [BPUtils imageNamed:[@"Classic" stringByAppendingPathComponent:name]];
    
    return themedImage;
}

- (UIImage *)themedImageNamed:(NSString *)name
{
    return [self imageNamed:name forTheme:self.currentTheme];
}

- (UIImage *)backgroundImage
{
    return [self themedImageNamed:@"backgroundImage"];
}

- (UIImage *)navigationBarBackgroundImage
{
    return [self themedImageNamed:@"navigationbar_background"];
}

- (UIImage *)navigationBarBackButtonImage
{
    return [self themedImageNamed:@"navigationbar_backButton"];
}

- (UIColor *)themeColorForTheme:(NSString *)theme {
    if ([theme isEqualToString:@"Pink"])
        return RGB(244, 217, 233);
    else if ([theme isEqualToString:@"Blue"])
        return RGB(160, 220, 236);
    else
        return RGB(30, 188, 165);
}

- (UIColor *)currentThemeColor
{
    return [self themeColorForTheme:self.currentTheme];
}

- (UIImage *)iconImageForTheme:(NSString *)theme highlighted:(BOOL)highlighted
{
    NSString *imageName = [NSString stringWithFormat:@"Icon-%@", (highlighted ? @"selected" : @"normal")];
    return [self imageNamed:imageName forTheme:theme];
}

@end
