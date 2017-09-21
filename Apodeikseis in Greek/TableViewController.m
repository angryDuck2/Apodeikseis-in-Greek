//
//  TableViewController.m
//  Forologia
//
//  Created by Aggelos Papageorgiou on 31/8/12.
//  Copyright (c) 2012 Aggelos Papageorgiou. All rights reserved.
//

#import "TableViewController.h"
#import "MyTableList.h"
#import "TableList.h"
#import "ViewTableReceiptViewController.h"


@interface TableViewController ()
@property (nonatomic,retain) MyTableList *newTable;

@end

@implementation TableViewController



-(MyTableList*)newTable{
    if (!_newTable) {
        _newTable=[[MyTableList alloc]init];
        
    }
    return _newTable;
}
NSMutableArray* indexArray;
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
    self.tableView.delegate=self;

    indexArray=[[NSMutableArray alloc]init];
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    i=0;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - Table view data source


   

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    
    
    return 1 ;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    int rows=[self.newTable getRowCount];
    
    return rows;
}
int i=0;



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
        
    
    NSString *CellIdentifier = @"apodeikseisTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
     
    
    if (i<[self.newTable getRowCount]) {
    
    
    
       NSMutableArray* primeArray =[[NSMutableArray alloc]init];
       primeArray=[self.newTable getReceipt];
       cell.tag=((TableList*)[primeArray objectAtIndex:i]).mainReceiptId ;
       [ cell.textLabel setText:((TableList *) [primeArray objectAtIndex:indexPath.row]).mainName];
       NSDate* Date=[[NSDate alloc] init];
       Date=((TableList*)[primeArray objectAtIndex:indexPath.row]).mainDate ;
       NSDateFormatter* mainFormat=[[NSDateFormatter alloc]init];
       [mainFormat setDateFormat:@"dd-MM-yyyy"];
        
                
        
        
        
        [cell.detailTextLabel setText:[mainFormat stringFromDate:Date]];
    // Configure the cell...
        i++;
    }
    
    return cell;
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:YES animated:YES];
    UIBarButtonItem* trashIcon=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteRows)];
    
    [self.navigationItem setLeftBarButtonItem:trashIcon];
    if (!editing || [self.tableView numberOfRowsInSection:0]==0) {
        [super setEditing:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem];
    }
    
    
}

-(void)deleteRows{
    for (int j=0; j<([indexArray count]); j++) {
        
        UITableViewCell* tempCell=(UITableViewCell*)[self.tableView cellForRowAtIndexPath:[indexArray objectAtIndex:j]];
        [self.newTable DeleteRecords:tempCell.tag];
    }
    [self.tableView deleteRowsAtIndexPaths:indexArray
                     withRowAnimation:UITableViewRowAnimationLeft];
    if ([self.tableView numberOfRowsInSection:0]==0) {
        [self.tableView setEditing:NO animated:YES];
    }
    [indexArray removeAllObjects];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

 


                                                                                                                                    


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int newOne=[self.tableView indexPathForCell:sender ].row;
    [prefs setInteger:newOne forKey:@"tag"];
    

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
;
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   UITableViewCell* currentCell=(UITableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    if (![self.tableView isEditing]) {
        
        [self performSegueWithIdentifier:@"EntrySegue" sender:currentCell];
        
        
        
        
        
    }else{
        [indexArray addObject:indexPath];
    }

    
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [[init alloc] initWithNibName:@";" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
