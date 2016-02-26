//
//  HistoryContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "HistoryContentViewController.h"
#import "HistoryViewController.h"

@interface HistoryContentViewController ()

@end

@implementation HistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    tagArray = [[NSMutableArray alloc] init];
    [tagArray addObject:@"Bowing Pattern"];
    [tagArray addObject:@"Key Center"];
    
    valueArray = [[NSMutableArray alloc] init];
    [valueArray addObject:@"Shuffle Bowing"];
    [valueArray addObject:@"A"];
    
    
    //Setup Interface Items
    [self setUpSortSheet];
}

- (void)viewWillAppear:(BOOL)animated {

    [historyTableView reloadData ];
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
    UITableViewCell *cell;
    
    if (tableView==historyTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        if(cell != nil)
        {
            //Get data
            NSMutableDictionary *session = [dataStore.sessions objectAtIndex:indexPath.row];
           NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[session objectForKey:@"date"], [session objectForKey:@"time"]];
            
            //Load cell
            cell.textLabel.text = [session objectForKey:@"topic"];
            cell.detailTextLabel.text = dateTime;
           
        }
    }
    else if (tableView==detailTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        if(cell != nil)
        {
            cell.textLabel.text = (NSString*)[tagArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = (NSString*)[valueArray objectAtIndex:indexPath.row];
        }
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    
    if (tableView==historyTableView)
    {
        //Get data
        NSMutableDictionary *session = [dataStore.sessions objectAtIndex:indexPath.row];
           NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[session objectForKey:@"date"], [session objectForKey:@"time"]];
        
        topicDisplayLabel.text = [session objectForKey:@"topic"];
        dateTimeDisplayLabel.text = dateTime;

        
        //Scroll to next screen
        HistoryViewController *historyViewController = (HistoryViewController*) self.parentViewController;
        historyViewController.iDisplayMode = 600;
        [historyViewController setScrollView];
    }
    else if (tableView==detailTableView)
    {
        //Scroll to next screen
        //PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        //practiceViewController.iDisplayMode = 600;
        //[practiceViewController setScrollView];
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
