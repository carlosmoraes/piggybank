//
//  DebitHistoryUITableViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "DebitsHistoryTableViewController.h"

@interface DebitsHistoryTableViewController ()

@end

@implementation DebitsHistoryTableViewController

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
    self.utilities = [[Utilities alloc] init];

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
    return self.debits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HistoryItemTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *credit = [self.debits objectAtIndex:indexPath.row];
    
    NSDecimalNumber *amount;
    amount = [credit valueForKey:@"amount"];
    cell.titleLabel.text = [self.utilities decimalNumberAsString: amount];
    
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@", [credit valueForKey:@"desc"]];
    
    NSDate *date = [credit valueForKey:@"date"];
    NSString *dateString = [self.utilities dateToFortmat:date :0];
    cell.dateLabel.text = dateString;
    
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
        NSManagedObject *item = [self.debits objectAtIndex:indexPath.row];
        NSManagedObjectContext *context = [self.utilities managedObjectContext];
        [context deleteObject:item];
        
        NSError *error;
        if (![context save:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"App" message:@"sorry the item cannot be deleted" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }else{
            [self.debits removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
