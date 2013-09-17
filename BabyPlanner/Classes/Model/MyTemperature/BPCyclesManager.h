//
//  BPCyclesManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPCyclesManager : NSObject

+ (BPCyclesManager *)sharedManager;

@property (nonatomic, readonly) NSUInteger numberOfCycles;
@property (nonatomic, readonly) NSUInteger avgCycleLength;
@property (nonatomic, readonly) NSArray *cycles;

@end
