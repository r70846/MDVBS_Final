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
    
    //Local copy of sessionss data
    sessions = [[NSMutableArray alloc] init];
    lookupTable = [[NSMutableDictionary alloc] init];
    [self copySessionData];
    
    //Setup Interface Items
    [self setUpSortSheet];
    [self setUpFilterSheet];
}

-(void)copySessionData{
    sessions = dataStore.sessions;
    [dataStore.topicFilter removeAllObjects];
    [lookupTable removeAllObjects];
    
    for(int i = 0; i < [dataStore.sessions count]; i++){
        NSString *sTopic;
        NSString *sCount;
        NSString *index = [NSString stringWithFormat:@"%d",i];
        NSMutableDictionary *session = [dataStore.sessions objectAtIndex:i];
        lookupTable[session] = index;
        sTopic = session[@"topic"];
        sCount = dataStore.topicFilter[sTopic];
            if(sCount == nil){
                dataStore.topicFilter[sTopic] = @"0";
            }else{
                int count = [sCount intValue];
                count++;
                dataStore.topicFilter[sTopic] = [NSString stringWithFormat:@"%i",count];
            }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"History will appear..");
    [self copySessionData];
    [historyTableView reloadData];
}

-(void)loadSessions{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    
    if(dataStore.sessionsID){
        [query getObjectInBackgroundWithId:dataStore.sessionsID block:^(PFObject *sessionData, NSError *error) {
            if (!error) {
                // The find succeeded.
                dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                [self copySessionData];
                [historyTableView reloadData];
                NSLog(@"retrieved in practive view by ID");
            } else {
                // Log details of the failure
                NSLog(@"Error from topics by ID: %@ %@", error, [error userInfo]);
            }
        }];
        
    }else{
        
        NSLog(@"sessionsID: %@", dataStore.sessionsID);
        
        if(dataStore.sessionsID){
        }else{
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    // Do something with the found objects
                    PFObject *sessionData = [objects objectAtIndex:0];
                    dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                    dataStore.sessionsID = sessionData.objectId;
                    [self copySessionData];
                    [historyTableView reloadData];
                    NSLog(@"retrieved sessions in practive view without ID");
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==historyTableView)
    {
        iCnt = [sessions count];
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
            NSMutableDictionary *session = [sessions objectAtIndex:indexPath.row];
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
        detailSession = [sessions objectAtIndex:indexPath.row];
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
        //NSLog(@"Visible Index: %lu", (unsigned long)index);
        //NSLog(@"Actual Index: %@", [lookupTable objectForKey:[sessions objectAtIndex:index]]);
        int actualIndex = [[lookupTable objectForKey:[sessions objectAtIndex:index]] intValue];
        [dataStore.sessions removeObjectAtIndex:actualIndex];
        [dataStore saveSessions];
        [self copySessionData];
        [historyTableView reloadData];
    }
}
-(IBAction)onDel:(DelButton *)button{
    NSUInteger index = button.tag;
    if([button.type isEqualToString:@"HistoryCell"]){
        int actualIndex = [[lookupTable objectForKey:[sessions objectAtIndex:index]] intValue];
        [dataStore.sessions removeObjectAtIndex:actualIndex];
        [dataStore saveSessions];
        [self copySessionData];
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
    }else if(tag == 1){
        [sortActionSheet showInView:self.view];
    }else if(tag == 2){
        [filterActionSheet showInView:self.view];
    }
}

#pragma mark - Sort & Filter Functions


-(void)setUpFilterSheet
{
    
    NSArray *topics = [dataStore.topicFilter allKeys];
    
    //Build "actionsheet" as a drop down menu
    filterActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    //Tag it so I can add more later...
    filterActionSheet.tag = 200;
    
    //Add button for each topic in array
    for (NSString *topic in topics) {
        [filterActionSheet addButtonWithTitle:topic];
    }
    
    //Add cancel button on the end
    filterActionSheet.cancelButtonIndex = [filterActionSheet addButtonWithTitle:@"Cancel"];
    
    //To handle keyboard
    //[topicDisplay setDelegate:self];
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if(buttonIndex < [sortArray count]){
            
            if([[sortArray objectAtIndex:buttonIndex] isEqualToString:@"Sort by Date"]){
                sessions = (NSMutableArray*)[sessions sortedArrayUsingFunction:dateSort context:nil];
            }else if([[sortArray objectAtIndex:buttonIndex] isEqualToString:@"Sort by Topic"]){
                sessions = [self sortSessionsByTopic:sessions];
            }
        }else{
            //Cancel button
            [self copySessionData];
        }
        [historyTableView reloadData];
    }else if (actionSheet.tag == 200) {
        NSArray *topics = [dataStore.topicFilter allKeys];
        NSString *topic = [topics objectAtIndex:buttonIndex];
        NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
        if(buttonIndex == filterActionSheet.cancelButtonIndex){
            
        }else{
            sessions = dataStore.sessions;
            for(int i = 0; i < [sessions count]; i++){
                if([[sessions objectAtIndex:i][@"topic"] isEqualToString:topic]){
                     [filteredSessions addObject:[sessions objectAtIndex:i]];
                }
            }
            sessions = filteredSessions;
            [historyTableView reloadData];
        }
        
    }
    
}

- (NSMutableArray*)sortSessionsByTopic:(NSMutableArray *)array {
    array = (NSMutableArray*)[array sortedArrayUsingComparator:^(NSDictionary *item1, NSDictionary *item2) {
        NSString *topic1 = [item1 objectForKey:@"topic"];
        NSString *topic2 = [item2 objectForKey:@"topic"];
        return [topic1 compare:topic2 options: NSCaseInsensitiveSearch];
    }];
    return array;
}



NSComparisonResult dateSort(NSDictionary *item1, NSDictionary *item2, void *context){
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yy h:mm a"];
    
    NSString* string1 = [NSString stringWithFormat:@"%@ %@",[item1 objectForKey:@"date"], [item1 objectForKey:@"time"]];
    NSString* string2 = [NSString stringWithFormat:@"%@ %@",[item2 objectForKey:@"date"], [item2 objectForKey:@"time"]];
    
    NSDate *d1 = [df dateFromString:string1];
    NSDate *d2 = [df dateFromString:string2];
    return [d1 compare:d2];
}


@end
