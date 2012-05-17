//
//  HistoryViewController.m
//  WebGLViewer
//
//  Created by Troy Ferrell on 3/25/12.
//  Copyright (c) 2012 Troy Ferrell. All rights reserved.
//

#import "HistoryViewController.h"

#import "WebGLViewController.h"

@interface HistoryViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation HistoryViewController

@synthesize detailViewController = _detailViewController;
@synthesize historyTableView = _historyTableView;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = NSLocalizedString(@"History", @"History");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHistory];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    /*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction) clearButtonPressed:(id)sender
{
    // Clear all data
    [_objects removeAllObjects];
    
    // Ensure saved data bank is cleared
    [self saveHistory];
    
    // Reload GUI with no rows
    [self.historyTableView reloadData];
}

- (void) addURLToHistory:(NSString *)urlStr
{
    [_objects insertObject:urlStr atIndex:0];
    
    [self saveHistory];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.historyTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _objects.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSString *url = [_objects objectAtIndex:indexPath.row];
    NSLog(@"%@", url);
    cell.textLabel.text = url;
    
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Remove row from data storage
        NSString *removeStr = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
        [_objects removeObject:removeStr];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
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
     [detailViewController release];
     */
    
    NSString *url = [_objects objectAtIndex:indexPath.row];
    [self.detailViewController loadPage:url];
    
    /*
    NSDate *object = [_objects objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
	    if (!self.detailViewController) 
        {
	        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil] autorelease];
	    }
	    
        self.detailViewController.detailItem = object;
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } 
    else 
    {
        self.detailViewController.detailItem = object;
    }*/
}

- (void) saveHistory
{
	//NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	//[dataArray addObject:[NSNumber numberWithBool:PlaySound]];
	//[dataArray addObject:[NSNumber numberWithInt:DiffLvl]];
	
	[_objects writeToFile: [self dataFilePath] atomically:YES];
}

- (void) loadHistory
{
	if([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]])
	{
        _objects = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath]];
		
		//PlaySound =		 [[loadArray objectAtIndex:0] boolValue];
		//DiffLvl =		 [[loadArray objectAtIndex:1] intValue];
	}
    else 
    {
        _objects = [[NSMutableArray alloc] init];
    }
}

- (NSString *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"historydata.plist"];
}

- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [_historyTableView release];
    [super dealloc];
}

@end
