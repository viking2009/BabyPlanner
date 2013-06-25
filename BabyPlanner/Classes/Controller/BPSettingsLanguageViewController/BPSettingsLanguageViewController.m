//
//  BPSettingsLanguageViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsLanguageViewController.h"

#import "BPUtils.h"

@interface BPSettingsLanguageViewController ()

@property (nonatomic, strong) NSArray *data;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
