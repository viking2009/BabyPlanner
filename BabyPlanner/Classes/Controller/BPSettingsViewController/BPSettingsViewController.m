//
//  BPSettingsViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 30.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettingsViewController.h"

#define BPSettingsViewCellIdentifier @"BPSettingsViewCellIdentifier"

@interface BPSettingsViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation BPSettingsViewController

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
    NSLog(@"self.tableView = %@", self.tableView);
    
    self.data = @[
                  @[ @{@"title": @"Termometer", @"subtitle" : @""},
                     @{@"title": @"Mesure", @"subtitle" : @"C"}],
                  @[ @{@"title": @"Language", @"subtitle" : @"English"},
                     @{@"title": @"Theme", @"subtitle" : @""},
                     @{@"title": @"Alarm", @"subtitle" : @"Off"},
                     @{@"title": @"My Profile", @"subtitle" : @""}],
                  @[ @{@"title": @"Length of my cycle", @"subtitle" : @"28"},
                     @{@"title": @"Last menstruation", @"subtitle" : @"12.05.13"}]
                  ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"[self.data count] = %i", [self.data count]);
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BPSettingsViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BPSettingsViewCellIdentifier];
    }
    
    NSLog(@"cell = %@", cell);
    NSDictionary *item = self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *accessorySwitch = [[UISwitch alloc] init];
        cell.accessoryView = accessorySwitch;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
