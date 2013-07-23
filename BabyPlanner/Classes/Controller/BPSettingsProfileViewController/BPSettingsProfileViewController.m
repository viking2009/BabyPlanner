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

#import "BPSettings.h"
#import "NSDate-Utilities.h"

#define BPProfileControlsSpacing 5.f
#define BPProfileControlsMargin 15.f
#define BPProfileLabelWidth 90.f
#define BPProfileLabelSmallWidth 40.f
#define BPProfileTextFieldSmallWidth 100.f

#define BPPregnancyPeriod 280

@interface BPSettingsProfileViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BPLabel *nameLabel;
@property (nonatomic, strong) BPLabel *birthdayLabel;
@property (nonatomic, strong) BPLabel *weightLabel;
@property (nonatomic, strong) BPLabel *heightLabel;
@property (nonatomic, strong) BPLabel *kgLabel;
@property (nonatomic, strong) BPLabel *cmLabel;
@property (nonatomic, strong) BPLabel *pregnancyLabel;

@property (nonatomic, strong) BPTextField *nameTextField;
@property (nonatomic, strong) BPTextField *birthdayTextField;
@property (nonatomic, strong) BPTextField *weightTextField;
@property (nonatomic, strong) BPTextField *heightTextField;

@property (nonatomic, strong) UIButton *pregnancyButton;

@property (nonatomic, strong) BPSelectButton *lengthOfCycleButton;
@property (nonatomic, strong) BPSelectButton *lastMenstruationButton;

