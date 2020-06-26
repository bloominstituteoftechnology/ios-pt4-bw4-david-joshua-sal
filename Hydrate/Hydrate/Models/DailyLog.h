//
//  DailyLog.h
//  Hydrate
//
//  Created by David Wright on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IntakeEntry;

@interface DailyLog : NSObject

// Properties
@property (nonatomic, readonly, nonnull) NSDate *date;
@property (nonatomic, readonly, copy, nonnull) NSArray<IntakeEntry *> *entries;

@property (nonatomic, readonly) NSInteger totalIntakeAmount;

// Initializers
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date
                             entries:(nonnull NSArray<IntakeEntry *> *)entries;

@end
