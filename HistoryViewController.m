//
//  HistoryViewController.m
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
    
    TPBOperations *util = self.operations;
    self.monthLabel.text = self.monthLabel.text = [util stringFromDate:self.currentMonth toFormat:1];
    
    NSDecimalNumber *totalMonthCredits;
    totalMonthCredits = [util sumCreditsFromDate:self.currentMonth toDate:self.nextMonth];
    self.creditLabel.text = [util stringByDecimalNumber: totalMonthCredits];
    
    NSDecimalNumber *totalMonthDebits;
    totalMonthDebits = [util sumDebitsFromDate:self.currentMonth toDate:self.nextMonth];
    self.debitLabel.text = [util stringByDecimalNumber: totalMonthDebits];
    
    NSDecimalNumber *balance;
    balance = [util calculateBalanceFromDate:self.currentMonth toDate:self.nextMonth];
    self.balanceLabel.text = [util stringByDecimalNumber: balance];
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
        DetailTableViewController *dtvc = [segue destinationViewController];
        dtvc.movementType = @"Credit";
        dtvc.currentMonth = self.currentMonth;
        dtvc.nextMonth = self.nextMonth;
    }
    
    if ([[segue identifier] isEqualToString:@"debitHistory"]) {
        DetailTableViewController *dtvc = [segue destinationViewController];
        dtvc.movementType = @"Debit";
        dtvc.currentMonth = self.currentMonth;
        dtvc.nextMonth = self.nextMonth;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentMonth = [NSDate date];
    [self changeMonth:0];
    self.operations = [[TPBOperations alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
