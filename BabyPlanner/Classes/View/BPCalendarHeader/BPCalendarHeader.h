//
//  BPCalendarHeader.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 25.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPCalendarHeaderDelegate;

@interface BPCalendarHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, weak) id delegate;

- (void)updateDayOfWeekLabels;

@end

@protocol BPCalendarHeaderDelegate<NSObject>
@optional

- (void)calendarHeaderDidTapPrevButton:(BPCalendarHeader *)calendarHeader;
- (void)calendarHeaderDidTapNextButton:(BPCalendarHeader *)calendarHeader;

@end
