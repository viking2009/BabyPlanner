//
//  BPCycle+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCycle+Additions.h"
#import "NSDate-Utilities.h"

@implementation BPCycle (Additions)

- (NSUInteger)length {
    return [self.endDate daysAfterDate:self.startDate];
}

@end
