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
    
    self.monthLabel.text = self.monthLabel.text = [self.operations stringFromDate:self.currentMonth toFormat:1];
    
    NSDecimalNumber *monthCredits;
    monthCredits = [self.operations sumCreditsFromDate:self.currentMonth toDate:self.nextMonth];
    self.creditLabel.text = [self.operations stringByDecimalNumber: monthCredits];
    
    NSDecimalNumber *monthDebits;
    monthDebits = [self.operations sumDebitsFromDate:self.currentMonth toDate:self.nextMonth];
    self.debitLabel.text = [self.operations stringByDecimalNumber: monthDebits];
    
    NSDecimalNumber *balance;
    balance = [self.operations calculateBalanceFromDate:self.currentMonth toDate:self.nextMonth];
    self.balanceLabel.text = [self.operations stringByDecimalNumber: balance];
}

-(void) changeMonth: (NSInteger)amount
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    [dateComponents setDay:1];
    NSDate *oldMonth = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:amount];
    NSDate *newMonth = [calendar dateByAddingComponents:oneMonth toDate:oldMonth options:0];
    
    self.currentMonth = newMonth;
    [oneMonth setMonth:1];
    
    NSDate *nextMonth = [calendar dateByAddingComponents:oneMonth toDate:newMonth options:0];
    self.nextMonth = nextMonth;
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
