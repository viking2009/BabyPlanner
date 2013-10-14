//
//  BPSettingsLanguageViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsLanguageViewController.h"

#import "BPUtils.h"
#import "BPValuePicker.h"

#import "BPSettings+Additions.h"
#import "BPLanguageManager.h"
#import "UIView+Sizes.h"

@interface BPSettingsLanguageViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) BPValuePicker *pickerView;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@end

@implementation BPSettingsLanguageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Language";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_language_bubble"]];
    bubbleView.frame = CGRectMake(0, 88, bubbleView.image.size.width, bubbleView.image.size.height);
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectOffset(bubbleView.frame, 0, -10.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.selectLabel.textColor = RGB(76, 86, 108);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
    self.selectLabel.shadowColor = RGB(255, 255, 255);
    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.view addSubview:self.selectLabel];
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_language_girl"]];
    self.girlView.frame = CGRectMake(85, 146, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(BPSettingsPickerMinimalOriginY, self.view.height - BPPickerViewHeight - self.tabBarController.tabBar.height), self.view.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pickerView];
    
    self.pickerView.valuePickerMode = BPValuePickerModeLanguage;
    self.pickerView.value = [BPLanguageManager sharedManager].currentLanguage;
    
    [self updateUI];
    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    [super updateUI];
}

- (void)localize
{
    [super localize];
    
    self.selectLabel.text = BPLocalizedString(@"Please, select the language!");
}

- (void)pickerViewValueChanged
{
    DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, self.pickerView.value);
    
    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeLanguage:
            [BPLanguageManager sharedManager].currentLanguage = self.pickerView.value;
            break;

        default:
            break;
    }
}

@end
