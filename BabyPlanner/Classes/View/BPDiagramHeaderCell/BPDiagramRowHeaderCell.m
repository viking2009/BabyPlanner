//
//  BPDiagramRowHeaderCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 04.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramRowHeaderCell.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"

#define BPDiagramRowHeaderCellItemSize 30.0f
#define BPDiagramRowHeaderCellItemInternalSize 28.0f
#define BPDiagramRowHeaderCellPadding 4.0f
#define BPDiagramMaxTemperature 38

@interface BPDiagramRowHeaderCell ()

@property (nonatomic, strong, readwrite) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation BPDiagramRowHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [BPUtils imageNamed:@"mycharts_diagram_row_background"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 4.0f) resizingMode:UIImageResizingModeStretch]];
        [self addSubview:self.backgroundImageView];
        
        self.labels = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 8; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
            label.textColor = RGB(2, 106, 80);
            if (i < 4)
                label.textAlignment = NSTextAlignmentRight;
            [self.labels addObject:label];
            [self addSubview:label];
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    NSInteger i = 0;
    for (UILabel *label in self.labels) {
        switch (i) {
            case 0:
                label.frame = CGRectMake(0, 0, self.width, BPDiagramRowHeaderCellItemInternalSize - 8.0f);
                break;
            case 1:
                label.frame = CGRectMake(0, floorf(1.5*BPDiagramRowHeaderCellItemSize), self.width, BPDiagramRowHeaderCellItemInternalSize);
                break;
            case 2:
                label.frame = CGRectMake(0, floorf(3.5*BPDiagramRowHeaderCellItemSize), self.width, BPDiagramRowHeaderCellItemInternalSize);
                break;
            case 3:
                label.frame = CGRectMake(0, 5*BPDiagramRowHeaderCellItemSize + 8.0f, self.width, BPDiagramRowHeaderCellItemInternalSize - 8.0f);
                break;
            case 4:
                label.frame = CGRectMake(BPDiagramRowHeaderCellPadding, 7*BPDiagramRowHeaderCellItemSize + 8.0f, self.width - BPDiagramRowHeaderCellPadding, BPDiagramRowHeaderCellItemInternalSize - 8.0f);
                break;
            default:
                label.frame = CGRectMake(BPDiagramRowHeaderCellPadding, (3 + i)*BPDiagramRowHeaderCellItemSize, self.width - BPDiagramRowHeaderCellPadding, BPDiagramRowHeaderCellItemInternalSize);
                break;
        }
        
        i++;
    }
}

- (void)updateUI {
    NSInteger i = 0;
    for (UILabel *label in self.labels) {
        switch (i) {
            case 0:
            case 1:
            case 2:
            case 3:
                label.text = [BPUtils shortTemperatureFromNumber:@(BPDiagramMaxTemperature - i)];
                break;
            case 4:
                label.text = BPLocalizedString(@"Day");
                break;
            case 5:
                label.text = BPLocalizedString(@"M");
                break;
            case 6:
                label.text = BPLocalizedString(@"SI");
                break;
            case 7:
                label.text = BPLocalizedString(@"S&M");
                break;
                
            default:
                break;
        }
        
        i++;
    }
}

@end
