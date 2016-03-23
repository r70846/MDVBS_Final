///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  HistoryContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DataStore.h"
#import "HistoryCell.h"
#import "TagCell.h"
#import "SimpleCell.h"
#import "DelButton.h"

typedef NS_ENUM(NSUInteger, AudioState) {
    noaudio,
    audio,
    playing,
    pausedPlaying
};

@interface HistoryContentViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate,AVAudioPlayerDelegate>

{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    //Reference to data tables
    IBOutlet  UITableView *historyTableView;
    IBOutlet  UITableView *detailTableView;
    
    IBOutlet UILabel *topicDisplayLabel;
    IBOutlet UILabel *dateTimeDisplayLabel;
    
    // Sort and filter
    IBOutlet UITextField *sortDisplay;
    IBOutlet UITextField *filterDisplay;
    
    // Data Editing
    IBOutlet UIButton *historyEditButton;
    
    
    NSMutableArray *sessions;
    NSMutableDictionary *lookupTable;
    
    
    NSMutableArray *filterArray;
    NSMutableArray *sortArray;
    UIActionSheet *filterActionSheet;
    UIActionSheet *sortActionSheet;
    
    //Session chosen by user to display from history
    NSMutableDictionary *detailSession;
    
    NSMutableArray *tagArray;
    NSMutableArray *valueArray;
    NSMutableArray *notesArray;
    
    // Audio Playback
    NSTimer *audioTimer;
    AVAudioPlayer *audioPlayer;
    IBOutlet UIButton *btnPlayStop;
    IBOutlet UIButton *btnPause;
    IBOutlet UIProgressView *audioProgress;
    NSURL *audioFileURL;
    UIImage *stop;
    UIImage *play;
    UIImage *pause;
    UIImage *pauselit;
    AudioState audioState;
}

//Respond to click event
-(IBAction)onClick:(UIButton *)button;
-(IBAction)editMode:(UIButton *)button;


-(void)saveSessions;
-(IBAction)playStopAudio:(UIButton *)button;
@end
