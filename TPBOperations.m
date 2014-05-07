//
//  TPBOperations.m
//  Piggy Bank
//
//  Created by OZZE on 12/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "TPBOperations.h"

@implementation TPBOperations

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *moc = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        moc = [delegate managedObjectContext];
    }
    return moc;
}

- (NSArray *)arrayOfCreditsFromDate:(NSDate *)initialDate toDate:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *credits;
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initialDate, finalDate];
    credits = [[self mutableArrayOfMovementsByType:0] filteredArrayUsingPredicate:predicate];
    
    return credits;
}

- (NSArray *)arrayOfDebitsFromDate:(NSDate *)initialDate toDate:(NSDate *) finalDate
{
    NSPredicate *predicate;
    NSArray *debits;
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initialDate, finalDate];
    debits = [[self mutableArrayOfMovementsByType:1] filteredArrayUsingPredicate:predicate];
    
    return debits;
}

- (NSMutableArray *)mutableArrayOfMovementsByType:(int) type
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSMutableArray *movements;
    NSFetchRequest *request;
    
    switch (type)
    {
        case 0:
            request = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
            movements = [[moc executeFetchRequest:request error:nil] mutableCopy];
            break;
        case 1:
            request = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
            movements = [[moc executeFetchRequest:request error:nil] mutableCopy];
            break;
        default:
            NSLog (@"Invalid entity");
            break;
    }
    
    return movements;
}

- (NSString *) stringByDecimalNumber:(NSDecimalNumber *)number
{
    NSString *convertedString;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setNegativeFormat:@"-¤#,##0.00"];
    convertedString = [numberFormatter stringFromNumber:number];
    
    return convertedString;
}

- (NSString *)stringFromDate:(NSDate *)date toFormat:(int)format
{
    NSString *convertedString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (format)
    {
        case 0:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            convertedString = [dateFormatter stringFromDate:date];
            break;
        case 1:
            [dateFormatter setDateFormat:@"MMMM, YYYY"];
            convertedString = [dateFormatter stringFromDate:date];
            break;
        default:
            NSLog (@"Invalid format");
            break;
    }
    
    return  convertedString;
}

- (NSDecimalNumber *)calculateBalance
{
    NSArray *credits;
    NSArray *debits;
    NSDecimalNumber *balance;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;

    credits = [self mutableArrayOfMovementsByType:0];
    debits = [self mutableArrayOfMovementsByType:1];
    totalCredits = [credits valueForKeyPath:@"@sum.value"];
    totalDebits = [debits valueForKeyPath:@"@sum.value"];
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    return balance;
}

- (NSDecimalNumber *)calculateBalanceFromDate:(NSDate *)initialDate toDate:(NSDate *) finalDate
{
    NSArray *credits;
    NSArray *debits;
    NSDecimalNumber *balance;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSPredicate *predicate;

    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initialDate, finalDate];
    credits = [[self mutableArrayOfMovementsByType:0] filteredArrayUsingPredicate:predicate];
    debits = [[self mutableArrayOfMovementsByType:1] filteredArrayUsingPredicate:predicate];
    totalCredits = [credits valueForKeyPath:@"@sum.value"];
    totalDebits = [debits valueForKeyPath:@"@sum.value"];
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    
    return balance;
}

- (NSDecimalNumber *)sumCreditsFromDate:(NSDate *)initialDate toDate:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initialDate, finalDate];
    movements = [[self mutableArrayOfMovementsByType:0] filteredArrayUsingPredicate:predicate];
    sum = [movements valueForKeyPath:@"@sum.value"];
    
    return sum;
}

- (NSDecimalNumber *)sumDebitsFromDate:(NSDate *)initialDate toDate:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *movements;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initialDate, finalDate];
    movements = [[self mutableArrayOfMovementsByType:1] filteredArrayUsingPredicate:predicate];
    sum = [movements valueForKeyPath:@"@sum.value"];
    
    return sum;
}

@end
