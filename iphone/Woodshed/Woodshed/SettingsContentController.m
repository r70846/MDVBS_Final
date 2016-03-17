///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  SettingsContentController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "SettingsContentController.h"

@interface SettingsContentController ()

@end

@implementation SettingsContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; ; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    ///////////////////////////////
    
    //To indicate email view
    bEmailView = false;
    
    //retract keyboard
    [exportEmail setDelegate:self];
    
    /*
    //Fill in defaul email for export
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil)
    {
        //Get value
        defaultEmail = [defaults objectForKey:@"email"];
        if(defaultEmail != nil){
            exportEmail.text = defaultEmail;
        }
        else
        {
            [defaults setObject:@"" forKey:@"email"];
            //saves the data
            [defaults synchronize];
        }
    }
    */
    
    ///////////////////////////////
    
    //Setup tag templatea
    [self setUpTemplateSheet];
    templateTextDisplay.text = dataStore.tagTemplate;
    
}

- (void)viewWillAppear:(BOOL)animated {
    if(dataStore.tweet){
        [togTweetComplete setOn:YES animated:NO];
    }else{
        [togTweetComplete  setOn:NO animated:NO];
    }
    
    if(bEmailView){  //If we're coming from Email View
        
        //Hide branding graphic
        //brandImage.hidden = true;
        
        //Track status - No longer in Email View
        bEmailView = false;
    }
    else            //Coming from Tab Bar Controller
    {
        
        //Rebuild comma delimited data file
        //[self createCSVFile];
        
        //Show graphic and hide message
        //brandImage.hidden = false;
        messageLabel.text = @"";
    }

    
    [super viewWillAppear:animated];
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
        [    templateSheet addButtonWithTitle:template];
    }
    
    //Add cancel button on the end
    templateSheet.cancelButtonIndex = [templateSheet addButtonWithTitle:@"Cancel"];
    
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
            templateTextDisplay.text = choice;
            dataStore.tagTemplate = choice;
            [dataStore loadTags];
        }
    }
}

-(IBAction)clearSavedData{
    [dataStore.sessions removeAllObjects];
    [dataStore clearSessions];
    [dataStore loadEmptySessions];
    [dataStore resetCurrentSession];
    //[self clearCustomData];
}


-(void)clearCustomData{
    [dataStore clearTopics];
    [dataStore loadTopics];
}

-(IBAction)logOut{
    
    
    // Logout Parse
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil
    currentUser = nil;
    
    
    dataStore.user = @"";
    dataStore.password = @"";
    dataStore.topicsID = nil;
    dataStore.sessionsID = nil;
    
    // Clear local storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil)
    {
        
        [defaults setObject:@"" forKey:@"user"];
        [defaults setObject:@"" forKey:@"password"];
        [defaults setObject:@"0" forKey:@"success"];
        
        //saves the data
        [defaults synchronize];
    }
    
    // Show Login Screen
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentViewController:viewController animated:NO completion:nil];
}


-(IBAction)setTweetState{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(defaults != nil)
    {
        if ([togTweetComplete isOn]) {
            [defaults setObject:@"1" forKey:@"tweet"];
            dataStore.tweet = true;
        }else{
            [defaults setObject:@"0" forKey:@"tweet"];
            dataStore.tweet = false;
        }
        
        //saves the data
        [defaults synchronize];
        
    }
    
}

////////////////////////////////////////////////////////

-(IBAction)onChange
{
    NSLog(@"%@", exportEmail.text);
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil)
    {
        //Get changed email from text filed
        defaultEmail = exportEmail.text;
        
        if(defaultEmail != NULL){
            [defaults setObject:defaultEmail forKey:@"email"];
            
            //saves the data
            [defaults synchronize];
        }
    }
}



-(IBAction)showEmailView{
    
    if([dataStore.sessions count] > 0)  // If we have data to export...
    {
        NSString *sSubject = @"Practice History";
        NSString *sMessage = @"Practice History";
        //NSArray *sRecipents = [NSArray arrayWithObject:defaultEmail];
        NSArray *sRecipents = [NSArray arrayWithObject:@"russg@fullsail.edu"];
        
        MFMailComposeViewController *emailView = [[MFMailComposeViewController alloc] init];
        emailView.mailComposeDelegate = self;
        [emailView setSubject:sSubject];
        [emailView setMessageBody:sMessage isHTML:NO];
        [emailView setToRecipients:sRecipents];
        
        //Get reference to file as data object
        NSData *dFile = [NSData dataWithContentsOfFile:dataStore.csvPath];
        
        //Attach csv records file to email
        [emailView addAttachmentData:dFile mimeType:@"csv" fileName:@"datalog"];
        
        // Show email controller
        [self presentViewController:emailView animated:YES completion:NULL];
        
        //To indicate email view
        bEmailView = true;
    }
    else // No data to export...
    {
        //Hide graphic and show message
        //brandImage.hidden = true;
        messageLabel.text = @"No Records\n Available";
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            messageLabel.text = @"Export Email Cancelled";
            break;
        case MFMailComposeResultSaved:
            messageLabel.text = @"Export Email Saved";
            break;
        case MFMailComposeResultSent:
            messageLabel.text = @"Export Email Sent";
            break;
        case MFMailComposeResultFailed:
            messageLabel.text = [error localizedDescription];
            break;
        default:
            break;
    }
    
    // Dismiss Email View
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)createCSVFile
{
    
    
    //Write header to file - overwrites old or create if absent
    NSString *sHeader = @"Topic,Date,Time,Duration,Repetitions,Tempo,Key,Bowing,Notes\n";
    [sHeader writeToFile:dataStore.csvPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
   
        //Compile all valid date to a single string for display
   // NSString *sDetails = [[NSString alloc] initWithFormat:@"%@\n", @"data"];
    
        //Add row to current data file
        //[self appendToFile:sDetails];

}



////////////////////////////////////////////////////////

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
