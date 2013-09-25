//
//  BPCycle+Additions.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCycle.h"

@interface BPCycle (Additions)

@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSString *title;

+ (BPCycle *)cycleWithIndex:(NSNumber *)index;

@end
