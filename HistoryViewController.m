//
//  History.m
//  Piggy Bank
//
//  Created by OZZE on 11/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)nextMonth:(id)sender
{
    [self changeMonth:1];
    [self viewDidAppear:(true)];
}

- (IBAction)previousMonth:(id)sender
{
    [self changeMonth:-1];
    [self viewDidAppear:(true)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    Utilities *util = self.utilities;
    self.monthLabel.text = self.monthLabel.text = [util dateToFortmat:self.currentMonth :1];
    
    NSDecimalNumber *monthCredits;
    monthCredits = [util sumCredits:self.currentMonth byPeriod:self.nextMonth];
    self.creditLabel.text = [util decimalNumberAsString: monthCredits];
    
    NSDecimalNumber *monthDebits;
    monthDebits = [util sumDebits:self.currentMonth byPeriod:self.nextMonth];
    self.debitLabel.text = [util decimalNumberAsString: monthDebits];
    
    NSDecimalNumber *balance;
    balance = [util calculateBalance:self.currentMonth byPeriod:self.nextMonth];
    self.balanceLabel.text = [util decimalNumberAsString: balance];
}

-(void) changeMonth:(NSInteger)byAmount // Change month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    [dateComponents setDay:1];
    NSDate *oldDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:byAmount];
    NSDate *newDate = [calendar dateByAddingComponents:oneMonth toDate:oldDate options:0];
    self.currentMonth = newDate;
    
    // Set the beggining of following month for Predicate
    [oneMonth setMonth:1];
    NSDate *beginningOfFollowingMonth = [calendar dateByAddingComponents:oneMonth toDate:newDate options:0];
    self.nextMonth = beginningOfFollowingMonth;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"creditHistory"]) {
        CreditHistoryUITableViewController *creditHistoryUITableViewController = [segue destinationViewController];
        creditHistoryUITableViewController.credits = [self.utilities credits:self.currentMonth  byPeriod:self.nextMonth];
    }
    
    if ([[segue identifier] isEqualToString:@"debitHistory"]) {
        DebitHistoryUITableViewController *debitHistoryUITableViewController = [segue destinationViewController];
        debitHistoryUITableViewController.debits = [self.utilities debits:self.currentMonth  byPeriod:self.nextMonth];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentMonth = [NSDate date];
    [self changeMonth:0];
    self.utilities = [[Utilities alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
