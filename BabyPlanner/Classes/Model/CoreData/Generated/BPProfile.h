//
//  BPProfile.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPCycle, BPSettings;

@interface BPProfile : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSDate * childBirthday;
@property (nonatomic, retain) NSDate * conceiving;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * isPregnant;
@property (nonatomic, retain) NSDate * lastMenstruation;
@property (nonatomic, retain) NSDate * lastOvulation;
@property (nonatomic, retain) NSNumber * lengthOfCycle;
@property (nonatomic, retain) NSNumber * menstruationPeriod;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * boy;
@property (nonatomic, retain) NSNumber * girl;
@property (nonatomic, retain) BPSettings *settings;
@property (nonatomic, retain) NSSet *cycles;
@end

@interface BPProfile (CoreDataGeneratedAccessors)

- (void)addCyclesObject:(BPCycle *)value;
- (void)removeCyclesObject:(BPCycle *)value;
- (void)addCycles:(NSSet *)values;
- (void)removeCycles:(NSSet *)values;

@end
