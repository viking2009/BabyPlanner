//
//  BPDatesManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BPDatesManagerDidChangeContentNotification;

@interface BPDatesManager : NSObject

@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) NSInteger ovulationIndex;

- (id)initWithStartDate:(NSDate *)date;

- (id)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);

@end
