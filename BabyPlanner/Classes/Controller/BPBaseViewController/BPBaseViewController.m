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
#import "BPSettings.h"

@interface BPBaseViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DLog(@"%@", [self class]);
        self.wantsFullScreenLayout = YES;
        self.backgroundImage = [UIImage imageNamed:@"Default-568h"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChanged:) name:BPLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDidChanged:) name:BPSettingsDidChangeNotification object:nil];
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
    [self.view addSubview:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        self.backgroundImageView.image = backgroundImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    [self updateUI];
}

- (void)updateUI
{
    // set nav + tabbar
    self.tabBarItem.title = BPLocalizedString(self.title);
}

- (void)languageDidChanged:(NSNotification *)notification
{
    [self updateUI];
}

- (void)settingsDidChanged:(NSNotification *)notification
{
    [self updateUI];
}


@end
