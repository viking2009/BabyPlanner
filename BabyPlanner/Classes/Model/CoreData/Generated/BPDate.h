//
//  BPDate.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPProfile;

@interface BPDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * menstruation;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * boy;
@property (nonatomic, retain) NSNumber * girl;
@property (nonatomic, retain) NSNumber * sexualIntercourse;
@property (nonatomic, retain) NSString * notations;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * pregnant;
@property (nonatomic, retain) NSNumber * ovulation;
@property (nonatomic, retain) BPProfile *profile;

@end
