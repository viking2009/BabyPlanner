//
//  BPSymptomsAndMoodViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 31.03.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSymptomsAndMoodViewController.h"
#import "BPSymptomsAndMoodCollectionViewCell.h"

#define BPSymptomsAndMoodCollectionViewCellIdentifier @"BPSymptomsAndMoodCollectionViewCellIdentifier"

@interface BPSymptomsAndMoodViewController ()

@end

@implementation BPSymptomsAndMoodViewController

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
    
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[BPSymptomsAndMoodCollectionViewCell class] forCellWithReuseIdentifier:BPSymptomsAndMoodCollectionViewCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BPSymptomsAndMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BPSymptomsAndMoodCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"symptom_%i.png", indexPath.item + 1];
    cell.imageView.image = [UIImage imageNamed:imageName];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath = %@", indexPath);
}

@end
