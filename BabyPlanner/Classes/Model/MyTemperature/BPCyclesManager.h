//
//  BPCyclesManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPCycle;

@interface BPCyclesManager : NSObject

+ (BPCyclesManager *)sharedManager;

@property (nonatomic, readonly) NSUInteger numberOfCycles;
@property (nonatomic, readonly) NSUInteger averageCycleLength;
@property (nonatomic, readonly) NSArray *cycles;
@property (nonatomic, readonly) BPCycle *currentCycle;

@end
