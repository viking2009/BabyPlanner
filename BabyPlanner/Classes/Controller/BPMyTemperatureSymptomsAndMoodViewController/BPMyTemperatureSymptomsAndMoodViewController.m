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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[collectionViewFlowLayout setItemSize:CGSizeMake(BPSymptomsAndMoodDefaultImageWidth, BPSymptomsAndMoodDefaultImageHeight + BPSymptomsAndMoodDefaultTitleHeight)];
	//[collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(320, 30)];
	//[collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(320, 50)];
	//[collectionViewFlowLayout setMinimumInteritemSpacing:20];
	[collectionViewFlowLayout setMinimumInteritemSpacing:0];
	[collectionViewFlowLayout setMinimumLineSpacing:0];
	[collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    CGRect collectionViewRect = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f - self.tabBarController.tabBar.frame.size.height);
    
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
    // TODO: localize
    self.symptoms = @[@"Хорошее настроение", @"Раздражительность", @"Вечеринка",
                      @"Плаксивость", @"Голод", @"Усталость",
                      @"Давление", @"Мигрень", @"Простуда",
                      @"Температура", @"Тошнота", @"Изжога"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.symptoms count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPSymptomsAndMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSymptomsAndMoodCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"symptoms_icon_%i", indexPath.item + 1];
    cell.imageView.image = [BPUtils imageNamed:imageName];
    cell.titleLabel.text = _symptoms[indexPath.item];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
}

@end
