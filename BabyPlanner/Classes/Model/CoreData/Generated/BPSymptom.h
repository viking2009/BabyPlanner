//
//  BPSymptom.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 19.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPDate;

@interface BPSymptom : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) BPDate *date;

@end
