///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//  PracticeContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "PracticeContentViewController.h"
#import "PracticeViewController.h"

@interface PracticeContentViewController ()

@end

@implementation PracticeContentViewController

#pragma mark - ViewController Setup 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //PFUser *user = [PFUser currentUser];
    //user.ACL = [PFACL ACLWithUser:user];
    //[PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];

    
    [self setUpAudio];
    

    
    //Appearance
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; ; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //create a week reference to self to avoid ARC retain cycle
    //[self.tabBarController setDelegate:[[self.tabBarController viewControllers] objectAtIndex:0]];
    
    [[UITabBar appearance] setTintColor:[UIColor darkGrayColor]];
    //[[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];

    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    //Setup tag templatea
    [dataStore loadTagTemplates];
    [self setUpTemplateSheet];
    
    //PFUser *user = [PFUser currentUser];
    //user.ACL = [PFACL ACLWithUser:user];
    //[PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
    
    [dataStore loadParseData];
    [self loadTopics];
    [self loadTags];
    [self loadSessions];
    
    //Settings
    dataStore.directDelete = FALSE;
    //dataStore.directDelete = TRUE;
    
    //Show or hide edit mode
    topicEditButton.hidden = dataStore.directDelete;
    tagEditButton.hidden = dataStore.directDelete;
    valueEditButton.hidden = dataStore.directDelete;
    
    //Pull tag array from dataStore dictionary
    //valueArray must be loaded dynamically with each tag choice
    dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
    valueArray = [[NSMutableArray alloc] init];
    
    // Vars for tracking state
    currentTag = [[NSString alloc] init];
    currentScreen = [[NSString alloc] init];
    currentScreen = @"Topic";
    
    //Set up Metronome
    [self setUpMetronome];
    
    //Set up drone
    [self setUpDrone];
    
    //Establishing Screen Size
    /*
     int iWidth = [[UIScreen mainScreen] bounds].size.width;
     int iHeight = [[UIScreen mainScreen] bounds].size.height;
     int iTabHeight = [[[self tabBarController] tabBar] bounds].size.height;
     NSLog(@"w=%d, h=%d, t=%d", iWidth, iHeight, iTabHeight);
     */
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([dataStore.tagTemplate isEqualToString:[dataStore.templateArray objectAtIndex:0]]){
        templateTextDisplay.text = @"[ Tag Templates ]";
    }else{
        templateTextDisplay.text = dataStore.tagTemplate;
    }
    if([templateTextDisplay.text isEqualToString:@""]){
        templateTextDisplay.text = @"[ Tag Templates ]";
    }
    
    //Reload data tables
    [topicTableView reloadData];
    [tagTableView reloadData];
    [valueTableView reloadData];
}

