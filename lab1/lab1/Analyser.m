//
//  Analyser.m
//  lab1
//
//  Created by fpmi on 10.04.17.
//  Copyright (c) 2017 student. All rights reserved.
//

#import "Analyser.h"

@implementation Analyser
- (void)foo:(NSString *)bar
{
    NSLog(bar);
    NSArray *words = [bar componentsSeparatedByString:@" "];
    NSMutableDictionary *statistics;
    statistics = [[NSMutableDictionary alloc]init];
    for (NSString* word in words)
    {
        NSNumber *repetitions = [statistics valueForKey:word];
        if ([repetitions integerValue] > 0) {
            [statistics setObject:[[NSNumber alloc] initWithLong:([repetitions integerValue] + 1)] forKey:word];
        } else {
            [statistics setObject:[[NSNumber alloc] initWithLong:1] forKey:word];
        }
    }
    NSArray *sortedKeys = [statistics keysSortedByValueUsingComparator:^(id obj1, id obj2){
        if([obj1 integerValue] < [obj2 integerValue])
            return (NSComparisonResult)NSOrderedDescending;
        if([obj1 integerValue] > [obj2 integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    int i = 0;
    for(NSString* key in sortedKeys){
        if(i > 4)
            break;
        NSNumber *n = [statistics valueForKey:key];
        NSLog(@"%@: %ld", key, (long)[n integerValue]);
        i++;
    }
}
@end
