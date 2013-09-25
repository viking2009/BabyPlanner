//
//  BPMyTemperatureNotationsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureNotationsViewController.h"
#import "EKKeyboardAvoidingScrollViewManager.h"
#import "BPDate.h"
#import "BPUtils.h"
#import "ObjectiveRecord.h"
#import "BPSettings+Additions.h"

@interface BPMyTemperatureNotationsViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *notesView;

@end

@implementation BPMyTemperatureNotationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Notations";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect notesViewRect = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f - self.tabBarController.tabBar.frame.size.height);
    
    self.notesView = [[UITextView alloc] initWithFrame:notesViewRect];
    self.notesView.backgroundColor = [UIColor clearColor];
    self.notesView.contentInset = UIEdgeInsetsMake(40, 0, 20, 0);
    self.notesView.scrollIndicatorInsets = self.notesView.contentInset;
    self.notesView.font = [UIFont fontWithName:@"Gabriola" size:23];
    self.notesView.textAlignment = NSTextAlignmentCenter;
//    self.notesView.delegate = self;
    [self.view addSubview:self.notesView];
    
    UIImageView *notesHeader = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"notes_header"]];
    notesHeader.frame = CGRectMake(self.notesView.frame.origin.x, self.notesView.frame.origin.y, notesHeader.image.size.width, notesHeader.image.size.height);
    [self.view insertSubview:notesHeader belowSubview:self.navigationImageView];
    
    [[EKKeyboardAvoidingScrollViewManager sharedInstance] registerScrollViewForKeyboardAvoiding:self.notesView];
    
    self.notesView.text = self.date.notations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.notesView.delegate = nil;
    [[EKKeyboardAvoidingScrollViewManager sharedInstance] unregisterScrollViewFromKeyboardAvoiding:self.notesView];

    self.date.notations = self.notesView.text;
    [self.date save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BPSettingsDidChangeNotification object:nil userInfo:nil];
}

@end
