//
//  BPSettings.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPProfile;

@interface BPSettings : NSManagedObject

@property (nonatomic, retain) NSNumber * thermometr;
@property (nonatomic, retain) NSNumber * metric;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * theme;
@property (nonatomic, retain) BPProfile *profile;

@end
