//
//  PracticeContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "PracticeContentViewController.h"
#import "PracticeViewController.h"

@interface PracticeContentViewController ()

@end

@implementation PracticeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    //Static Data
    topicArray = [[NSMutableArray alloc] init];
    [topicArray addObject:@"Major Scale"];
    [topicArray addObject:@"Natural Minor Scale"];
    [topicArray addObject:@"Harmonic Minor Scale"];
    [topicArray addObject:@"Melodic Minor Scale"];
    [topicArray addObject:@"Diminished Scale"];
    [topicArray addObject:@"Whole Tone Scale"];
    [topicArray addObject:@"Dorian Mode"];
    [topicArray addObject:@"Phrygian Mode"];
    
    
    tagArray = [[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
    valueArray = (NSMutableArray*)tagArray;
    
    currentTag = [[NSString alloc] init];
    
    
    //Establishing Screen Size
    /*
     int iWidth = [[UIScreen mainScreen] bounds].size.width;
     int iHeight = [[UIScreen mainScreen] bounds].size.height;
     int iTabHeight = [[[self tabBarController] tabBar] bounds].size.height;
     NSLog(@"w=%d, h=%d, t=%d", iWidth, iHeight, iTabHeight);
     */
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==topicTableView)
    {
        iCnt = [topicArray count];
    }
    else if (tableView==tagTableView)
    {
        iCnt = [tagArray count];
    }
    else if (tableView==valueTableView)
    {
        iCnt = [valueArray count];
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
    
    if (tableView==topicTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        if(cell != nil)
        {
            cell.textLabel.text = (NSString*)[topicArray objectAtIndex:indexPath.row];
        }
    }
    else if (tableView==tagTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
        if(cell != nil)
        {
            NSString *tag = [tagArray objectAtIndex:indexPath.row];
            cell.textLabel.text = tag;
            
            if ([[dataStore.currentSession allKeys] containsObject:tag]) {
                cell.detailTextLabel.text = dataStore.currentSession[tag];
            }
            else
            {
                cell.detailTextLabel.text = @"[ None ]";
            }
        }
    }
    else if (tableView==valueTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
        if(cell != nil)
        {
            cell.textLabel.text =(NSString*)[valueArray objectAtIndex:indexPath.row];
        }
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    
    if (tableView==topicTableView)
    {
        //Get user topic choice
        NSString  *topic = [topicArray objectAtIndex:indexPath.row];
        topicDisplayLabel.text = topic;
        topicDisplayLabelTwo.text = topic;
        topicDisplayLabelThree.text = topic;
        
        //Store in seesion object (dict)
        dataStore.currentSession[@"topic"] = topic;
        
        //Scroll to next screen
        PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        practiceViewController.iDisplayMode = 600;
        [practiceViewController setScrollView];
    }
    else if (tableView==tagTableView)
    {
        //Get user tag choice, display and save to session
        currentTag = [tagArray objectAtIndex:indexPath.row];
        tagDisplayLabel.text = currentTag;
        
        //Display values in value table
        valueArray = (NSMutableArray*)[dataStore.tagData[currentTag] mutableCopy];
        [valueTableView reloadData];
        
        //Scroll to next screen
        PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        practiceViewController.iDisplayMode = 1200;
        [practiceViewController setScrollView];
    }
    else if (tableView==valueTableView)
    {
        //Get user value choice, save to current session
        NSString  *value = [valueArray objectAtIndex:indexPath.row];
        dataStore.currentSession[[currentTag copy]] = [value copy];
        
        
        //Display amended values in tag table
        [tagTableView reloadData];
        
        //Scroll to next screen
        PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        practiceViewController.iDisplayMode = 600;
        [practiceViewController setScrollView];
    }
}


-(IBAction)onClick:(UIButton *)button
{
    PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
    
    int tag = (int)button.tag;
    
    if(tag == 1) //Cancel from tag, Back to topic stage
    {
        [topicTableView reloadData];
        practiceViewController.iDisplayMode = 0;
    }
    else if(tag == 2) //Cancel from value, Back value to tag stage
    {
        [tagTableView reloadData];
        practiceViewController.iDisplayMode = 600;
    }
    else if(tag == 3) // Begin practice stage
    {
        
        //Set the current date and time
        //NSDate *currentDate = [NSDate date];
        dataStore.startDateTime  = [NSDate date];
        
        //Create format for date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (dateFormatter != nil)
        {
            [dateFormatter setDateFormat:@"M/dd/YY"];
        }
        
        //Build the date into a string based on my day format
        NSString *dateString = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate: dataStore.startDateTime]];
        
        //Create format for times
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"h:mm a"];
        
        //Build the start time into a string based on my time format
        NSString *timeString = [[NSString alloc] initWithFormat:@"%@", [timeFormatter stringFromDate: dataStore.startDateTime]];
        
        //Save date/time tage in current session object
        [dataStore.currentSession setValue:dateString forKey:@"date"];
        [dataStore.currentSession setValue:timeString forKey:@"time"];
        
        //Scroll to practice screen
        practiceViewController.iDisplayMode = 1800;
    }
    else if(tag == 4) //Complete practice, back to top
    {
        
        //Caluculate & store duration in session
        NSDate *endDateTime = [NSDate date];
        int iMinutes = 0;
        int iSeconds = 0;
        int iTotalSeconds = [endDateTime timeIntervalSinceDate:dataStore.startDateTime];
        if(iTotalSeconds > 59)
        {
            iMinutes = iTotalSeconds/60;
            iSeconds = 60 % iTotalSeconds;
        }else
        {
            iMinutes = 0;
            iSeconds = iTotalSeconds;
        }
        NSString *sDuration = [[NSString alloc] initWithFormat:@"%d: min %d sec",iMinutes, iSeconds];
        [dataStore.currentSession setValue:sDuration forKey:@"duration"];

        //Store current session in sessions, & clear for next round..
        [dataStore.sessions addObject:[dataStore.currentSession mutableCopy]];
        
        
        //Clean up for next round
        [dataStore.currentSession removeAllObjects];

        
        //Scroll back to topic, then flip to History tab
        [topicTableView reloadData];
        [tagTableView reloadData];
        
        practiceViewController.iDisplayMode = 0;
        [self.tabBarController setSelectedIndex:1];
    }
        [practiceViewController setScrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
