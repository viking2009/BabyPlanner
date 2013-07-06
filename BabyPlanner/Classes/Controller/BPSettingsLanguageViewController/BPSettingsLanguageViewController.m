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

@interface BPSettingsLanguageViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) BPValuePicker *pickerView;
@property (nonatomic, strong) UILabel *selectLabel;

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
    self.selectLabel.text = BPLocalizedString(@"Please, select the language!");
    [self.view addSubview:self.selectLabel];
    
    UIImageView *girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_language_girl"]];
    girlView.frame = CGRectMake(85, 146, girlView.image.size.width, girlView.image.size.height);
    [self.view addSubview:girlView];
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(280.f, self.view.bounds.size.height - BPPickerViewHeight - self.tabBarController.tabBar.frame.size.height), self.view.bounds.size.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pickerView];
    
    self.pickerView.valuePickerMode = BPValuePickerModeLanguage;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults objectForKey:@"Language"];
    if (!language) {
        language = @"English";
        [defaults setObject:language forKey:@"Language"];
        [defaults synchronize];
    }
    
    self.pickerView.value = language;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    // TODO: post notification about changing
}

- (void)pickerViewValueChanged
{
    DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, self.pickerView.value);
    
    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeLanguage:
            [[NSUserDefaults standardUserDefaults] setObject:self.pickerView.value forKey:@"Language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self updateUI];
            break;

        default:
            break;
    }
}

@end
