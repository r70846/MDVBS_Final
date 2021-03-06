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
    
    

    
    //Setup tag templatea
    [self setUpTemplateSheet];
    templateTextDisplay.text = dataStore.tagTemplate;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Fill in defaul email for export
    exportEmail.text = dataStore.userKeys[@"email"];
    
    //Set toggle state
    if([dataStore.userKeys[@"tweet"] isEqualToString:@"1"]){
        [togTweetComplete setOn:YES animated:NO];
    }else{
        [togTweetComplete  setOn:NO animated:NO];
    }
    
    if(bEmailView){  //If we're coming from Email View
        
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
            //[dataStore loadTags];
        }
    }
}

-(IBAction)clearSavedData{
    [dataStore.sessions removeAllObjects];
    [dataStore clearSessions];
}


-(void)clearCustomData{
    //[dataStore clearTopics];
    //[dataStore loadTopics];
}

-(IBAction)logOut{
    
    
    // Logout Parse
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil
    currentUser = nil;
    
    
    dataStore.user = @"";
    dataStore.password = @"";
    
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

        if ([togTweetComplete isOn]) {
            dataStore.userKeys[@"tweet"] = @"1";
            [self accountPermission];
            
        }else{
            dataStore.userKeys[@"tweet"] = @"0";
        }

    [self saveUserKeys];
}

////////////////////////////////////////////////////////

-(IBAction)onChange
{
        //Get changed email from text filed
    dataStore.userKeys[@"email"] = exportEmail.text;
    [self saveUserKeys];
}



-(IBAction)showEmailView{
    
    if([dataStore.sessions count] > 0)  // If we have data to export...
    {
        
        dataStore.userKeys[@"email"] = exportEmail.text;
        [self saveUserKeys];
        
        NSString *sSubject = @"Practice History";
        NSString *sMessage = @"Practice History";
        NSString *sAddress = dataStore.userKeys[@"email"];
        
        NSLog(@"%@", sAddress);
        
        //NSArray *sRecipents = [NSArray arrayWithObject:defaultEmail];
        NSArray *sRecipents = @[sAddress];
        
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


-(void)accountPermission{
    
    //Display alert view
    //[alert show];
    
    //Makes ure we start over with an empty array
    //[twitterPosts removeAllObjects ];
    
    //Load/reload table with no data
    //[mainTableView reloadData];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    if(accountStore != nil)
    {
        
        NSLog(@"Account Store is good");
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if(accountType != nil)
        {
            NSLog(@"Account Type is good");
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if(granted)
                {
                }
                else
                {
                    //The user says no
                }
            }];
        }
    }
}

-(void)saveUserKeys{
    PFQuery *query = [PFQuery queryWithClassName:@"KeyData"];
    [query getObjectInBackgroundWithId:dataStore.userKeys[@"key"] block:^(PFObject *keyData, NSError *error) {
        keyData[@"keyData"] = dataStore.userKeys;
        [keyData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //Nothing
            } else {
                // There was a problem, check error.description
                NSLog (@"Parse error saving revised user keys:%@", error.description);
            }
        }];
    }];
    
}


-(void)clearSessions{
    [dataStore.sessions addObject:[dataStore.currentSession mutableCopy]];
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    [query getObjectInBackgroundWithId:dataStore.userKeys[@"sessions"] block:^(PFObject *sessionData, NSError *error) {
        NSMutableArray *sessions = [[NSMutableArray alloc] init];
        sessionData[@"sessionData"] = sessions;
        [sessionData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
                [self.tabBarController setSelectedIndex:1];
            } else {
                // There was a problem, check error.description
                NSLog (@"Parse error saving revised user keys:%@", error.description);
            }
        }];
    }];
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
