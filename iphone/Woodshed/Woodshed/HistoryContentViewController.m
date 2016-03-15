///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  HistoryContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "HistoryContentViewController.h"
#import "HistoryViewController.h"
#import "TagCell.h"
#import "DelButton.h"

@interface HistoryContentViewController ()

@end

@implementation HistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; ; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    //Show or hide edit mode
    historyEditButton.hidden = dataStore.directDelete;
    
    //Local RAM storage for table displays
    tagArray = [[NSMutableArray alloc] init];
    valueArray = [[NSMutableArray alloc] init];

    //Setup Interface Items
    [self setUpSortSheet];
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"History will appear..");
    
    [historyTableView reloadData];
}

-(void)loadSessions{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    
    if(dataStore.sessionsID){
        [query getObjectInBackgroundWithId:dataStore.sessionsID block:^(PFObject *sessionData, NSError *error) {
            if (!error) {
                // The find succeeded.
                dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                [historyTableView reloadData];
                NSLog(@"retrieved in practive view by ID");
            } else {
                // Log details of the failure
                NSLog(@"Error from topics by ID: %@ %@", error, [error userInfo]);
            }
        }];
        
    }else{
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                // Do something with the found objects
                PFObject *sessionData = [objects objectAtIndex:0];
                dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                dataStore.sessionsID = sessionData.objectId;
                [historyTableView reloadData];
                NSLog(@"retrieved sessions in practive view without ID");
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==historyTableView)
    {
        iCnt = [dataStore.sessions count];
    }
    else if (tableView==detailTableView)
    {
        iCnt = [tagArray count];
    }
    else
    {
        iCnt = 0;
    }
    return iCnt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tableView==historyTableView)
    {
        HistoryCell *cell;
        
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        if(cell != nil)
        {
            //Get data
            NSMutableDictionary *session = [dataStore.sessions objectAtIndex:indexPath.row];
            NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[session objectForKey:@"date"], [session objectForKey:@"time"]];
            
            //Load cell
            //cell.textLabel.text = [session objectForKey:@"topic"];
            //cell.detailTextLabel.text = dateTime;
            NSString *topic = [session objectForKey:@"topic"];
            [cell refreshCellWithInfo:topic dateText:dateTime];
        }
        cell.delButton.tag=indexPath.row;
        cell.delButton.type = @"HistoryCell";
        cell.delButton.hidden = !dataStore.directDelete;
        return cell;
    }
    else if (tableView==detailTableView)
    {
        TagCell *cell;
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        if(cell != nil)
        {
            //cell.textLabel.text = (NSString*)[tagArray objectAtIndex:indexPath.row];
            //cell.detailTextLabel.text = (NSString*)[valueArray objectAtIndex:indexPath.row];
            
            NSString *tag = (NSString*)[tagArray objectAtIndex:indexPath.row];
            NSString *val = (NSString*)[valueArray objectAtIndex:indexPath.row];
            
            [cell refreshCellWithInfo:tag valtext:val];
        }
        cell.delButton.tag=indexPath.row;
        cell.delButton.type = @"DetailCell";
        cell.delButton.hidden = true;
        return cell;
    }else{
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    
    if (tableView==historyTableView)
    {
        //Get data
        detailSession = [dataStore.sessions objectAtIndex:indexPath.row];
           NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[detailSession objectForKey:@"date"], [detailSession objectForKey:@"time"]];
        
        topicDisplayLabel.text = [detailSession objectForKey:@"topic"];
        dateTimeDisplayLabel.text = dateTime;

        //Clear my arrays
        [tagArray removeAllObjects];
        [valueArray removeAllObjects];
        
        //Pull data from session dict object
        NSArray *keys = [detailSession allKeys];
        //NSArray *values = [detailSession allValues];
        int i;
        for(NSString *key in keys){
            
            if ([[key lowercaseString] isEqualToString:@"topic"]){
            }else if ([[key lowercaseString] isEqualToString:@"date"]){
            }else if ([[key lowercaseString] isEqualToString:@"time"]){
            }else if ([[key lowercaseString] isEqualToString:@"notes"]){
                    NSLog(@"notes detected...");
            }else if ([key rangeOfString:@"<<INTERNAL>>"].location == NSNotFound){
                [tagArray addObject:[key lowercaseString]];
                [valueArray addObject:[[detailSession objectForKey:key] lowercaseString]];
            }else{
                //Internal records. not for user display
                //[tagArray addObject:[key lowercaseString]];
                //[valueArray addObject:[[detailSession objectForKey:key] lowercaseString]];
            }
        }
        
        NSMutableArray *notes = (NSMutableArray*)[detailSession objectForKey:@"notes"];
        
        NSLog(@"About to load notes...");
        
        for(i = 0; i < [notes count]; i++){
            [tagArray addObject:@"note"];
            [valueArray addObject:[notes objectAtIndex:i]];
        }
        
        
        [detailTableView reloadData];
        
        //Scroll to next screen
        HistoryViewController *historyViewController = (HistoryViewController*) self.parentViewController;
        historyViewController.iDisplayMode = 600;
        [historyViewController setScrollView];
    }
    else if (tableView==detailTableView)
    {
        //Do nothing
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpSortSheet
{
    
    //Create Array to hold all possible topics
    sortArray = [[NSMutableArray alloc] init];
    [sortArray addObject:@"Sort by Topic"];
    [sortArray addObject:@"Sort by Date"];
    
    //Build "actionsheet" as a drop down menu
    sortActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    //Tag it so I can add more later...
    sortActionSheet.tag = 100;
    
    //Add button for each topic in array
    for (NSString *sort in sortArray) {
        [sortActionSheet addButtonWithTitle:sort];
    }
    
    //Add cancel button on the end
    sortActionSheet.cancelButtonIndex = [sortActionSheet addButtonWithTitle:@"Cancel"];
    
    //To handle keyboard
    //[topicDisplay setDelegate:self];
}


-(IBAction)editMode:(UIButton *)button{
    if(historyTableView.isEditing){
        historyTableView.editing = false;
    }else{
        historyTableView.editing = true;
    }
    if(button.backgroundColor == [UIColor redColor]){
        button.backgroundColor = [UIColor darkGrayColor];
    }else{
        button.backgroundColor = [UIColor redColor];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    
    if (tableView==historyTableView && editingStyle == UITableViewCellEditingStyleDelete){
        [dataStore.sessions removeObjectAtIndex:index];
        [historyTableView reloadData];
    }
}
-(IBAction)onDel:(DelButton *)button{
    NSUInteger index = button.tag;
    if([button.type isEqualToString:@"HistoryCell"]){
        [dataStore.sessions removeObjectAtIndex:index];
        [historyTableView reloadData];
    }
}

-(IBAction)onClick:(UIButton *)button
{
    int tag = (int)button.tag;
    
    if(tag == 0) //Cancel from tag, Back to topic stage
    {
    HistoryViewController *historyViewController = (HistoryViewController*) self.parentViewController;
        historyViewController.iDisplayMode = 0;
        [historyViewController setScrollView];
    }else{
            [sortActionSheet showInView:self.view];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
