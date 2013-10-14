//
//  BPBaseViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPBaseViewController.h"
#import "BPUtils.h"

#import "BPLanguageManager.h"
#import "BPSettings+Additions.h"
#import "BPThemeManager.h"

#import "UIView+Sizes.h"

@interface BPBaseViewController ()

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChanged:) name:BPLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDidChanged:) name:BPSettingsDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChanged:) name:BPThemeDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.contentMode = UIViewContentModeTop;
    self.backgroundImageView.image = self.backgroundImage;
    [self.view insertSubview:self.backgroundImageView atIndex:0];
    
    // fix iOS7 status bar appearance
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20.f)];
    self.statusBarView.backgroundColor = RGB(0, 0, 0);
    self.statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.statusBarView];
    
    [self localize];
    [self customize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    DLog();
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        self.backgroundImageView.image = backgroundImage;
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    [self localize];
}

- (void)updateUI
{
    
}

- (void)localize
{
    // localization
    self.tabBarItem.title = BPLocalizedString(self.title);
}

- (void)customize
{
    // theming
    self.backgroundImage = [BPThemeManager sharedManager].backgroundImage;
}

- (void)languageDidChanged:(NSNotification *)notification
{
    [self localize];
}

- (void)settingsDidChanged:(NSNotification *)notification
{
    [self updateUI];
}

- (void)themeDidChanged:(NSNotification *)notification
{
    [self customize];
}

@end
