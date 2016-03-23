///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  PracticeContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DataStore.h"
#import "NewViewController.h"
#import "TagCell.h"
#import "SimpleCell.h"
#import "DelButton.h"

typedef NS_ENUM(NSUInteger, AudioState) {
    noaudio,
    audio,
    recording,
    pausedRecording,
    playing,
    pausedPlaying
};

@interface PracticeContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object

    // Data Holders
    NSMutableArray *valueArray;
    NSString *currentTag;
    
    // Tab Controller
    UITabBarController *tabBarController;
    
    // Table Reference
    IBOutlet  UITableView *topicTableView;
    IBOutlet  UITableView *tagTableView;
    IBOutlet  UITableView *valueTableView;
    
    // Screen Labels
    IBOutlet UILabel *topicDisplayLabel;
    IBOutlet UILabel *topicDisplayLabelTwo;
    IBOutlet UILabel *topicDisplayLabelThree;
    IBOutlet UILabel *tagDisplayLabel;
    
    // Data Editing
    IBOutlet UIButton *topicEditButton;
    IBOutlet UIButton *tagEditButton;
    IBOutlet UIButton *valueEditButton;
    NSString *currentScreen;
    
    // Tag Templates
    IBOutlet UIButton *templateButton;
    IBOutlet UITextField *templateTextDisplay;
    UIActionSheet *templateSheet;
    
    // Metronome
    IBOutlet UILabel *nomeDisplay;
    IBOutlet UIStepper *stepperOne;
    IBOutlet UIStepper *stepperTen;
    IBOutlet UIButton *nomeButton;
    
    SystemSoundID Click;
    NSTimer *nomeTimer;
    int BPM;
    Boolean bNome;
    
    // Timer Tool
    IBOutlet UILabel *timerDisplay;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIButton *viewButton;

    int iTotalTime;
    NSString *sDuration;
    NSTimer *durationTimer;
    Boolean bDisplayTimer;
    Boolean bPractice;
    
    // Rep Counter
    IBOutlet UILabel *counterDisplay;
    int iTotalCount;
    
    //TONE GENERATOR
    //two audio players and a timer will create identical overlaping loops
    //two looping copies of the same wav file started at a time offest produce the drone
    
    IBOutlet UIStepper *droneStepper;
    IBOutlet UIButton *droneButton;
    IBOutlet UILabel *droneDisplay;
    
    AVAudioPlayer *drone1;
    AVAudioPlayer *drone2;
    NSMutableArray *keyArray;
    Boolean bDrone;
    
    
    // Snippet Audio
    
    // Audio

    IBOutlet UIButton *btnRecPause;
    IBOutlet UIButton *btnPlayStop;
    IBOutlet UIButton *btnDeleteAudio;
    IBOutlet UILabel *audioMessage;
    IBOutlet UIProgressView *audioProgress;
    
    UIImage *stop;
    UIImage *play;
    UIImage *pause;
    UIImage *record;
    UIImage *recordLit;
    UIImage *pauseLit;
    
    NSTimer *audioTimer;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    NSURL *audioFileURL;
    AudioState audioState;
    
    
    
}


// Data Cells Add
-(IBAction)addItemAction:(UIButton *)button;
-(IBAction)returnNewItem:(UIStoryboardSegue *)segue;

// Data Cells Delete
-(IBAction)editMode:(UIButton *)button;
-(IBAction)onDel:(DelButton *)button;
-(void)editModeSwitch:(UITableView *)table;
-(void)editButtonSwitch:(UIButton *)button;

// Tag Templates
-(IBAction)chooseTemplate;

// Session Functions
-(IBAction)navAction:(UIButton *)button;
-(IBAction)practiceAction:(UIButton *)button;
-(void)sessionBegin;
-(void)sessionComplete;

// Timer Functions
-(void)displayTimer;
-(void)initializeTimer;
-(void)oneRound;
-(void)pauseMode;

// Metronome Functions
- (IBAction)stepperChange:(UIStepper *)sender;
-(void)setUpMetronome;
-(void)runMetronome;
-(void)Beat;  //Runs on each click

// Drone Functions
-(IBAction)drone;

// Audio Snippet Functions
- (IBAction)deleteAudio:(id)sender;
-(void)setUpAudio;
-(void)saveAudioSnippet;
-(BOOL)isAudio;
@end
