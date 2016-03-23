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
@property (nonatomic)BOOL tweet;
@property (nonatomic)BOOL stay;
@property (nonatomic)BOOL success;

@property (nonatomic, strong)NSString *user;
@property (nonatomic, strong)NSString *password;

// User data
@property (nonatomic, strong)NSMutableDictionary *userKeys;
@property (nonatomic, strong)NSMutableDictionary *parseObjects;

//Topics, Tags, values, data storage...
@property (nonatomic, strong)NSMutableArray *topicArray;
@property (nonatomic, strong)NSMutableDictionary *topicData;
@property (nonatomic, strong)NSMutableDictionary *topicFilter;



@property (nonatomic, strong)NSMutableArray *tagArray;
@property (nonatomic, strong)NSMutableDictionary *tagData;

@property (nonatomic, strong)NSString *tagTemplate;
@property (nonatomic, strong)NSMutableArray *templateArray;

//Session tracking
@property (nonatomic, strong)NSMutableDictionary *currentSession;
@property (nonatomic, strong)NSDate *startDateTime;
@property (nonatomic, strong)NSDate *endDateTime;
@property (nonatomic, strong)NSMutableArray *sessions;


// Parse IDs
@property (nonatomic, strong)NSString *topicsID;
@property (nonatomic, strong)NSString *tagsID;
@property (nonatomic, strong)NSString *sessionsID;

//Harddrive storage
@property (nonatomic, strong)NSString *jsonTopicsPath;
@property (nonatomic, strong)NSString *jsonTagsPath;
@property (nonatomic, strong)NSString *jsonSessionsPath;
@property (nonatomic, strong)NSString *csvPath;
@property (nonatomic, strong)NSString *playbackPath;

-(void)resetCurrentSession;
-(void)loadTagTemplates;
-(NSMutableDictionary*)getDefaultTopics;
-(NSMutableDictionary*)getDefaultTags;
-(NSMutableDictionary*)filterTags;
-(void)addTagsFromTemplate;
-(void)clearSessions;
-(void)loadTopicFilter;

@end