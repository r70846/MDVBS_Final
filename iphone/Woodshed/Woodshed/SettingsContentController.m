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
    
    //Setup tag templatea
    [self setUpTemplateSheet];
    templateTextDisplay.text = dataStore.templateChoice;
    
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
            dataStore.templateChoice = choice;
            [dataStore loadTags];
        }
    }
}

-(IBAction)clearSavedData{
    [dataStore clearTopics];
    [dataStore clearSessions];
    [dataStore loadTopics];
    [dataStore loadSessions];
    [dataStore resetCurrentSession];
    
}


-(IBAction)logOut{
    
    
    // Logout Parse
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil
    currentUser = nil;
    
    
    dataStore.user = @"";
    dataStore.password = @"";
    dataStore.topicsID = nil;
    
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
