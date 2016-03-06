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
    
    //Pull tag array from dataStore dictionary
    //valueArray must be loaded dynamically with each tag choice
    tagArray = [[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
    valueArray = [[NSMutableArray alloc] init];
    
    // Vars for tracking state
    currentTag = [[NSString alloc] init];
    currentScreen = [[NSString alloc] init];
    currentScreen = @"Topic";
    
    //Set up Metronome
    [self setUpMetronome];
    
    //Establishing Screen Size
    /*
     int iWidth = [[UIScreen mainScreen] bounds].size.width;
     int iHeight = [[UIScreen mainScreen] bounds].size.height;
     int iTabHeight = [[[self tabBarController] tabBar] bounds].size.height;
     NSLog(@"w=%d, h=%d, t=%d", iWidth, iHeight, iTabHeight);
     */
}

- (void)viewWillAppear:(BOOL)animated{
    
    //valueArray must be loaded dynamically with each tag choice
    tagArray = [[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
    
    //Reload data tables
    [topicTableView reloadData];
    [tagTableView reloadData];
    [valueTableView reloadData];
}
    
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==topicTableView)
    {
        iCnt = [dataStore.topicArray count];
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
            cell.textLabel.text = (NSString*)[dataStore.topicArray objectAtIndex:indexPath.row];
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
                
                //color my cell !
                cell.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.detailTextLabel.text = @"[ None ]";
                cell.backgroundColor = [UIColor whiteColor];
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
        //dataStore.currentSession[[currentTag copy]] = [value copy];
        dataStore.currentSession[currentTag] = [value copy];
        
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
        //Clean up and start over
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
        
        //Scroll to practice screen
        practiceViewController.iDisplayMode = 1800;
        [practiceViewController setScrollView];
        
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
    else if(tag == 4) //Complete practice, back to top
    {
        
        [self sessionComplete];
        
        //Scroll back to topic, then flip to History tab
        practiceViewController.iDisplayMode = 0;
        [practiceViewController setScrollView];
        [self.tabBarController setSelectedIndex:1];
        
    }else if(tag == 5){
        [self displayTimer];
    }else if(tag == 6){
        [self pauseMode];
    }else if(tag == 7){
        //nome
        
    }else if(tag == 10){
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
    
    //Store current session in sessions, & clear for next round..
    [dataStore.sessions addObject:[dataStore.currentSession mutableCopy]];
    
    //Clean up for next round
    [dataStore.currentSession removeAllObjects];
    
    //Reload tables
    [topicTableView reloadData];
    [tagTableView reloadData];
    
    //Initialize Duration Timer
    [self initializeTimer];
}


//////// TIMER FUNCTIONS //////////////////

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
-(IBAction)displayTimer
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

-(IBAction)pauseMode
{
    NSString *sMessage = @"";
    
    //Set varaiable to suspend practice
    bPractice = FALSE;
    
    //Create alert view
    UIAlertView *paused = [[UIAlertView alloc] initWithTitle:@"Practice Session Paused" message:sMessage delegate:self cancelButtonTitle:@"RESUME" otherButtonTitles:nil];

    
    //Display alert view
    [paused show];
    
}

//User response
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

//////////// METRONOME FUNCTIONS ////////////////////////

//Start or Stop Metronome

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

-(IBAction)Metronome
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
        [nomeButton setTitle: @"Stop" forState: UIControlStateNormal];
        [nomeButton setTitle: @"Stop" forState: UIControlStateApplication];
        [nomeButton setTitle: @"Stop" forState: UIControlStateHighlighted];
        [nomeButton setTitle: @"Stop" forState: UIControlStateReserved];
        [nomeButton setTitle: @"Stop" forState: UIControlStateSelected];
        [nomeButton setTitle: @"Stop" forState: UIControlStateDisabled];
        bNome = TRUE;
    }
    else
    {
        //Stop timer
        [nomeTimer invalidate];
        
        //Change state
        [nomeButton setTitle: @"Start" forState: UIControlStateNormal];
        [nomeButton setTitle: @"Start" forState: UIControlStateApplication];
        [nomeButton setTitle: @"Start" forState: UIControlStateHighlighted];
        [nomeButton setTitle: @"Start" forState: UIControlStateReserved];
        [nomeButton setTitle: @"Start" forState: UIControlStateSelected];
        [nomeButton setTitle: @"Start" forState: UIControlStateDisabled];
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
        [self Metronome];
    }
}

///////// SEGUE FUNCTIONS ///////////////////

-(IBAction)done:(UIStoryboardSegue *)segue
{
    
    if ([[segue identifier] isEqualToString:@"unwindFromNewInput"])
    {
        NewViewController *newViewController = segue.sourceViewController;
        NSString *source = newViewController.source;
        NSString *newItem = newViewController.input;
        
        if([source isEqualToString:@"Topic"]){
            [topicArray addObject:newItem];
            [topicTableView reloadData];
        }else if([source isEqualToString:@"Tag"]){
            //Create temp array to load dictionary
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            dataStore.tagData[newItem] = [tmpArray mutableCopy];
            tagArray = [[NSArray alloc] initWithArray:[dataStore.tagData allKeys]];
            [tagTableView reloadData];
        }else if([source isEqualToString:@"Value"]){
            [valueArray addObject:newItem];
            dataStore.tagData[currentTag] = [valueArray mutableCopy];
            [valueTableView reloadData];
        }else if([source isEqualToString:@"Note"]){
            
            [dataStore.currentSession[@"notes"] addObject:newItem];
            
            //[valueArray addObject:newItem];
            // dataStore.tagData[currentTag] = [valueArray mutableCopy];
            //[valueTableView reloadData];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



