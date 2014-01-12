//
//  Utilities.m
//  Piggy Bank
//
//  Created by OZZE on 12/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSMutableArray *)getObjectsFromStore:(int) store
{
    NSMutableArray *objects;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    
    switch (store)
    {
        case 0:
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
            objects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        case 1:
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
            objects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        default:
            NSLog (@"Invalid entity");
            break;
    }
    
    return objects;
}

- (NSArray *)credits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    
    return objects;
}
- (NSArray *)debits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    
    return objects;
}

- (NSDecimalNumber *)sumCredits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    sum = [objects valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)sumDebits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    sum = [objects valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)calculateBalance
{
    NSDecimalNumber *balance;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSArray *credits;
    NSArray *debits;
    
    credits = [self getObjectsFromStore:0];
    debits = [self getObjectsFromStore:1];
    totalCredits = [credits valueForKeyPath:@"@sum.amount"];
    totalDebits = [debits valueForKeyPath:@"@sum.amount"];
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    return balance;
}

- (NSDecimalNumber *)calculateBalance:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *balance;
    NSPredicate *predicate;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSArray *credits;
    NSArray *debits;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    credits = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    debits = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    totalCredits = [credits valueForKeyPath:@"@sum.amount"];
    totalDebits = [debits valueForKeyPath:@"@sum.amount"];
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    
    return balance;
}

- (NSString *) decimalNumberAsString:(NSDecimalNumber *)number
{
    NSString *decimalToString;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setNegativeFormat:@"-¤#,##0.00"];
    decimalToString = [numberFormatter stringFromNumber:number];
    
    return decimalToString;
}

- (NSString *)dateToFortmat:(NSDate *)date :(int)format
{
    NSString *dateConverted;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (format)
    {
        case 0:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            dateConverted = [dateFormatter stringFromDate:date];
            break;
        case 1:
            [dateFormatter setDateFormat:@"MMMM, YYYY"];
            dateConverted = [dateFormatter stringFromDate:date];
            break;
        default:
            NSLog (@"Invalid format");
            break;
    }
    
    return  dateConverted;
}
@end
