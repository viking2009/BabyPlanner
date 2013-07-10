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

@interface BPSettingsProfileViewController () <UITextFieldDelegate>

// TODO: refactor: set names
@property (nonatomic, strong) BPLabel *firstLabel;
@property (nonatomic, strong) BPLabel *secondLabel;
@property (nonatomic, strong) BPLabel *thirdLabel;
@property (nonatomic, strong) BPLabel *fourthLabel;

@property (nonatomic, strong) BPTextField *firstTextField;
@property (nonatomic, strong) BPTextField *secondTextField;
@property (nonatomic, strong) BPTextField *thirdTextField;
@property (nonatomic, strong) BPTextField *fourthTextField;

@property (nonatomic, strong) BPSelectButton *firstButton;
@property (nonatomic, strong) BPSelectButton *secondButton;
@property (nonatomic, strong) BPSelectButton *thirdButton;
@property (nonatomic, strong) BPSelectButton *fourthButton;

@property (nonatomic, strong) BPValuePicker *pickerView;

@end

@implementation BPSettingsProfileViewController

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
    
    // TODO: set frames
    self.firstLabel = [[BPLabel alloc] initWithFrame:CGRectZero];
    self.secondLabel = [[BPLabel alloc] initWithFrame:CGRectZero];
    self.thirdLabel = [[BPLabel alloc] initWithFrame:CGRectZero];
    self.fourthLabel = [[BPLabel alloc] initWithFrame:CGRectZero];

    self.firstTextField = [[BPTextField alloc] initWithFrame:CGRectZero];
    self.firstTextField.delegate = self;
    self.secondTextField = [[BPTextField alloc] initWithFrame:CGRectZero];
    self.secondTextField.delegate = self;
    self.thirdTextField = [[BPTextField alloc] initWithFrame:CGRectZero];
    self.thirdTextField.delegate = self;
    self.fourthTextField = [[BPTextField alloc] initWithFrame:CGRectZero];
    self.fourthTextField.delegate = self;

    self.firstButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectZero;
    [self.firstButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.secondButton.frame = CGRectZero;
    [self.secondButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    self.thirdButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.thirdButton.frame = CGRectZero;
    [self.thirdButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.fourthButton = [BPSelectButton buttonWithType:UIButtonTypeCustom];
    self.fourthButton.frame = CGRectZero;
    [self.fourthButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.firstLabel];
    [self.view addSubview:self.secondLabel];
    [self.view addSubview:self.thirdLabel];
    [self.view addSubview:self.fourthLabel];
    
    [self.view addSubview:self.firstTextField];
    [self.view addSubview:self.secondTextField];
    [self.view addSubview:self.thirdTextField];
    [self.view addSubview:self.fourthTextField];
    
    [self.view addSubview:self.firstButton];
    [self.view addSubview:self.secondButton];
    [self.view addSubview:self.thirdButton];
    [self.view addSubview:self.fourthButton];
    
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
    self.firstLabel.text = BPLocalizedString(@"firstLabel");
    self.secondLabel.text = BPLocalizedString(@"secondLabel");
    self.thirdLabel.text = BPLocalizedString(@"thirdLabel");
    self.fourthLabel.text = BPLocalizedString(@"fourthLabel");
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
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
