//
//  BPMyTemperatureMainViewController.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 07.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMyTemperatureMainViewController.h"
#import "BPUtils.h"

@interface BPMyTemperatureMainViewController ()

@property (nonatomic, strong) UIButton *myControlsButton;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *girlView;

@end

@implementation BPMyTemperatureMainViewController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    self.myControlsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myControlsButtonBackgroundImage = [BPUtils imageNamed:@"mytemperature_main_button_background"];
    [self.myControlsButton setBackgroundImage:myControlsButtonBackgroundImage forState:UIControlStateNormal];
    self.myControlsButton.frame = CGRectMake(0, self.view.bounds.size.height - 55.f - self.tabBarController.tabBar.frame.size.height, myControlsButtonBackgroundImage.size.width, myControlsButtonBackgroundImage.size.height);
    self.myControlsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.myControlsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.myControlsButton addTarget:self action:@selector(myControlsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myControlsButton];
    
    self.girlView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_girl"]];

    CGFloat offset = MAX(330.f, self.view.bounds.size.height - self.girlView.image.size.height);
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[BPUtils imageNamed:@"mytemperature_main_bubble"]];
    bubbleView.frame = CGRectMake(3, offset, bubbleView.image.size.width, bubbleView.image.size.height);
    [self.view addSubview:bubbleView];
    
    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectOffset(bubbleView.frame, 0, -10.f)];
    self.selectLabel.backgroundColor = [UIColor clearColor];
    self.selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.selectLabel.textColor = RGB(76, 86, 108);
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
    //    self.selectLabel.shadowColor = RGB(255, 255, 255);
    //    self.selectLabel.shadowOffset = CGSizeMake(0, -1);
    self.selectLabel.numberOfLines = 2;
    [self.view addSubview:self.selectLabel];
    
    self.girlView.frame = CGRectMake(97, offset, self.girlView.image.size.width, self.girlView.image.size.height);
    [self.view addSubview:self.girlView];
    
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
    
    self.selectLabel.text = BPLocalizedString(@"!Ta-da!");
    [self.myControlsButton setTitle:BPLocalizedString(@"My controls") forState:UIControlStateNormal];
}



#pragma mark - BPBaseViewController

- (void)setBackgroundImage:(UIImage *)backgroundImage
{

}

#pragma mark - Private

- (void)myControlsButtonTapped
{
    if (self.handler)
        self.handler();
}

@end
