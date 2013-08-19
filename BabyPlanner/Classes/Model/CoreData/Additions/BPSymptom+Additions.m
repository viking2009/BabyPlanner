//
//  BPSymptom+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 19.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSymptom+Additions.h"
#import "NSManagedObject+ActiveRecord.h"

@implementation BPSymptom (Additions)

+ (NSArray *)all {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    return fetchedObjects.count > 0 ? fetchedObjects : nil;
}

@end
