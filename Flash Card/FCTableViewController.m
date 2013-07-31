//
//  FCTableViewController.m
//  Flash Card
//
//  Created by FeHe on 6/5/13.
//  Copyright (c) 2013 FeHe. All rights reserved.
//

#import "FCTableViewController.h"
#import "FCViewController.h"
#import "FCDataSource.h"
#import "FCFlashCell.h"

@interface FCTableViewController (){
    NSArray *flashCards;
}

@end

@implementation FCTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSManagedObjectContext *context = [[FCDataSource sharedDataSource] managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    flashCards = [context executeFetchRequest:fetch error:nil];
    //FlashCard *f = flashCards[1];
    //NSLog(@"%d %@",[flashCards count], f.eng);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [flashCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    FlashCard *word = [flashCards objectAtIndex:indexPath.row];
    FCFlashCell *wordCell = (FCFlashCell *)cell;
    wordCell.flashcard = word;
    wordCell.word.text = word.eng;
    return wordCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *cell = (UITableViewCell *)sender;
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        FCViewController *wordViewPage = segue.destinationViewController;
        wordViewPage.indexForFlashCards = indexPath.row;
        wordViewPage.wordsInFlashCard = [NSMutableArray arrayWithArray:flashCards];
    }
}

- (IBAction)refreshFlashCards:(id)sender{
    NSLog(@"refreshing %d", [flashCards count]);
    NSManagedObjectContext *context = [[FCDataSource sharedDataSource] managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    flashCards = [context executeFetchRequest:fetch error:nil];
    NSLog(@"after refresh %d",[flashCards count]);
    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)refresh{
    NSLog(@"refreshing %d", [flashCards count]);
    NSManagedObjectContext *context = [[FCDataSource sharedDataSource] managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    flashCards = [context executeFetchRequest:fetch error:nil];
    NSLog(@"after refresh %d",[flashCards count]);
    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
