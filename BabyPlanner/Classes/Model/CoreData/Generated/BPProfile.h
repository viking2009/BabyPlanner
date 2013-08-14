//
//  BPProfile.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPSettings;

@interface BPProfile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * lengthOfCycle;
@property (nonatomic, retain) NSDate * lastMenstruation;
@property (nonatomic, retain) NSNumber * isPregnant;
@property (nonatomic, retain) NSDate * lastOvulation;
@property (nonatomic, retain) NSDate * childBirthday;
@property (nonatomic, retain) BPSettings *settings;

@end
