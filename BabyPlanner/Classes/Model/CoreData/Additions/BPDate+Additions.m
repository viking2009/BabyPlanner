//
//  BPDate+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 22.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDate+Additions.h"
#import "BPSettings+Additions.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "NSDate-Utilities.h"
#import <objc/runtime.h>

#define kBPDateImageName @"kBPDateImageName"

@implementation BPDate (Additions)

- (NSString *)imageName
{
    return objc_getAssociatedObject(self, kBPDateImageName);
}

- (void)setImageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, kBPDateImageName, imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (BPDate *)dateWithDate:(NSDate *)aDate
{
    aDate = [aDate dateAtStartOfDay];
    
    BPDate *date = [self where:[NSPredicate predicateWithFormat:@"date == %@", aDate]].first;
    if (!date)
        date = [self create:@{@"date": aDate}];
    
    return date;
}

@end
