//
//  TPBOperations.h
//  Piggy Bank
//
//  Created by OZZE on 12/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPBOperations : NSObject

- (NSManagedObjectContext *) managedObjectContext;
- (NSArray *)arrayOfCreditsFromDate:(NSDate *)initDate toDate:(NSDate *) finalDate;
- (NSArray *)arrayOfDebitsFromDate:(NSDate *)initDate toDate:(NSDate *) finalDate;
- (NSMutableArray *) mutableArrayOfMovementsByType:(int)type;
- (NSString *) stringByDecimalNumber:(NSDecimalNumber *)number;
- (NSString *) stringFromDate:(NSDate *)date toFormat:(int)format;
- (NSDecimalNumber *)calculateBalance;
- (NSDecimalNumber *)calculateBalanceFromDate:(NSDate *)initDate toDate:(NSDate *) finalDate;
- (NSDecimalNumber *)sumCreditsFromDate:(NSDate *)initDate toDate:(NSDate *) finalDate;
- (NSDecimalNumber *)sumDebitsFromDate:(NSDate *)initDate toDate:(NSDate *) finalDate;

@end
