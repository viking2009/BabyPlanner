//
//  BPDiagramCell.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 03.11.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDiagramCell.h"
#import "BPUtils.h"
#import "BPDate+Additions.h"
#import "BPSymptom+Additions.h"

#define BPDiagramCellItemSize 30.0f
#define BPDiagramCellItemInternalSize 28.0f

@interface BPDiagramCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *menstruationView;
@property (nonatomic, strong) UIImageView *sexualIntercourseView;
@property (nonatomic, strong) UIImageView *symptomsView;

@end

@implementation BPDiagramCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        self.dayLabel.textColor = RGB(2, 106, 80);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dayLabel.frame = CGRectMake(0, 7*BPDiagramCellItemSize + 8.0f, BPDiagramCellItemInternalSize, BPDiagramCellItemInternalSize - 8.0f);
    self.menstruationView.frame = CGRectMake(0, 8*BPDiagramCellItemSize, BPDiagramCellItemInternalSize, BPDiagramCellItemInternalSize);
    self.sexualIntercourseView.frame = CGRectMake(0, 9*BPDiagramCellItemSize, BPDiagramCellItemInternalSize, BPDiagramCellItemInternalSize);
    self.symptomsView.frame = CGRectMake(0, 10*BPDiagramCellItemSize, BPDiagramCellItemInternalSize, BPDiagramCellItemInternalSize);
}

#pragma mark - Public

- (void)setDate:(BPDate *)date
{
    //    if (_date != date) {
    _date = date;
    
    self.dayLabel.text = [_date.day description];
    
    if ([_date.menstruation boolValue])
        self.menstruationView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_menstruation"];
    else
        self.menstruationView.image = nil;
    
    if ([_date.sexualIntercourse boolValue])
        self.sexualIntercourseView.image = [BPUtils imageNamed:@"mycharts_calendar_icon_sexualintercourse"];
    else
        self.sexualIntercourseView.image = nil;
    
    if ([_date.symptoms count]) {
        BPSymptom *symptom = [_date.symptoms anyObject];
        NSString *imageName = [NSString stringWithFormat:@"mycharts_%@", symptom.imageName];
        self.symptomsView.image = [BPUtils imageNamed:imageName];
    } else
        self.symptomsView.image = nil;
    
    [self setNeedsLayout];
    //    }
}

#pragma mark - Private

- (UIImageView *)menstruationView {
    if (!_menstruationView) {
        _menstruationView = [[UIImageView alloc] init];
        _menstruationView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_menstruationView];
    }
    
    return _menstruationView;
}

- (UIImageView *)sexualIntercourseView {
    if (!_sexualIntercourseView) {
        _sexualIntercourseView = [[UIImageView alloc] init];
        _sexualIntercourseView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_sexualIntercourseView];
    }
    
    return _sexualIntercourseView;
}

- (UIImageView *)symptomsView
{
    if (!_symptomsView) {
        _symptomsView = [[UIImageView alloc] init];
        _symptomsView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_symptomsView];
    }
    
    return _symptomsView;
}

@end
