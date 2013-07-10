//
//  BPSettingsProfileViewController.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 10.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsProfileViewController.h"
#import "BPUtils.h"
#import "BPLabel.h"
#import "BPTextField.h"
#import "BPSelectButton.h"
#import "BPValuePicker.h"

#define BPProfileControlsSpacing 5.f
#define BPProfileControlsMargin 15.f
#define BPProfileLabelWidth 90.f
#define BPProfileLabelSmallWidth 40.f
#define BPProfileTextFieldSmallWidth 100.f


@interface BPSettingsProfileViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BPLabel *nameLabel;
@property (nonatomic, strong) BPLabel *birthdayLabel;
@property (nonatomic, strong) BPLabel *weightLabel;
@property (nonatomic, strong) BPLabel *heightLabel;
@property (nonatomic, strong) BPLabel *kgLabel;
@property (nonatomic, strong) BPLabel *cmLabel;

@property (nonatomic, strong) BPTextField *nameTextField;
@property (nonatomic, strong) BPTextField *birthdayTextField;
@property (nonatomic, strong) BPTextField *weightTextField;
@property (nonatomic, strong) BPTextField *heightTextField;

@property (nonatomic, strong) BPSelectButton *lengthOfCycleButton;
@property (nonatomic, strong) BPSelectButton *lastMenstruationButton;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) BPValuePicker *pickerView;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@end

@implementation BPSettingsProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_myprofile_bubble"]];
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] init];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.selectLabel.textColor = RGB(0, 0, 0);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
    self.selectLabel.numberOfLines = 1;
    [self.view addSubview:self.selectLabel];

    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"settings_myprofile_girl"]];
    self.girlView.frame = CGRectMake(116.f, MAX(246.f, self.view.bounds.size.height - self.girlView.image.size.height - self.tabBarController.tabBar.frame.size.height), self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
    bubbleView.frame = CGRectMake(0, self.girlView.frame.origin.y + 14.f, bubbleView.image.size.width, bubbleView.image.size.height);
    self.selectLabel.frame = CGRectOffset(bubbleView.frame, 0, -10.f);

    CGFloat top = MAX(0, self.girlView.frame.origin.y - 246.f) + 64.f + 3.f + BPProfileControlsSpacing;
    CGFloat left = BPProfileControlsMargin;
    CGFloat maxWidth = self.view.frame.size.width - 2*BPProfileControlsMargin - BPProfileLabelWidth - BPProfileControlsSpacing;
    
    self.nameLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;
    
    self.birthdayLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;

    self.weightLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;

    self.heightLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.heightLabel.frame.size.height + BPProfileControlsMargin;

    left += BPProfileLabelWidth + BPProfileControlsSpacing + BPProfileTextFieldSmallWidth + BPProfileControlsSpacing;
    self.kgLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, self.weightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];
    self.cmLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, self.heightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];

    left = BPProfileControlsMargin + BPProfileLabelWidth + BPProfileControlsSpacing;

    self.nameTextField = [[BPTextField alloc] initWithFrame:CGRectMake(left, self.nameLabel.frame.origin.y, maxWidth, BPTextFieldHeigth)];
    self.nameTextField.delegate = self;
    self.birthdayTextField = [[BPTextField alloc] initWithFrame:CGRectMake(left, self.birthdayLabel.frame.origin.y, maxWidth, BPTextFieldHeigth)];
    self.birthdayTextField.delegate = self;
    self.weightTextField = [[BPTextField alloc] initWithFrame:CGRectMake(left, self.weightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];
    self.weightTextField.delegate = self;
    self.heightTextField = [[BPTextField alloc] initWithFrame:CGRectMake(left, self.heightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];
    self.heightTextField.delegate = self;

    self.lengthOfCycleButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.lengthOfCycleButton.frame = CGRectMake(BPProfileControlsSpacing, top, BPProfileSelectButtonWidth, BPSelectButtonHeigth);
    [self.lengthOfCycleButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lastMenstruationButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.lastMenstruationButton.frame = CGRectMake(self.view.frame.size.width - BPProfileControlsSpacing - BPProfileSelectButtonWidth, top, BPProfileSelectButtonWidth, BPSelectButtonHeigth);
    [self.lastMenstruationButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.birthdayLabel];
    [self.view addSubview:self.weightLabel];
    [self.view addSubview:self.heightLabel];
    [self.view addSubview:self.kgLabel];
    [self.view addSubview:self.cmLabel];
    
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.birthdayTextField];
    [self.view addSubview:self.weightTextField];
    [self.view addSubview:self.heightTextField];
    
    [self.view addSubview:self.lengthOfCycleButton];
    [self.view addSubview:self.lastMenstruationButton];
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(280.f, self.view.bounds.size.height - BPPickerViewHeight - self.tabBarController.tabBar.frame.size.height), self.view.bounds.size.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pickerView];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    self.selectLabel.text = BPLocalizedString(@"Hello!");

    self.nameLabel.text = BPLocalizedString(@"Name");
    self.birthdayLabel.text = BPLocalizedString(@"Date of birth");
    self.weightLabel.text = BPLocalizedString(@"Weight");
    self.heightLabel.text = BPLocalizedString(@"Height");
    self.kgLabel.text = BPLocalizedString(@"kg");
    self.cmLabel.text = BPLocalizedString(@"cm");
   
    [self.lengthOfCycleButton setTitle:BPLocalizedString(@"Length of my cycle") forState:UIControlStateNormal];
    [self.lastMenstruationButton setTitle:BPLocalizedString(@"Last menstruation") forState:UIControlStateNormal];
    
    // TODO: fill with data
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

- (void)pickerViewValueChanged
{
    DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, self.pickerView.value);
    
    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeTime:
            break;
        case BPValuePickerModeSound:
            break;
        default:
            break;
    }
}

- (void)selectButtonTapped:(id)sender
{
    DLog(@"%@", sender);
}

@end
