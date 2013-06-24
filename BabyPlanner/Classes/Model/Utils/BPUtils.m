//
//  BPUtils.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPUtils.h"

@implementation BPUtils

+ (UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:[@"BPImages.bundle" stringByAppendingPathComponent:name]];
}

@end
