//
//  Utilities.h
//  Piggy Bank
//
//  Created by OZZE on 12/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
- (NSManagedObjectContext *)managedObjectContext;
- (NSMutableArray *)getObjectsFromStore:(int)store;
- (NSArray *)credits:(NSDate *)initDate byPeriod:(NSDate *) finalDate;
- (NSArray *)debits:(NSDate *)initDate byPeriod:(NSDate *) finalDate;
- (NSDecimalNumber *)sumCredits:(NSDate *)initDate byPeriod:(NSDate *) finalDate;
- (NSDecimalNumber *)sumDebits:(NSDate *)initDate byPeriod:(NSDate *) finalDate;
- (NSDecimalNumber *)calculateBalance;
- (NSDecimalNumber *)calculateBalance:(NSDate *)initDate byPeriod:(NSDate *) finalDate;
- (NSString *) decimalNumberAsString:(NSDecimalNumber *)number;
- (NSString *)dateToFortmat:(NSDate *)date :(int)format;
@end
