//
//  BPMyTemperatureSymptomsAndMoodViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureSymptomsAndMoodViewController.h"
#import "BPSymptomsAndMoodCollectionViewCell.h"
#import "BPUtils.h"
#import "ObjectiveRecord.h"
#import "BPSymptom.h"
#import "UIView+Sizes.h"

#define BPSymptomsAndMoodCollectionViewCellIdentifier @"BPSymptomsAndMoodCollectionViewCellIdentifier"

@interface BPMyTemperatureSymptomsAndMoodViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *symptoms;

@end

@implementation BPMyTemperatureSymptomsAndMoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Symptoms and mood";
    }

    return self;
}

- (void)dealloc
{
    [self.date save];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.size.width = self.view.width - titleLabelFrame.origin.x - 8.f;
    self.titleLabel.frame = titleLabelFrame;
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[collectionViewFlowLayout setItemSize:CGSizeMake(BPSymptomsAndMoodDefaultImageWidth, BPSymptomsAndMoodDefaultImageHeight + BPSymptomsAndMoodDefaultTitleHeight)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.width, self.view.height - 64.f - self.tabBarController.tabBar.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BPSymptomsAndMoodCollectionViewCell class] forCellWithReuseIdentifier:BPSymptomsAndMoodCollectionViewCellIdentifier];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    self.symptoms = [BPSymptom all];
    DLog(@"%@", self.symptoms);
    
    if (!self.symptoms) {
        NSArray *symptoms = @[@"Good mood", @"Irritability", @"Hunger",
                              @"Tearfulness", @"Fatigue", @"Party",
                              @"Pressure", @"Migraine", @"Colds",
                              @"Temperature", @"Nausea", @"Heartburn"];
        
        for (int i = 0; i < [symptoms count]; i++) {
            DLog(@"i: %i", i);
            BPSymptom *symptom = [BPSymptom create];
            symptom.position = @(i);
            symptom.name = symptoms[i];
            NSString *underscored = [[symptom.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            symptom.imageName = [NSString stringWithFormat:@"symptoms_icon_%@", underscored];
        }
        
        NSError *error;
        [[NSManagedObjectContext defaultContext] save:&error];
        if (error)
            DLog(@"error: %@", error);
        else
            self.symptoms = [BPSymptom all];
    }
    
    int i = 0;
    for (BPSymptom *symptom in self.symptoms) {
        if ([self.date.symptoms containsObject:symptom]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        i++;
    }
}

- (void)updateUI
{
    [super updateUI];
    
    [self.collectionView reloadData];
}

- (void)localize
{
    [super localize];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.symptoms count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPSymptomsAndMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSymptomsAndMoodCollectionViewCellIdentifier forIndexPath:indexPath];
    
    BPSymptom *symptom = _symptoms[indexPath.item];
    cell.imageView.image = [BPUtils imageNamed:symptom.imageName];
    cell.titleLabel.text = BPLocalizedString(symptom.name);

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
    [self.date addSymptomsObject:_symptoms[indexPath.item]];
    DLog(@"self.date.symptoms: %@", self.date.symptoms);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
    [self.date removeSymptomsObject:_symptoms[indexPath.item]];
    DLog(@"self.date.symptoms: %@", self.date.symptoms);
}

@end
