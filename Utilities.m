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
    NSManagedObjectContext *moc = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        moc = [delegate managedObjectContext];
    }
    return moc;
}

- (NSMutableArray *)getObjectsFromStore:(int) store
{
    NSMutableArray *movements;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    
    switch (store)
    {
        case 0:
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
            movements = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        case 1:
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
            movements = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        default:
            NSLog (@"Invalid entity");
            break;
    }
    
    return movements;
}

- (NSArray *)credits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    movements = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    
    return movements;
}
- (NSArray *)debits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    movements = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    
    return movements;
}

- (NSDecimalNumber *)sumCredits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    movements = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    sum = [movements valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)sumDebits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    movements = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    sum = [movements valueForKeyPath:@"@sum.amount"];
    
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
