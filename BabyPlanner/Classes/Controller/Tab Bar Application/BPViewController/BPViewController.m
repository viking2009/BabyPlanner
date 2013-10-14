//
//  BPViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPViewController.h"
#import "BPUtils.h"
#import "BPThemeManager.h"
#import "UIView+Sizes.h"

@interface BPViewController ()

@property (nonatomic, strong) UIImageView *navigationImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

- (void)goBack;

@end

@implementation BPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20.f, self.view.width, 47.f)];
    [self.view addSubview:self.navigationImageView];
    
    if (!self.navigationItem.hidesBackButton) {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8.f, 0, 0);
        self.backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        self.backButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self.backButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [self.backButton setTitleShadowColor:RGBA(0, 0, 0, 0.5) forState:UIControlStateNormal];
        self.backButton.frame = CGRectMake(8.f, self.navigationImageView.top + 7.f, 52.f, 32.f);
        [self.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//        self.backButton.adjustsImageWhenHighlighted = YES;
        [self.view addSubview:self.backButton];
    }
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68.f, 20.f, self.view.width - 2*68.f, 44.f)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:19];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGB(255, 255, 255);
    self.titleLabel.shadowColor = RGBA(0, 0, 0, 0.29);
    self.titleLabel.shadowOffset = CGSizeMake(-1, -1);
    [self.view addSubview:self.titleLabel];
    
    [self updateUI];
    [self localize];
    [self customize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BPBaseViewController

- (void)updateUI
{
    [super updateUI];
}

- (void)localize
{
    [super localize];
    
    // localization
    [self.backButton setTitle:BPLocalizedString(@"Back") forState:UIControlStateNormal];
    self.titleLabel.text = BPLocalizedString(self.title);
}

- (void)customize
{
    [super customize];
    
    // theming
    self.navigationImageView.image = [[BPThemeManager sharedManager] navigationBarBackgroundImage];
    [self.backButton setBackgroundImage:[[BPThemeManager sharedManager] navigationBarBackButtonImage] forState:UIControlStateNormal];
}

@end
