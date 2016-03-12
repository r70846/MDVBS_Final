//
//  PracticeContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DataStore.h"
#import "NewViewController.h"
#import "TagCell.h"
#import "SimpleCell.h"
#import "DelButton.h"

@interface PracticeContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    //Reference to data tables
    IBOutlet  UITableView *topicTableView;
    IBOutlet  UITableView *tagTableView;
    IBOutlet  UITableView *valueTableView;
    
    
    IBOutlet UILabel *topicDisplayLabel;
    IBOutlet UILabel *topicDisplayLabelTwo;
    IBOutlet UILabel *topicDisplayLabelThree;
    IBOutlet UILabel *tagDisplayLabel;
    
    //Edit mode buttons
    IBOutlet UIButton *topicEditButton;
    IBOutlet UIButton *tagEditButton;
    IBOutlet UIButton *valueEditButton;
    
    
    // TIMER TOOL
    IBOutlet UILabel *timerDisplay;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIButton *viewButton;

    
    
    //Data Holders
    //NSMutableArray *topicArray;
    NSArray *tagArray;
    NSMutableArray *valueArray;
    NSString *currentTag;
    
    //currentScreen
    NSString *currentScreen;
    
    int iTotalTime;
    NSString *sDuration;
    NSTimer *durationTimer;
    Boolean bDisplayTimer;
    Boolean bPractice;
    
    // METRONOME TOOL
    SystemSoundID Click;
    NSTimer *nomeTimer;
    int BPM;
    Boolean bNome;
    
    IBOutlet UILabel *nomeDisplay;
    IBOutlet UIStepper *stepperOne;
    IBOutlet UIStepper *stepperTen;
    IBOutlet UIButton *nomeButton;
    
    
    UITabBarController *tabBarController;
}


//Respond to click event
-(IBAction)onClick:(UIButton *)button;

-(IBAction)editMode:(UIButton *)button;

-(IBAction)onDel:(DelButton *)button;
-(IBAction)done:(UIStoryboardSegue *)segue;

@end