@property (nonatomic, strong) BPSelectButton *lastOvulationButton;
@property (nonatomic, strong) BPSelectButton *childBirthButton;

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
    self.girlView.frame = CGRectMake(self.view.bounds.size.width - self.girlView.image.size.width, MAX(260.f, self.view.bounds.size.height - self.girlView.image.size.height), self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
    bubbleView.frame = CGRectMake(25.f, self.girlView.frame.origin.y + 24.f, bubbleView.image.size.width, bubbleView.image.size.height);
    self.selectLabel.frame = CGRectOffset(bubbleView.frame, 0, -10.f);

    CGFloat top = MAX(0, self.girlView.frame.origin.y - 320.f) + 64.f + 3.f + BPProfileControlsSpacing;
    CGFloat left = BPProfileControlsMargin;
    CGFloat maxWidth = self.view.frame.size.width - 2*BPProfileControlsMargin - BPProfileLabelWidth - BPProfileControlsSpacing;
    
    self.nameLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;
    
    self.birthdayLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;

    self.weightLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.nameLabel.frame.size.height + BPProfileControlsSpacing;

    self.heightLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, top, BPProfileLabelWidth, BPTextFieldHeigth)];
    top += self.heightLabel.frame.size.height + BPProfileControlsSpacing;

    left += BPProfileLabelWidth + BPProfileControlsSpacing + BPProfileTextFieldSmallWidth + BPProfileControlsSpacing;
    self.kgLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, self.weightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];
    self.cmLabel = [[BPLabel alloc] initWithFrame:CGRectMake(left, self.heightLabel.frame.origin.y, BPProfileTextFieldSmallWidth, BPTextFieldHeigth)];

    left = BPProfileControlsMargin + BPProfileLabelWidth + BPProfileControlsSpacing;

    self.nameTextField = [[BPTextField alloc] initWithFrame:CGRectMake(left, self.nameLabel.frame.origin.y, maxWidth, BPTextFieldHeigth)];
    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BPSettingsToolbarHeight)];
    [toolBar setBackgroundImage:[BPUtils imageNamed:@"toolbar_background"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIImage *blackImage = [BPUtils imageNamed:@"black_button"];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, blackImage.size.width, blackImage.size.height);
    [cancelButton setBackgroundImage:blackImage forState:UIControlStateNormal];
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    cancelButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIImage *greenImage = [BPUtils imageNamed:@"green_button"];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, greenImage.size.width, greenImage.size.height);
    [doneButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    [doneButton setTitle:@"OK" forState:UIControlStateNormal];
    [doneButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    doneButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
    doneButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    toolBar.items = @[cancelItem, flexibleItem, doneItem];
    self.nameTextField.inputAccessoryView = toolBar;
    
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
    top += self.lastMenstruationButton.frame.size.height + BPProfileControlsSpacing;
    
    UIImage *checkBoxNormalImage = [BPUtils imageNamed:@"checkbox_normal"];
    UIImage *checkBoxSelectedImage = [BPUtils imageNamed:@"checkbox_selected"];
    
    self.pregnancyLabel = [[BPLabel alloc] initWithFrame:CGRectMake(BPProfileControlsMargin, top, BPProfileLabelWidth, checkBoxNormalImage.size.height)];

    left = BPProfileControlsMargin + BPProfileLabelWidth + BPProfileControlsSpacing;
    self.pregnancyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pregnancyButton.frame = CGRectMake(left, top, checkBoxNormalImage.size.width, checkBoxNormalImage.size.height);
    [self.pregnancyButton setBackgroundImage:checkBoxNormalImage forState:UIControlStateNormal];
    [self.pregnancyButton setBackgroundImage:checkBoxSelectedImage forState:UIControlStateHighlighted];
    [self.pregnancyButton setBackgroundImage:checkBoxSelectedImage forState:UIControlStateSelected];
    self.pregnancyButton.adjustsImageWhenHighlighted = NO;
    [self.pregnancyButton addTarget:self action:@selector(togglePregnancy:) forControlEvents:UIControlEventTouchUpInside];
    top += self.pregnancyButton.frame.size.height + BPProfileControlsSpacing;
    
    self.lastOvulationButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.lastOvulationButton.frame = CGRectMake(BPProfileControlsSpacing, top, BPProfileSelectButtonWidth, BPSelectButtonHeigth);
    [self.lastOvulationButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.childBirthButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.childBirthButton.frame = CGRectMake(self.view.frame.size.width - BPProfileControlsSpacing - BPProfileSelectButtonWidth, top, BPProfileSelectButtonWidth, BPSelectButtonHeigth);
    [self.childBirthButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    top += self.childBirthButton.frame.size.height + BPProfileControlsSpacing;
    
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
    
    [self.view addSubview:self.pregnancyLabel];
    [self.view addSubview:self.pregnancyButton];
    
    self.pickerView = [[BPValuePicker alloc] initWithFrame:CGRectMake(0, MAX(BPSettingsPickerMinimalOriginY, self.view.bounds.size.height - BPPickerViewHeight - self.tabBarController.tabBar.frame.size.height), self.view.bounds.size.width, BPPickerViewHeight)];
    [self.pickerView addTarget:self action:@selector(pickerViewValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pickerView];
    
    [self.view addSubview:self.lastOvulationButton];
    [self.view addSubview:self.childBirthButton];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    [super updateUI];
    
    self.selectLabel.text = BPLocalizedString(@"Hello!");

    self.nameLabel.text = BPLocalizedString(@"Name");
    self.birthdayLabel.text = BPLocalizedString(@"Birthday");
    self.weightLabel.text = BPLocalizedString(@"Weight");
    self.heightLabel.text = BPLocalizedString(@"Height");
    self.kgLabel.text = BPLocalizedString(@"kg");
    self.cmLabel.text = BPLocalizedString(@"cm");
   
    self.lengthOfCycleButton.subtitleLabel.text = BPLocalizedString(@"Length of my cycle");
    self.lastMenstruationButton.subtitleLabel.text = BPLocalizedString(@"Last menstruation");

    self.pregnancyLabel.text = BPLocalizedString(@"Pregnancy");

    self.lastOvulationButton.subtitleLabel.text = BPLocalizedString(@"Ovulation");
    self.childBirthButton.subtitleLabel.text = BPLocalizedString(@"Childbirth");

    // TODO: fill with data
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    self.nameTextField.text = sharedSettings[BPSettingsProfileNameKey];
    self.birthdayTextField.text = [BPUtils stringFromDate:sharedSettings[BPSettingsProfileBirthdayKey]];
    self.weightTextField.text = [sharedSettings[BPSettingsProfileWeightKey] description];
    self.heightTextField.text = [sharedSettings[BPSettingsProfileHeightKey] description];
    
    NSString *lengthOfCycleString = ([sharedSettings[BPSettingsProfileLengthOfCycleKey] description] ? : nil);
    [self.lengthOfCycleButton setTitle:lengthOfCycleString forState:UIControlStateNormal];
    
    NSDate *lastMenstruationDate = sharedSettings[BPSettingsProfileLastMenstruationDateKey];
    [self.lastMenstruationButton setTitle:[BPUtils stringFromDate:lastMenstruationDate] forState:UIControlStateNormal];
    
    self.pregnancyButton.selected = [sharedSettings[BPSettingsProfileIsPregnantKey] boolValue];
    
    self.lastOvulationButton.hidden = !self.pregnancyButton.selected;
    self.childBirthButton.hidden = !self.pregnancyButton.selected;
    
    NSDate *lastOvulationDate = sharedSettings[BPSettingsProfileLastOvulationDateKey];
    [self.lastOvulationButton setTitle:[BPUtils stringFromDate:lastOvulationDate] forState:UIControlStateNormal];
    
    NSDate *childBirthday = sharedSettings[BPSettingsProfileChildBirthdayKey];
    [self.childBirthButton setTitle:[BPUtils stringFromDate:childBirthday] forState:UIControlStateNormal];
}

- (void)settingsDidChange
{
    [self updateUI];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    if (textField == self.nameTextField) {
        [self pickerViewValueChanged]; // save current pickerView value
        self.pickerView.valuePickerMode = BPValuePickerModeNone;
        return YES;
    } else if (textField == self.birthdayTextField) {
        self.pickerView.valuePickerMode = BPValuePickerModeDate;
        self.pickerView.value = sharedSettings[BPSettingsProfileBirthdayKey] ? : [NSDate date];
    } else if (textField == self.weightTextField) {
        self.pickerView.valuePickerMode = BPValuePickerModeWeight;
        self.pickerView.value = sharedSettings[BPSettingsProfileWeightKey] ? : @0;
    } else if (textField == self.heightTextField) {
        self.pickerView.valuePickerMode = BPValuePickerModeHeight;
        self.pickerView.value = sharedSettings[BPSettingsProfileHeightKey] ? : @0;
    }
    
    if ([self.nameTextField isFirstResponder])
        [self.nameTextField resignFirstResponder];

    return NO;
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//- (void)textFieldDidEndEditing:(UITextField *)textField
- (void)textFieldTextChanged:(UITextField *)textField
{
    DLog(@"textField.text = %@", textField.text);
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    if (textField == self.nameTextField)
        sharedSettings[BPSettingsProfileNameKey] = textField.text;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)cancelPressed:(id)sender;
{
    [self.nameTextField resignFirstResponder];
}

- (void)donePressed:(id)sender;
{
    [self.nameTextField resignFirstResponder];
}

- (void)pickerViewValueChanged
{
    DLog(@"%s %i %@", __PRETTY_FUNCTION__, self.pickerView.valuePickerMode, self.pickerView.value);
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    // TODO: ?change child birthday for last ovulation + pregnant flag?
    
    switch (self.pickerView.valuePickerMode) {
        case BPValuePickerModeDate:
            sharedSettings[BPSettingsProfileBirthdayKey] = self.pickerView.value;
            break;
        case BPValuePickerModeWeight:
            sharedSettings[BPSettingsProfileWeightKey] = self.pickerView.value;
            break;
        case BPValuePickerModeHeight:
            sharedSettings[BPSettingsProfileHeightKey] = self.pickerView.value;
            break;
        case BPValuePickerModeMenstruationLength:
            sharedSettings[BPSettingsProfileLengthOfCycleKey] = self.pickerView.value;
            break;
        case BPValuePickerModeLastMenstruationDate:
            sharedSettings[BPSettingsProfileLastMenstruationDateKey] = self.pickerView.value;
            sharedSettings[BPSettingsProfileChildBirthdayKey] = [self.pickerView.value dateByAddingDays:BPPregnancyPeriod];
            break;
        case BPValuePickerModeLastOvulationDate:
            sharedSettings[BPSettingsProfileLastOvulationDateKey] = self.pickerView.value;
//            sharedSettings[BPSettingsProfileChildBirthdayKey] = [self.pickerView.value dateByAddingDays:BPPregnancyPeriod];
            break;
        case BPValuePickerModeChildBirthday:
            sharedSettings[BPSettingsProfileChildBirthdayKey] = self.pickerView.value;
            break;
        default:
            break;
    }
}

- (void)selectButtonTapped:(id)sender
{
    DLog(@"%@", sender);
    
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }

    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    if (sender == self.lengthOfCycleButton) {
        self.pickerView.valuePickerMode = BPValuePickerModeMenstruationLength;
        self.pickerView.value = sharedSettings[BPSettingsProfileLengthOfCycleKey] ? : @0;
    } else if (sender == self.lastMenstruationButton) {
        self.pickerView.valuePickerMode = BPValuePickerModeLastMenstruationDate;
        self.pickerView.value = sharedSettings[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date];
    } else if (sender == self.lastOvulationButton) {
        self.pickerView.valuePickerMode = BPValuePickerModeLastOvulationDate;
        self.pickerView.value = sharedSettings[BPSettingsProfileLastOvulationDateKey] ? : [NSDate date];
    } else if (sender == self.childBirthButton) {
        self.pickerView.valuePickerMode = BPValuePickerModeChildBirthday;
//        NSDate *lastOvulation = sharedSettings[BPSettingsProfileLastOvulationDateKey] ? : [NSDate date];
//        self.pickerView.value = sharedSettings[BPSettingsProfileChildBirthdayKey] ? : [lastOvulation dateByAddingDays:BPPregnancyPeriod];
        NSDate *lastMenstruation = sharedSettings[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date];
        self.pickerView.value = sharedSettings[BPSettingsProfileChildBirthdayKey] ? : [lastMenstruation dateByAddingDays:BPPregnancyPeriod];
    }
}

- (void)togglePregnancy:(id)sender
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    if (sender == self.pregnancyButton) {
        self.pregnancyButton.selected = !self.pregnancyButton.selected;
        
        // hide picker
        if (!self.pregnancyButton.selected && (self.pickerView.valuePickerMode == BPValuePickerModeLastOvulationDate ||
            self.pickerView.valuePickerMode == BPValuePickerModeChildBirthday)) {
            self.pickerView.valuePickerMode = BPValuePickerModeNone;
        }
        
        sharedSettings[BPSettingsProfileIsPregnantKey] = @(self.pregnancyButton.selected);
    }
}


@end
