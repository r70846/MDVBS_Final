///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  DataStore.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/21/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Social/Social.h>
#import "Reachability.h"

@interface DataStore : NSObject
{
    
    NSString *dataVersion;
    Reachability* reach;
    
}

+ (DataStore *) sharedInstance;


//App Status
@property (nonatomic)BOOL isOnline;
@property (nonatomic)BOOL directDelete;
@property (nonatomic)BOOL tweetOnComplete;
@property (nonatomic)BOOL stay;
@property (nonatomic)BOOL success;
@property (nonatomic, strong)NSString *user;
@property (nonatomic, strong)NSString *password;


//Topics, Tags, values, data storage...
@property (nonatomic, strong)NSMutableArray *topicArray;
@property (nonatomic, strong)NSMutableDictionary *tagData;

@property (nonatomic, strong)NSString *templateChoice;
@property (nonatomic, strong)NSMutableArray *templateArray;

//Session tracking
@property (nonatomic, strong)NSMutableDictionary *currentSession;
@property (nonatomic, strong)NSDate *startDateTime;
@property (nonatomic, strong)NSDate *endDateTime;
@property (nonatomic, strong)NSMutableArray *sessions;

//Harddrive storage
@property (nonatomic, strong)NSString *jsonTopicsPath;
@property (nonatomic, strong)NSString *jsonTagsPath;
@property (nonatomic, strong)NSString *jsonSessionsPath;
@property (nonatomic, strong)NSString *csvPath;


-(void)resetCurrentSession;
-(void)loadTags;

-(void)saveTopics;
-(void)saveSessions;
-(void)clearTopics;
-(void)clearSessions;
-(void)loadTopics;
-(void)loadSessions;

@end