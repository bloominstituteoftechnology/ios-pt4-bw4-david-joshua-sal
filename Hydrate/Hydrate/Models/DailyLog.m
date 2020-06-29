//
//  DailyLog.m
//  Hydrate
//
//  Created by David Wright on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

#import "DailyLog.h"

@interface DailyLog ()

@property (nonatomic) NSMutableArray <IntakeEntry *> *internalEntries;

@end

@implementation DailyLog

- (instancetype)initWithDate:(NSDate *)date entries:(NSArray<IntakeEntry *> *)entries
{
    if (self = [super init]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear |
                                                             NSCalendarUnitMonth |
                                                             NSCalendarUnitDay) fromDate:date];
        _date = [calendar dateFromComponents:components];
        _internalEntries = entries.mutableCopy;
    }
    return self;
}

- (NSInteger)totalIntakeAmount
{
    NSNumber *sum = [self.internalEntries.copy valueForKeyPath:@"@sum.intakeAmount"];
    return sum.integerValue;
}

- (NSInteger)entryCount
{
    return self.internalEntries.count;
}

- (NSArray<IntakeEntry *> *)entries
{
    return self.internalEntries.copy;
}

- (IntakeEntry *)entryAtIndex:(NSInteger)index
{
    return [self.internalEntries objectAtIndex:index];
}

- (void)addEntry:(IntakeEntry *)entry
{
    [self.internalEntries addObject:entry];
}

- (void)updateEntryAtIndex:(NSInteger)index withEntry:(nonnull IntakeEntry *)entry
{
    [self.internalEntries replaceObjectAtIndex:index withObject:entry];
}

- (void)removeEntry:(IntakeEntry *)entry
{
    [self.internalEntries removeObject:entry];
}

@end
