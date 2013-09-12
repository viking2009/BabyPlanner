//
//  BPDate.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPCycle, BPSymptom;

@interface BPDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * menstruation;
@property (nonatomic, retain) NSNumber * mmenstruation;
@property (nonatomic, retain) NSString * notations;
@property (nonatomic, retain) NSNumber * ovulation;
@property (nonatomic, retain) NSNumber * pregnant;
@property (nonatomic, retain) NSNumber * sexualIntercourse;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSSet *symptoms;
@property (nonatomic, retain) BPCycle *cycle;
@end

@interface BPDate (CoreDataGeneratedAccessors)

- (void)addSymptomsObject:(BPSymptom *)value;
- (void)removeSymptomsObject:(BPSymptom *)value;
- (void)addSymptoms:(NSSet *)values;
- (void)removeSymptoms:(NSSet *)values;

@end
