//
//  BPDate+Additions.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 22.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDate.h"

@interface BPDate (Additions)

@property (nonatomic, copy) NSString *imageName;

+ (BPDate *)dateWithDate:(NSDate *)date;

@end