-(void)loadTopics{
    
    PFQuery *query = [PFQuery queryWithClassName:@"TopicData"];
    
    NSLog(@"topicsID: %@", dataStore.topicsID);
    
    if(dataStore.topicsID){
        [query getObjectInBackgroundWithId:dataStore.topicsID block:^(PFObject *topicData, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            if (!error) {
                // The find succeeded.
                dataStore.topicData = (NSMutableDictionary*)topicData[@"topicData"];
                dataStore.topicArray = (NSMutableArray*)[dataStore.topicData allKeys];
                [topicTableView reloadData];
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
            //for (PFObject *object in objects) {NSLog(@"%@", object.objectId);}
            
            //PFObject *topicData = [objects objectAtIndex:objects.count];
            PFObject *topicData = [objects objectAtIndex:0];
            dataStore.topicData = (NSMutableDictionary*)topicData[@"topicData"];
            dataStore.topicArray = (NSMutableArray*)[dataStore.topicData allKeys];
            dataStore.topicsID = topicData.objectId;
             NSLog(@"retrieved in practive view without ID");
            [topicTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
}
-(void)loadTags{
    
    PFQuery *query = [PFQuery queryWithClassName:@"TagData"];
    
    NSLog(@"tagsID: %@", dataStore.tagsID);
    
    if(dataStore.tagsID){
        [query getObjectInBackgroundWithId:dataStore.tagsID block:^(PFObject *tagData, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            if (!error) {
                // The find succeeded.
                dataStore.tagData = (NSMutableDictionary*)tagData[@"tagData"];
                [dataStore addTagsFromTemplate];
                dataStore.tagArray = (NSMutableArray*)[dataStore.tagData allKeys];
                [tagTableView reloadData];
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
                PFObject *tagData = [objects objectAtIndex:0];
                dataStore.tagData = (NSMutableDictionary*)tagData[@"tagData"];
                [dataStore addTagsFromTemplate];
                dataStore.tagArray = (NSMutableArray*)[dataStore.tagData allKeys];
                dataStore.tagsID = tagData.objectId;
                NSLog(@"retrieved in practive view without ID");
                [tagTableView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

-(void)loadSessions{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    
    if(dataStore.sessionsID){
        [query getObjectInBackgroundWithId:dataStore.sessionsID block:^(PFObject *sessionData, NSError *error) {
            if (!error) {
                // The find succeeded.
                dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                [dataStore loadTopicFilter];
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
                NSLog(@"retrieved sessions in practive view without ID");
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

#pragma mark - Data Cells Display 
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==topicTableView)
    {
        iCnt = [dataStore.topicArray count];
        //NSLog(@"TopicArray Count: %lu", (unsigned long)iCnt);
    }
    else if (tableView==tagTableView)
    {
        iCnt = [dataStore.tagArray count];
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

    
    if (tableView==topicTableView)
    {
        SimpleCell *cell;
        
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        if(cell != nil)
        {
            NSString *topic = (NSString*)[dataStore.topicArray objectAtIndex:indexPath.row];
            cell.displayText.text = topic;
            //[cell refreshCellWithInfo:@"WTF"];
        }
        cell.delButton.tag=indexPath.row;
        cell.delButton.type = @"TopicCell";
        cell.delButton.hidden = !dataStore.directDelete;
        return cell;
    }
    else if (tableView==tagTableView)
    {
        TagCell *cell;
        
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
        if(cell != nil)
        {
            NSString *tag = [dataStore.tagArray objectAtIndex:indexPath.row];
            
            if ([[dataStore.currentSession allKeys] containsObject:tag]) {
                
                //Cell Contents
                NSString *val = dataStore.currentSession[tag];
                
                //Cell color
                cell.backgroundColor =[UIColor colorWithRed:0.984 green:0.957 blue:0.875 alpha:1]; /*#fbf4df*/
                [cell refreshCellWithInfo:tag valtext:val];
            }
            else
            {
                //Cell Contents
                [cell refreshCellWithInfo:tag valtext:@"[ none ]"];
                //cell.detailTextLabel.text = @"[ None ]";
                
                //Cell color
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
            cell.delButton.tag=indexPath.row;
            cell.delButton.type = @"TagCell";
            cell.delButton.hidden = !dataStore.directDelete;
            return cell;
    }
    else if (tableView==valueTableView)
    {
            SimpleCell *cell;
        
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
        if(cell != nil)
        {
            NSString *priorValue = @"";
            NSString *thisValue = [valueArray objectAtIndex:indexPath.row];
            
                // If this tag was already set...
            if ([[dataStore.currentSession allKeys] containsObject:currentTag]) {
                // What was it set too (?)...
                priorValue = dataStore.currentSession[currentTag];
                if([thisValue isEqualToString:priorValue]){
                    //Cell color
                    cell.backgroundColor =[UIColor colorWithRed:0.984 green:0.957 blue:0.875 alpha:1]; /*#fbf4df*/
                }else{
                    cell.backgroundColor = [UIColor whiteColor];
                }
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            if(indexPath.row == 0){
                cell.displayText.text = @"[ none ]";
            }else{
                cell.displayText.text =(NSString*)[valueArray objectAtIndex:indexPath.row];
            }
        }
        cell.delButton.tag=indexPath.row;
        cell.delButton.type = @"ValueCell";
        cell.delButton.hidden = !dataStore.directDelete;
        return cell;
    }else{
            return nil;
    }

}

#pragma mark - Data Cells Select

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    
    if (tableView==topicTableView)
    {
        //Get user topic choice
        NSString  *topic = [dataStore.topicArray objectAtIndex:indexPath.row];
        topicDisplayLabel.text = topic;
        topicDisplayLabelTwo.text = topic;
        topicDisplayLabelThree.text = topic;
        
        //Store in seesion object (dict)
        dataStore.currentSession[@"topic"] = topic;
        
        //Make sure next screen is current
        [tagTableView reloadData];
        
        //Scroll to tag screen
        PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        practiceViewController.iDisplayMode = 600;
        [practiceViewController setScrollView];
    }
    else if (tableView==tagTableView)
    {
        //Get user tag choice, display and save to session
        currentTag = [dataStore.tagArray objectAtIndex:indexPath.row];
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
        if(indexPath.row == 0){
            [dataStore.currentSession removeObjectForKey:currentTag];
        }else{
            //Get user value choice, save to current session
            NSString  *value = [valueArray objectAtIndex:indexPath.row];
            dataStore.currentSession[currentTag] = [value copy];
        }

        //Display amended values in tag table
        [tagTableView reloadData];
        [valueTableView reloadData];
        
        //Scroll back to tag screen
        PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
        practiceViewController.iDisplayMode = 600;
        [practiceViewController setScrollView];

    }
}

#pragma mark - Data Cells Add

-(IBAction)addItemAction:(UIButton *)button{
    int tag = (int)button.tag;
    
    if(tag == 10){
        currentScreen = @"Topic";
        [self performSegueWithIdentifier:@"segueToNewItem" sender:self];
    }else if(tag == 11){
        currentScreen = @"Tag";
        [self performSegueWithIdentifier:@"segueToNewItem" sender:self];
    }else if(tag == 12){
        currentScreen = @"Value";
        [self performSegueWithIdentifier:@"segueToNewItem" sender:self];
    }else if(tag == 13){
        currentScreen = @"Note";
        [self performSegueWithIdentifier:@"segueToNewItem" sender:self];
    }
}

//This is called when we want to go to a new view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToNewItem"])
    {
        NewViewController *newViewController = segue.destinationViewController;
        newViewController.source = currentScreen;
    }
}

-(IBAction)returnNewItem:(UIStoryboardSegue *)segue
{
    
    if ([[segue identifier] isEqualToString:@"unwindFromNewInput"])
    {
        NewViewController *newViewController = segue.sourceViewController;
        NSString *source = newViewController.source;
        NSString *newItem = newViewController.input;
        
        if([source isEqualToString:@"Topic"]){
            //[dataStore.topicArray addObject:newItem];
            //[dataStore saveTopicArray];
            dataStore.topicData[newItem] = @"0";
            [dataStore saveTopics];
            [topicTableView reloadData];
        }else if([source isEqualToString:@"Cancel"]){
            //Do nothing
        }else if([source isEqualToString:@"Tag"]){
            //Create temp array to load dictionary
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            [tmpArray addObject:@"_user"];
            dataStore.tagData[newItem] = [tmpArray mutableCopy];
            dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
            [dataStore saveTags];
            [tagTableView reloadData];
        }else if([source isEqualToString:@"Value"]){
            [valueArray addObject:newItem];
            [valueArray replaceObjectAtIndex:0 withObject:@"_user"];
            dataStore.tagData[currentTag] = [valueArray mutableCopy];
            dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
            [dataStore saveTags];
            [valueTableView reloadData];
        }else if([source isEqualToString:@"Note"]){
            [dataStore.currentSession[@"notes"] addObject:newItem];
        }
    }
}

#pragma mark - Data Cells Delete

-(IBAction)editMode:(UIButton *)button{
    int tag = (int)button.tag;
    
    [self editButtonSwitch:button];
    
    if(tag == 10) //Topic view
    {
        [self editModeSwitch:topicTableView];
    }else if(tag == 11) //Tag view
    {
        [self editModeSwitch:tagTableView];
    }else if(tag == 12) //Value view
    {
        [self editModeSwitch:valueTableView];
    }
}

-(IBAction)onDel:(DelButton *)button{
    NSUInteger index = button.tag;
    if([button.type isEqualToString:@"TagCell"]){
        [dataStore.tagData removeObjectForKey:[dataStore.tagArray objectAtIndex:index]];
        dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
        [tagTableView reloadData];
        //NSLog(@"From View:%ld", (long)tag);
    }else if([button.type isEqualToString:@"TopicCell"]){
        //[dataStore.topicArray removeObjectAtIndex:index];
        //[dataStore saveTopicArray];
        [dataStore.topicData removeObjectForKey:[dataStore.topicArray objectAtIndex:index]];
        [dataStore saveTopics];
        [topicTableView reloadData];
    }else if([button.type isEqualToString:@"ValueCell"]){
        [valueArray removeObjectAtIndex:index];
        dataStore.tagData[currentTag] = [valueArray mutableCopy];
        [valueTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    
    if (tableView==topicTableView && editingStyle == UITableViewCellEditingStyleDelete){
        //[dataStore.topicArray removeObjectAtIndex:index];
        //[dataStore saveTopicArray];
        [dataStore.topicData removeObjectForKey:[dataStore.topicArray objectAtIndex:index]];
        NSLog(@"about to trigger topics save from practice...");
        [dataStore saveTopics];
        [topicTableView reloadData];
    }else if (tableView==tagTableView && editingStyle == UITableViewCellEditingStyleDelete){
        //remove from my local array
        [dataStore.tagData removeObjectForKey:[dataStore.tagArray objectAtIndex:index]];
        dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
        [dataStore saveTags];
        [tagTableView reloadData];
    }else if (tableView==valueTableView && editingStyle == UITableViewCellEditingStyleDelete){
        //remove from my local array
        [valueArray removeObjectAtIndex:index];
        [valueArray replaceObjectAtIndex:0 withObject:@"_user"];
        dataStore.tagData[currentTag] = [valueArray mutableCopy];
        [dataStore saveTags];
        [valueTableView reloadData];
    }
}

-(void)editModeSwitch:(UITableView *)table{
    if(table.isEditing){
        table.editing = false;
    }else{
        table.editing = true;
    }
}

-(void)editButtonSwitch:(UIButton *)button{
    if(button.backgroundColor == [UIColor redColor]){
        button.backgroundColor = [UIColor darkGrayColor];
    }else{
        button.backgroundColor = [UIColor redColor];
    }
}


#pragma mark - Session Functions

-(IBAction)navAction:(UIButton *)button{
    
    PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
    int tag = (int)button.tag;
    
    if(tag == 1) //Cancel from tag, Back to topic stage
    {
        //Clean up and start topic screen over
        [dataStore resetCurrentSession];
        
        [topicTableView reloadData];
        practiceViewController.iDisplayMode = 0;
        [practiceViewController setScrollView];
    }
    else if(tag == 2) //Cancel from value, Back value to tag stage
    {
        [tagTableView reloadData];
        practiceViewController.iDisplayMode = 600;
        [practiceViewController setScrollView];
    }
    else if(tag == 3) // Begin practice stage
    {
        [self sessionBegin];
        
        //Scroll to practice screen
        practiceViewController.iDisplayMode = 1800;
        [practiceViewController setScrollView];
    }
    else if(tag == 4) //Complete practice, back to top
    {
        if(bNome){
            [self runMetronome];
        }
        [self sessionComplete];
    }
}

-(void)sessionBegin{
    
    //Initialize Repetition Counter
    iTotalCount = 0;
    counterDisplay.text = [NSString stringWithFormat:@"%i",iTotalCount];
    
    [self initializeTimer];
    
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
    
    //Inititlaize time tracker on "begin"
    iTotalTime = 0;
    sDuration = [NSString stringWithFormat:@"%i min",iTotalTime];
    if(bDisplayTimer)
    {
        timerDisplay.text = sDuration;
    }
    
    //Launch repeating timer to run "Tick"
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(oneRound) userInfo:nil repeats:YES];
    
    //State Change
    bPractice = TRUE;
    
}

-(void)sessionComplete{
    
    //kill timer
    [durationTimer invalidate];
    
    //State Change
    bPractice = FALSE;
    
    //Caluculate total duration 'begin to complete'
    NSDate *endDateTime = [NSDate date];
    int iMinutes = 0;
    int iSeconds = 0;
    int iTotalSeconds = [endDateTime timeIntervalSinceDate:dataStore.startDateTime];
    if(iTotalSeconds > 59)
    {
        iMinutes = iTotalSeconds/60;
        iSeconds = iTotalSeconds % 60;
    }else
    {
        iMinutes = 0;
        iSeconds = iTotalSeconds;
    }
    
    //Save Data
    
    //Save total elapsed time included 'paused' time (Internal not for user dispaly)
    NSString *sTotalDuration = [[NSString alloc] initWithFormat:@"%d: min %d sec",iMinutes, iSeconds];
    [dataStore.currentSession setValue:sTotalDuration forKey:@"<<INTERNAL>>totalduration"];
    
    //Save final duration as text for user display
    [dataStore.currentSession setValue:sDuration forKey:@"duration"];
    
    PFFile *file = [self saveAudioSnippet];
    
    if(file != nil){
        [dataStore.currentSession setValue:file forKey:@"audio"];
    }
    
    //Store current session in sessions, & clear for next round..
    [dataStore.sessions addObject:[dataStore.currentSession mutableCopy]];
    [dataStore saveSessions];
    

    
    [dataStore loadTopicFilter];
    
    
    //Build string before reseting session
    if(dataStore.tweet){
        [self postTweet:[self composeTweet]];
    }
    
    [dataStore resetCurrentSession];
    [self resetPractice];
}


-(PFFile*)saveAudioSnippet{

    NSData* oData;
    PFFile *file = nil;
    NSError *error;
    NSString *path = dataStore.audioFileURL.path;
    NSFileManager *defaultManager;
    if([defaultManager fileExistsAtPath:path])
    {
        //Read content of file as data object
        oData = [NSData dataWithContentsOfFile:path];
        file = [PFFile fileWithName:@"snippet.m4a" data:oData];
        [file saveInBackground];
        
        //PFObject *audio = [PFObject objectWithClassName:@"Audio"];
        //audio[@"snippet"] = file;
        //[audio saveInBackground];
        
        [defaultManager removeItemAtPath:path error:&error];
        if(!error){
            audioState = [self updateAudioState:noaudio];
        }else{
            NSLog(@"%@", error.description);
        }
    }

    
    return file;
}

-(void)resetPractice{
    //Reload tables
    [topicTableView reloadData];
    [tagTableView reloadData];
    
    //Scroll back to topic, then flip to History tab
    PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
    practiceViewController.iDisplayMode = 0;
    [practiceViewController setScrollView];
    [self.tabBarController setSelectedIndex:1];
}
//////  Tweet Functins

-(NSString*)composeTweet{
    //Pull data from session dict object
    NSArray *keys = [dataStore.currentSession allKeys];
    NSString *keyString;
    NSString *valueString;
    NSMutableString *tweetString = (NSMutableString*)@"";
    
    
    keyString = @"topic";
    valueString = [[dataStore.currentSession objectForKey:keyString] lowercaseString];
    tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, keyString, valueString];
    keyString = @"date";
    valueString = [[dataStore.currentSession objectForKey:keyString] lowercaseString];
    tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, keyString, valueString];
    keyString = @"time";
    valueString = [[dataStore.currentSession objectForKey:keyString] lowercaseString];
    tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, keyString, valueString];
    keyString = @"duration";
    valueString = [[dataStore.currentSession objectForKey:keyString] lowercaseString];
    tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, keyString, valueString];
    
    int i;
    for(NSString *key in keys){
        if ([[key lowercaseString] isEqualToString:@"topic"]){
        }else if ([[key lowercaseString] isEqualToString:@"date"]){
        }else if ([[key lowercaseString] isEqualToString:@"time"]){
        }else if ([[key lowercaseString] isEqualToString:@"duration"]){
        }else if ([[key lowercaseString] isEqualToString:@"notes"]){
        }else if ([[key lowercaseString] isEqualToString:@"audio"]){
        }else if ([key rangeOfString:@"<<INTERNAL>>"].location == NSNotFound){
            keyString = [key lowercaseString];
            valueString = [[dataStore.currentSession objectForKey:key] lowercaseString];
            tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, keyString, valueString];
        }
    }
    
    NSMutableArray *notes = (NSMutableArray*)[dataStore.currentSession  objectForKey:@"notes"];
    
    for(i = 0; i < [notes count]; i++){
        tweetString = [NSMutableString stringWithFormat:@"%@%@ : %@\n", tweetString, @"note", [notes objectAtIndex:i]];
    }
    return tweetString;
}


-(void)postTweet:(NSString*)result{
    
    //Create built-in Specialized view ocntroller
    SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *tweet = [NSString stringWithFormat:@"%@\n%@", @"From the WoodShed:", result];
    [slComposeViewController addImage:[UIImage imageNamed:@"WS90.png"]];
    [slComposeViewController setInitialText:tweet];
    
    //Display view controllew
    [self presentViewController:slComposeViewController animated:true completion:nil];
}


-(IBAction)practiceAction:(UIButton *)button{
    int tag = (int)button.tag;
    
    if(tag == 5){
        [self displayTimer];
    }else if(tag == 6){
        [self pauseMode];
    }else if(tag == 7){
        [self runMetronome];
    }else if(tag == 8){
        iTotalCount++;
        counterDisplay.text = [NSString stringWithFormat:@"%i",iTotalCount];
    }else if(tag == 9){
        iTotalCount--;
        if(iTotalCount < 0){iTotalCount = 0;}
        counterDisplay.text = [NSString stringWithFormat:@"%i",iTotalCount];
    }
}

#pragma mark - Timer Functions

-(void)initializeTimer{
    //Initialize Duration Timer
    iTotalTime = 0;
    timerDisplay.text = @"-";
    bDisplayTimer = TRUE;
}

-(void)oneRound //Add one minute to timer
{
    if(bPractice){
        iTotalTime++;
        sDuration = [NSString stringWithFormat:@"%i min",iTotalTime];
    
        if(bDisplayTimer)
        {
            timerDisplay.text = sDuration;
        }
    }
}

//Support function fpr Practice Timer
-(void)displayTimer
{
        UIImage *closed = [UIImage imageNamed:@"eye-c-w-long.png"];
        UIImage *open = [UIImage imageNamed:@"eye-o-w-long.png"];
    if(bDisplayTimer)
    {
        
        [viewButton setImage:open forState: UIControlStateNormal];
        [viewButton setImage:open forState: UIControlStateApplication];
        [viewButton setImage:open forState: UIControlStateHighlighted];
        [viewButton setImage:open forState: UIControlStateReserved];
        [viewButton setImage:open forState: UIControlStateSelected];
        [viewButton setImage:open forState: UIControlStateDisabled];
        
        timerDisplay.text = @"-";
        bDisplayTimer = FALSE;
    }
    else
    {
        [viewButton setImage:closed forState: UIControlStateNormal];
        [viewButton setImage:closed forState: UIControlStateApplication];
        [viewButton setImage:closed forState: UIControlStateHighlighted];
        [viewButton setImage:closed forState: UIControlStateReserved];
        [viewButton setImage:closed forState: UIControlStateSelected];
        [viewButton setImage:closed forState: UIControlStateDisabled];
        
        timerDisplay.text = [NSString stringWithFormat:@"%i min",iTotalTime];
        bDisplayTimer = TRUE;
    }
}

-(void)pauseMode
{
    NSString *sMessage = @"";
    
    //Set varaiable to suspend practice
    bPractice = FALSE;
    
    //Create alert view
    UIAlertView *paused = [[UIAlertView alloc] initWithTitle:@"Practice Session Paused" message:sMessage delegate:self cancelButtonTitle:@"RESUME" otherButtonTitles:nil];

    //Display alert view
    [paused show];
    
}

// Release Practice Paused Alert View
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)  //[ RESUME ]
    {
        //Set varaiable to resume practice
        bPractice = TRUE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Metronome Functions

-(void)setUpMetronome
{
    //Initialize Metronome UI
    [self stepperChange:nil];
    
    //Create string to represent "click" resource path. Apparently must be done in this way (?)
    NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    
    //Create File URL based on string representation of "click" path
    NSURL *SoundURL = [NSURL fileURLWithPath:clickPath];
    
    //Create SoundID for "click" sound
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &Click);
    
    //Initialize metronome state variable
    bNome = FALSE;
}

-(void)runMetronome
{
    if(!bNome)
    {
        //Set "Beats Per Minute" to user's choice
        BPM = [nomeDisplay.text intValue];
        
        //Set time interval to BPM
        float interval = (float)60.00/(float)BPM;
        
        //Launch repeating timer to run "Tick"
        nomeTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(Beat) userInfo:nil repeats:YES];
        
        //Produce first click on button tap
        AudioServicesPlaySystemSound(Click);
        
        //Change state
        [nomeButton setTitle: @"OFF" forState: UIControlStateNormal];
        [nomeButton setTitle: @"OFF" forState: UIControlStateApplication];
        [nomeButton setTitle: @"OFF" forState: UIControlStateHighlighted];
        [nomeButton setTitle: @"OFF" forState: UIControlStateReserved];
        [nomeButton setTitle: @"OFF" forState: UIControlStateSelected];
        [nomeButton setTitle: @"OFF" forState: UIControlStateDisabled];
        bNome = TRUE;
    }
    else
    {
        //Stop timer
        [nomeTimer invalidate];
        
        //Change state
        [nomeButton setTitle: @"ON" forState: UIControlStateNormal];
        [nomeButton setTitle: @"ON" forState: UIControlStateApplication];
        [nomeButton setTitle: @"ON" forState: UIControlStateHighlighted];
        [nomeButton setTitle: @"ON" forState: UIControlStateReserved];
        [nomeButton setTitle: @"ON" forState: UIControlStateSelected];
        [nomeButton setTitle: @"ON" forState: UIControlStateDisabled];
        bNome = FALSE;
    }
}

//Support function for metronome
-(void)Beat  //Runs on each click
{
    if(bPractice){
        AudioServicesPlaySystemSound(Click);
    }

}

//Support function for metronome
- (IBAction)stepperChange:(UIStepper *)sender //Change BPM on metronome
{
    
    NSUInteger stepOne = stepperOne.value;
    NSUInteger stepTen = stepperTen.value;
    
    if(stepOne == 10)
    {
        stepperOne.value = 0;
        stepperTen.value = stepTen + 10;
    }
    if(stepOne == -1)
    {
        stepperOne.value = 9;
        stepperTen.value = stepTen - 10;
    }
    
    stepOne = stepperOne.value;
    stepTen = stepperTen.value;
    NSUInteger setting = stepOne + stepTen;
    nomeDisplay.text = [NSString stringWithFormat:@"%03lu",(unsigned long)setting];
    
    if(bNome)
    {
        //Kill active metronome
        [nomeTimer invalidate];
        
        //Change state
        bNome = FALSE;
        
        //Restart
        [self runMetronome];
    }
}

-(void)setUpTemplateSheet
{
    //Build "actionsheet" as a drop down menu
    templateSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil];
    //Tag it so I can add more later...
    templateSheet.tag = 100;
    
    //Add button for each topic in array
    for (NSString *template in dataStore.templateArray) {
        [templateSheet addButtonWithTitle:template];
    }
    
    //Add cancel button on the end
    templateSheet.cancelButtonIndex = [templateSheet addButtonWithTitle:@"Cancel"];
    

    if([dataStore.tagTemplate isEqualToString:[dataStore.templateArray objectAtIndex:0]]){
        templateTextDisplay.text = @"[ Tag Templates ]";
    }
    
    //To handle keyboard
    //[topicDisplay setDelegate:self];
    
    
}

-(IBAction)chooseTemplate
{
    [templateSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if(buttonIndex < [dataStore.templateArray count]){
            NSString *choice = [dataStore.templateArray objectAtIndex:buttonIndex];
            if(buttonIndex == 0){
                templateTextDisplay.text = @"[ Tag Templates ]";
            }else{
                templateTextDisplay.text = choice;
            }
            dataStore.tagTemplate = choice;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if(defaults != nil)
            {
                [defaults setObject:choice forKey:@"tagTemplate"];
            }
            [self loadTags];
            dataStore.tagArray = (NSMutableArray*)[[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
            [tagTableView reloadData];
        }
    }
}



// Drone tool
-(void)setUpDrone
{
    //Build array of 12 keys
    keyArray = [[NSMutableArray alloc] init];
    [keyArray addObject:@"A"];
    [keyArray addObject:@"A#"];
    [keyArray addObject:@"B"];
    [keyArray addObject:@"C"];
    [keyArray addObject:@"C#"];
    [keyArray addObject:@"D"];
    [keyArray addObject:@"D#"];
    [keyArray addObject:@"E"];
    [keyArray addObject:@"F"];
    [keyArray addObject:@"F#"];
    [keyArray addObject:@"G"];
    [keyArray addObject:@"G#"];
    
    //Display the tonic from the stepper
    droneDisplay.text = [NSString stringWithFormat:@"%@",[keyArray objectAtIndex:(int)droneStepper.value]];
    
    //Initialize drone state variable
    bDrone = FALSE;
}
    
//Start or Stop Drone Tone
-(IBAction)drone
{
    
    if(!bDrone)
    {
        NSError *error;
        
        //Get the tonic note from my array
        NSString *sTonic = [[NSString alloc] initWithFormat:@"%@", [keyArray objectAtIndex:(int)droneStepper.value]];
        
        //Create string to represent resource path.
        NSString *dronePath = [[NSBundle mainBundle] pathForResource:sTonic ofType:@"wav"];
        
        //Create File URL based on string representation of path
        NSURL *DroneURL = [NSURL fileURLWithPath:dronePath];
        
        //Point AVPlayers to File URL for wav file
        drone1 = [[AVAudioPlayer alloc] initWithContentsOfURL:DroneURL error:&error];
        drone2 = [[AVAudioPlayer alloc] initWithContentsOfURL:DroneURL error:&error];
        
        //Trigger Loop 1 of drone
        [drone1 setNumberOfLoops: -1];
        [drone1 prepareToPlay];
        
        //Trigger Loop 2 of drone
        [drone2 setNumberOfLoops: -1];
        [drone2 prepareToPlay];
        
        //Offset timing of two drone copies
        drone1.currentTime = 0;
        drone2.currentTime = 5;
        
        //Play drones
        [drone1 play];
        [drone2 play];
        
        //Change State
        [droneButton setTitle: @"OFF" forState: UIControlStateNormal];
        [droneButton setTitle: @"OFF" forState: UIControlStateApplication];
        [droneButton setTitle: @"OFF" forState: UIControlStateHighlighted];
        [droneButton setTitle: @"OFF" forState: UIControlStateReserved];
        [droneButton setTitle: @"OFF" forState: UIControlStateSelected];
        [droneButton setTitle: @"OFF" forState: UIControlStateDisabled];
        
        bDrone = TRUE;
    }
    else
    {
        //Stop Drone Audio
        [drone1 stop];
        [drone2 stop];
        
        //Reset drone audio playback
        drone1.currentTime = 0;
        drone2.currentTime = 5;
        
        //Change State
        [droneButton setTitle: @"ON" forState: UIControlStateNormal];
        [droneButton setTitle: @"ON" forState: UIControlStateApplication];
        [droneButton setTitle: @"ON" forState: UIControlStateHighlighted];
        [droneButton setTitle: @"ON" forState: UIControlStateReserved];
        [droneButton setTitle: @"ON" forState: UIControlStateSelected];
        [droneButton setTitle: @"ON" forState: UIControlStateDisabled];
        bDrone = FALSE;
    }
}


//Support function for Drone Tone
-(IBAction)droneStepperChange:(UIStepper *)sender;
{
    if(bDrone)
    {
        //Stop Drone Audio
        [drone1 stop];
        [drone2 stop];
        
        //Reset drone audio playback
        drone1.currentTime = 0;
        drone2.currentTime = 5;
        
        //Change State
        bDrone = FALSE;
        
        //Restart
        [self drone];
        
    }
    //Display the tonic note user has chosen
    droneDisplay.text = [NSString stringWithFormat:@"%@",[keyArray objectAtIndex:(int)droneStepper.value]];
}

//////////////////////////////

-(void)setUpAudio{
    
    stop = [UIImage imageNamed:@"icon-stop-48.png"];
    play = [UIImage imageNamed:@"icon-play-48.png"];
    pause = [UIImage imageNamed:@"icon-pause-48.png"];
    record = [UIImage imageNamed:@"icon-rec-48.png"];
    recordLit = [UIImage imageNamed:@"icon-rec-lit-48.png"];
    pauseLit = [UIImage imageNamed:@"icon-pause-lit-48.png"];
    
    // Create audio file and reference
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"snippet.m4a",
                               nil];
    dataStore.audioFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Audio session setup
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Audio recorder settings as dict object
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Prepare audio recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:dataStore.audioFileURL settings:recordSetting error:NULL];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
    
    // Initialize state variables
    audioState =  [self updateAudioState:noaudio];
}


- (IBAction)recordPauseAudio:(id)sender {
    
    if (audioState == noaudio || audioState == pausedRecording || audioState == audio) {  // Record
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        
        // Begin record
        [audioRecorder record];
        audioState =  [self updateAudioState:recording];
        
    } else if(audioState == recording && audioRecorder.recording){ // Pause
        
        //Pause record
        [audioRecorder pause];
        audioState =  [self updateAudioState:pausedRecording];
        
    } else if(audioState == playing && audioPlayer.playing){
        
        //Pause playback
        [audioPlayer pause];;
        audioState =  [self updateAudioState:pausedPlaying];
        
    } else if(audioState == pausedPlaying){
        
        //Pause playback
        [audioPlayer play];;
        audioState =  [self updateAudioState:playing];
    }
}


- (IBAction)playStopAudio:(id)sender {
    if (audioState == noaudio){
    } else if(audioState == audio){ //Play
        
        // Prepare & play audio
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:nil];
        [audioPlayer setDelegate:self];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        audioState =  [self updateAudioState:playing];
        
        self->audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                            target:self
                                                          selector:@selector(updateProgress)
                                                          userInfo:nil
                                                           repeats:YES];
        
    } else if(audioState == pausedPlaying){
        
        // Stop playback
        [audioPlayer stop];
        audioState =  [self updateAudioState:audio];
        
    } else if(audioState == recording || audioState == pausedRecording ){
        
        // Stop record
        [audioRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        audioState =  [self updateAudioState:audio];
        
    } else if(audioState == playing || audioState == pausedPlaying ){
        
        // Stop playback
        [audioPlayer stop];
        audioState =  [self updateAudioState:audio];
    }
}

-(AudioState)updateAudioState:(AudioState)state{
    
    NSString *placeHolder =  @"__________________";
    
    switch (state)
    {
        case noaudio:
            [btnRecPause setImage:record forState: UIControlStateNormal];
            [btnPlayStop setImage:stop forState: UIControlStateNormal];
            btnDeleteAudio.hidden = true;
            audioProgress.hidden = true;
            audioMessage.text = placeHolder;
            break;
        case audio:
            [btnRecPause setImage:record forState: UIControlStateNormal];
            [btnPlayStop setImage:play forState: UIControlStateNormal];
            btnDeleteAudio.hidden = false;
            audioProgress.hidden = true;
            audioMessage.text = placeHolder;
            break;
        case recording:;
            [btnRecPause setImage:pause forState: UIControlStateNormal];
            [btnPlayStop setImage:stop forState: UIControlStateNormal];
            btnDeleteAudio.hidden = true;
            audioProgress.hidden = true;
            audioMessage.text = @"recording";
            break;
        case pausedRecording:
            [btnRecPause setImage:pauseLit forState: UIControlStateNormal];
            [btnPlayStop setImage:stop forState: UIControlStateNormal];
            btnDeleteAudio.hidden = true;
            audioProgress.hidden = true;
            audioMessage.text = @"recording paused";
            break;
        case playing:
            [btnRecPause setImage:pause forState: UIControlStateNormal];
            [btnPlayStop setImage:stop forState: UIControlStateNormal];
            btnDeleteAudio.hidden = true;
            audioProgress.hidden = false;
            audioMessage.text = placeHolder;
            break;
        case pausedPlaying:
            [btnRecPause setImage:pauseLit forState: UIControlStateNormal];
            [btnPlayStop setImage:stop forState: UIControlStateNormal];
            btnDeleteAudio.hidden = true;
            audioProgress.hidden = true;
            audioMessage.text = @"paused playback";
            break;
    }
    return state;
}

- (IBAction)deleteAudio:(id)sender{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:dataStore.audioFileURL.path error:&error];
    if(!error){
        audioState = [self updateAudioState:noaudio];
    }else{
        NSLog(@"%@", error.description);
    }
}


- (void)updateProgress
{
    float remaining = audioPlayer.currentTime/audioPlayer.duration;
    
    // upate the UIProgress
    
    audioProgress.progress= remaining;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    // Change State
    audioState =  [self updateAudioState:audio];
}

@end

