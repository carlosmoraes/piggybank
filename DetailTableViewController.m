//
//  DetailTableViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operations = [[TPBOperations alloc] init];
    
    if([self.movementType  isEqual: @"Credit"])
    {
        self.movements = [[self.operations arrayOfCreditsFromDate:self.currentMonth  toDate:self.nextMonth] mutableCopy];
    } else if([self.movementType  isEqual: @"Debit"])
    {
        self.movements  = [[self.operations arrayOfDebitsFromDate:self.currentMonth  toDate:self.nextMonth] mutableCopy];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // return 0;
    return self.movements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailItemTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *movement = [self.movements objectAtIndex:indexPath.row];
    NSDecimalNumber *value;
    value = [movement valueForKey:@"value"];
    cell.valueLabel.text = [self.operations stringByDecimalNumber: value];
    
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@", [movement valueForKey:@"desc"]];
    
    NSDate *date = [movement valueForKey:@"date"];
    NSString *stringDate = [self.operations stringFromDate:date toFormat:0];
    cell.dateLabel.text = stringDate;
    
    return cell;
    
    // static NSString *CellIdentifier = @"Cell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // NSManagedObject *debit = [self.debits objectAtIndex:indexPath.row];
    // [cell.textLabel setText:[NSString stringWithFormat:@"%@", [debit valueForKey:@"amount"]]];
    // [cell.detailTextLabel setText:[debit valueForKey:@"desc"]];
    
    // return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *movement = [self.movements objectAtIndex:indexPath.row];
        NSManagedObjectContext *moc = [self.operations managedObjectContext];
        [moc deleteObject:movement];
        
        NSError *error;
        if (![moc save:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"App" message:@"Sorry, the item cannot be deleted" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }else{
            [self.movements removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"edit"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        EditMovementViewController *emvc =  segue.destinationViewController;
        
        if (emvc)
        {
            emvc.movement =  [self.movements objectAtIndex:indexPath.row];
            emvc.movementType = self.movementType;
        }
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
