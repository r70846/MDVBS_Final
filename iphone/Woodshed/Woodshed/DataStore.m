///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  DataStore.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/21/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "DataStore.h"

@implementation DataStore

static DataStore *_sharedInstance;


- (id) init
{
    if (self = [super init])
    {
        //Keep track of datastructure versioning
        dataVersion = @"beta10";
        
        //Create Array to hold Sessions Data
        _sessions = [[NSMutableArray alloc] init];
        
        //Create Array to hold Topic Data
        _topicArray = [[NSMutableArray alloc] init];
        
        //Create Dictionary Object to hold tag data
        _topicData = [[NSMutableDictionary alloc]init];

        //Create Dictionary Object to hold tag data
        _tagData = [[NSMutableDictionary alloc]init];
        
        //Create Dictionary Object to hold session data
        _currentSession = [[NSMutableDictionary alloc]init];
        
        
        //Create Array to hold tag/value templates
        _tagTemplate = [[NSMutableString alloc]init];
        
        //Create Array to hold tag/value templates
        _templateArray= [[NSMutableArray alloc]init];
        
        [self resetCurrentSession];
        
///////// LOCAL DATA STORAGE ////////////////////////////
        
        //find document directory, get the path to the document directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        NSString *path = (NSString*)[paths objectAtIndex:0];
        
        //Log documents path
        //NSLog(@"%@", path);
        
        //get path to my local json data files
        _jsonTopicsPath = [path stringByAppendingPathComponent:@"topics.json"];
        _jsonTopicsPath = [path stringByAppendingPathComponent:@"tags.json"];
        _jsonSessionsPath = [path stringByAppendingPathComponent:@"session.json"];
        
        
        
        //Delete data & start over if previous version
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *version;
        if(defaults != nil)
        {
            version = [defaults objectForKey:@"version"];
            if([version isEqualToString:dataVersion]){
            }else{
                [self clearTopics];
                [self clearSessions];
                [defaults setObject:dataVersion forKey:@"version"];
            }
        }
    
        _isOnline = false;
        [self startNetworkCheck];
    }
    return self;
}

-(void)startNetworkCheck{
/// START MILLION ////////////////////////////////////////////////////////////////////

// Allocate a reachability object
reach = [Reachability reachabilityWithHostname:@"www.google.com"];

//create a week reference to self to avoid ARC retain cycle
//__weak typeof(self) wSelf = self;

// Set the blocks
reach.reachableBlock = ^(Reachability*reach)
{
    // keep in mind this is called on a background thread
    // and if you are updating the UI it needs to happen
    // on the main thread, like this:
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"REACHABLE!");
        _isOnline = true;
        
        /*
        if(wSelf.netWorkSign){
            [wSelf.netWorkSign setHidden:YES];
            
            //After control returns, check login
            [wSelf autoLog];
        }
        */
        
    });
};

reach.unreachableBlock = ^(Reachability*reach)
{
    NSLog(@"UNREACHABLE!");
    _isOnline = false;
    /*
    if(wSelf.netWorkSign){
        [wSelf.netWorkSign setHidden:NO];
    }
     */
};

// Start the notifier, which will cause the reachability object to retain itself!
[reach startNotifier];


}

//Methods
-(void)resetCurrentSession{
    
    //Create temp array to load dictionary
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    
    [_currentSession removeAllObjects];
    [_currentSession setValue:@"" forKey:@"topic"];
    [_currentSession setValue:@"" forKey:@"date"];
    [_currentSession setValue:@"" forKey:@"time"];
    [_currentSession setValue:@"" forKey:@"duration"];
    [_currentSession setValue:valueArray forKey:@"notes"];
}

+ (DataStore *) sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[DataStore alloc] init];
    }
    
    return _sharedInstance;
}

-(void)loadParseData{

    [self loadTopics];
    
    [self loadTags];

    [self loadSessions];

}

///////// TRACK STATE ////////////////////////////

//Boolean Connectivity Monitor


////////// TOPICS //////////////////////


-(void)loadTopics{
    
    [_topicData removeAllObjects];
            //PFObject *topicData = [PFObject objectWithClassName:@"TopicData"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TopicData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu topic dicts.", objects.count);
            
            if(objects.count > 0){
                //PFObject *topicData = [objects objectAtIndex:objects.count];
                PFObject *topicData = [objects objectAtIndex:0];
                _topicData = (NSMutableDictionary*)topicData[@"topicData"];
                if([_topicData count] != 0){
                    _topicArray = (NSMutableArray*)[_topicData allKeys];
                    _topicsID = topicData.objectId;
                }else{
                    [self loadDefaultTopics];
                    NSLog(@"Empty cloud object, loading defaults");
                }
            }else{
                [self loadDefaultTopics];
                NSLog(@"No cloud data, loading defaults");
            }

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
    
-(void)loadDefaultTopics{
    
    BOOL localData = false;

    //If file exists load data
    if([[NSFileManager defaultManager] fileExistsAtPath:_jsonTopicsPath] && localData)
    {
        //Read content of file as data object
        NSData* oData = [NSData dataWithContentsOfFile:_jsonTopicsPath];
        
        //Serialize data object to JSON data (Mutable Ditcionary)
        _topicData = [NSJSONSerialization JSONObjectWithData:oData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        _topicArray = (NSMutableArray*)[_topicData allKeys];
        NSLog(@"retrieved local topic data");
    }else{
        NSLog(@"default topic data");
        
        [_topicData removeAllObjects];
        
        //No stored data use, defaults
        _topicData[@"All of Me"] = @"0";
        _topicData[@"How High the Moon"] = @"0";
        _topicData[@"Autumn Leaves"] = @"0";
        _topicData[@"Bach Minuet in D"] = @"0";
        _topicData[@"Malaguena"] = @"0";
        _topicData[@"Minor 7th Arpeggio"] = @"0";
        _topicData[@"Major 7th Arpeggio"] = @"0";
        _topicData[@"Augmented 7th Arpeggios"] = @"0";
        _topicData[@"Major Scale"] = @"0";
        _topicData[@"Natural Minor Scale"] = @"0";
        _topicData[@"Harmonic Minor Scale"] = @"0";
        _topicData[@"Melodic Minor Scale"] = @"0";
        _topicData[@"Diminished Scale"] = @"0";
        _topicData[@"Whole Tone Scale"] = @"0";
        _topicData[@"Dorian Mode"] = @"0";
        _topicData[@"Phrygian Mode"] = @"0";
        _topicArray = (NSMutableArray*)[_topicData allKeys];
        
        PFObject *topicData = [PFObject objectWithClassName:@"TopicData"];
        topicData[@"topicData"] = _topicData;
        
        [topicData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog (@"Saved Defualt topics to parse");

            } else {
                // There was a problem, check error.description
                NSLog (@"Parse error saving defailt topics:%@", error.description);
            }
        }];
    }
}

-(void)saveTopics{
        NSLog (@"in save topics function");
    
    BOOL localData = false;
    
    //Save as a JSON file
    if ([NSJSONSerialization isValidJSONObject: _topicData] && localData) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: _topicData options: NSJSONWritingPrettyPrinted error: NULL];
        [jsonData writeToFile:_jsonTopicsPath atomically:YES];
    }else if(localData){
        NSLog (@"can't save topic data as JSON");
        NSLog(@"%@", [_topicData description]);
    }else{
    //Save to cloud
        
        NSLog (@"top of the cload block");
        
    PFQuery *query = [PFQuery queryWithClassName:@"TopicData"];

        // Retrieve the object by id
    [query getObjectInBackgroundWithId:_topicsID
                                    block:^(PFObject *topicData, NSError *error) {
                                    // Now let's update it with some new data. In this case, only cheatMode and score
                                    // will get sent to the cloud. playerName hasn't changed.
                                    topicData[@"topicData"] = _topicData;
                                    [topicData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                                NSLog (@"Saved revised topics to parse");
                                                
                                        } else {
                                                // There was a problem, check error.description
                                                NSLog (@"Parse error saving revises topics:%@", error.description);
                                        }
                                    }];
                                }];
    }
    _topicArray = (NSMutableArray*)[_topicData allKeys];
}


-(void)clearTopics{
    
    NSString *ID = _topicsID;
    _topicsID = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:_jsonTopicsPath error:&error];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TopicData"];
    
    [query getObjectInBackgroundWithId:ID block:^(PFObject *topicsData, NSError *error) {
        // Do something with the returned PFObject
        if(!error){
            [topicsData deleteInBackground];
            [self loadDefaultTopics];
        }else{
            NSLog(@"Error clearing topics: %@",error.description);
        }

    }];
}

////////// SESSIONS //////////////////////

-(void)saveSessions{
    
    BOOL localData = false;
    //Save as a JSON file
    if ([NSJSONSerialization isValidJSONObject: _sessions] && localData) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: _sessions options: NSJSONWritingPrettyPrinted error: NULL];
        [jsonData writeToFile:_jsonSessionsPath atomically:YES];
        NSLog (@"sessions saved");
    }else if(localData){
        NSLog (@"can't save session data as JSON");
        NSLog(@"%@", [_sessions description]);
    }else{
        //Save to cloud
        PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:_sessionsID
                                     block:^(PFObject *sessionData, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                                         sessionData[@"sessionData"] = _sessions;
                                         [sessionData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                             if (succeeded) {
                                                 NSLog (@"Saved revised sessions to parse");
                                                 
                                             } else {
                                                 // There was a problem, check error.description
                                                 NSLog (@"Parse error saving revised sessions:%@", error.description);
                                             }
                                         }];
                                     }];
    }
   // _topicArray = (NSMutableArray*)[_topicData allKeys];
}

-(void)loadEmptySessions{
    PFObject *sessionData = [PFObject objectWithClassName:@"SessionData"];
    [_sessions removeAllObjects];
    sessionData[@"sessionData"] = _sessions;
    
    [sessionData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog (@"Saved empty sessions to parse");
            
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving empty sessions:%@", error.description);
        }
    }];
}

-(void)clearSessions{
    
    [_sessions removeAllObjects];
    
    NSString *ID = _sessionsID;
    _sessionsID = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:_jsonSessionsPath error:&error];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    
    [query getObjectInBackgroundWithId:ID block:^(PFObject *sessionData, NSError *error) {
        // Do something with the returned PFObject
        if(!error){
            [sessionData deleteInBackground];
        }else{
            NSLog(@"Error clearing sessions: %@",error.description);
        }
    }];
}

-(void)loadSessions{
    
    //PFObject *topicData = [PFObject objectWithClassName:@"TopicData"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu sessions array.", objects.count);
            
            if(objects.count > 0){
                PFObject *sessionData = [objects objectAtIndex:0];
                _sessions = (NSMutableArray*)sessionData[@"sessionData"];
                _sessionsID = sessionData.objectId;
            }else{
                [self loadEmptySessions];
                NSLog(@"No cloud data, loading empty sessions");
            }
        } else {
            // Log details of the failure
            NSLog(@"Session loading error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)loadSessionsLocal{
    
    [_sessions removeAllObjects];
    
    //If file exists load data
    if([[NSFileManager defaultManager] fileExistsAtPath:_jsonSessionsPath])
    {
        //Read content of file as data object
        NSData* oData = [NSData dataWithContentsOfFile:_jsonSessionsPath];
        
        //Serialize data object to JSON data (Mutable Array)
        _sessions = [NSJSONSerialization JSONObjectWithData:oData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    }
}

-(void)loadTagTemplates{
    
    [_templateArray removeAllObjects];
    [_templateArray addObject:@"[ None ]"];
    [_templateArray addObject:@"Bowed String Tags"];
    [_templateArray addObject:@"Woodwind Tags"];
    [_templateArray addObject:@"Brass Tags"];
    [_templateArray addObject:@"Drum Tags"];
    [_templateArray addObject:@"Guitar Tags"];
    
    //_tagTemplate = [_templateArray objectAtIndex:0];
}

////////// TAGS //////////////////////


-(void)loadTags{
    
    [_tagData removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TagData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu user tags dicts.", objects.count);
            
            if(objects.count > 0){
                //PFObject *topicData = [objects objectAtIndex:objects.count];
                PFObject *tagData = [objects objectAtIndex:0];
                _tagData = (NSMutableDictionary*)tagData[@"tagData"];
                if([_tagData count] != 0){
                    NSLog(@"TAG DATA: %@", _tagData.description);
                    [self addTagsFromTemplate];
                    _tagArray = (NSMutableArray*)[_tagData allKeys];
                    _tagsID = tagData.objectId;
                }else{
                    [self loadDefaultTags];
                    NSLog(@"Empty cloud object, loading default tags");
                }
            }else{
                [self loadDefaultTags];
                NSLog(@"No cloud data, loading default tags");
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



-(void)loadDefaultTags{
    
    [_tagData removeAllObjects];
    
    //Create temp array to load dictionary
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    
    //Key Center
    [valueArray removeAllObjects];
    [valueArray addObject:@"_standard"];
    [valueArray addObject:@"A Natural"];
    [valueArray addObject:@"A Sharp"];
    [valueArray addObject:@"B Flat"];
    [valueArray addObject:@"C Natural"];
    [valueArray addObject:@"C Sharp"];
    [valueArray addObject:@"D Flat"];
    [valueArray addObject:@"D Natural"];
    [valueArray addObject:@"D Sharp"];
    [valueArray addObject:@"E Flat"];
    [valueArray addObject:@"E Natural"];
    [valueArray addObject:@"F Natural"];
    [valueArray addObject:@"F Sharp"];
    [valueArray addObject:@"G Flat"];
    [valueArray addObject:@"G Natural"];
    [valueArray addObject:@"G Sharp"];
    [valueArray addObject:@"A Flat"];
    _tagData[@"Key Center"] = [valueArray mutableCopy];
    
    //Tempo
    [valueArray removeAllObjects];
    [valueArray addObject:@"_standard"];
    [valueArray addObject:@"Grave"];
    [valueArray addObject:@"Largo"];
    [valueArray addObject:@"Larghetto"];
    [valueArray addObject:@"Lentando"];
    [valueArray addObject:@"Lento"];
    [valueArray addObject:@"Tardo"];
    [valueArray addObject:@"Adagio"];
    [valueArray addObject:@"Adagietto"];
    [valueArray addObject:@"Andante"];
    [valueArray addObject:@"andantino"];
    [valueArray addObject:@"Moderato"];
    [valueArray addObject:@"Allegretto"];
    [valueArray addObject:@"Largamente"];
    [valueArray addObject:@"Allegro"];
    _tagData[@"Tempo"] = [valueArray mutableCopy];
    
    PFObject *tagData = [PFObject objectWithClassName:@"TagData"];
    tagData[@"tagData"] = _tagData;
    
    [tagData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog (@"Saved Defualt tags to parse");
            [self addTagsFromTemplate];
            _tagArray = (NSMutableArray*)[_tagData allKeys]; //NEW
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving defailt tags:%@", error.description);
        }
    }];
}

-(void)addTagsFromTemplate{
    
    //Create temp array to load dictionary
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    //Instrument specific tags
    
    //Bowed Strings
    if([_tagData objectForKey:@"Bowing Pattern"]== nil){
        if ([_tagTemplate isEqualToString:@"[ All Tags ]"] ||
            [_tagTemplate isEqualToString:@"Bowed String Tags"]){
        
            //Bowing Pattern
            [valueArray removeAllObjects];
            [valueArray addObject:@"_template"];
            [valueArray addObject:@"Straight Bowing"];
            [valueArray addObject:@"Shuffle Bowing"];
            [valueArray addObject:@"Swing Bowing"];
            [valueArray addObject:@"Chain Bowing"];
            [valueArray addObject:@"Long Bow"];
            [valueArray addObject:@"Three Notes Per Bow"];
            _tagData[@"Bowing Pattern"] = [valueArray mutableCopy];
        }
    }
    //Woodwinds
    if([_tagData objectForKey:@"Tonguing Technique"] == nil){
        if ([_tagTemplate isEqualToString:@"[ All Tags ]"] ||
            [_tagTemplate isEqualToString:@"Woodwind Tags"] ||
            [_tagTemplate isEqualToString:@"Brass Tags"]){
        
            //Tonguing Technique
            [valueArray removeAllObjects];
            [valueArray addObject:@"_template"];
            [valueArray addObject:@"Single Tongue"];
            [valueArray addObject:@"Double Tongue"];
            [valueArray addObject:@"Triple Tongue"];
            _tagData[@"Tonguing Technique"] = [valueArray mutableCopy];
        }
    }
    //Brass
    if([_tagData objectForKey:@"Lip Slurs"] == nil){
        if ([_tagTemplate isEqualToString:@"[ All Tags ]"] ||
            [_tagTemplate isEqualToString:@"Brass Tags"]){
        
            //Lip Slurs
            [valueArray removeAllObjects];
            [valueArray addObject:@"_template"];
            [valueArray addObject:@"Two Note Slurs"];
            [valueArray addObject:@"Three Note Slurs"];
            [valueArray addObject:@"Four Note Slurs"];
            _tagData[@"Lip Slurs"] = [valueArray mutableCopy];
        }
    }
    //Drums
    if([_tagData objectForKey:@"Drum Stick Grip"] == nil){
        if ([_tagTemplate isEqualToString:@"[ All Tags ]"] ||
            [_tagTemplate isEqualToString:@"Drum Tags"]){
        
            //Drum Stick Grip
            [valueArray removeAllObjects];
            [valueArray addObject:@"_template"];
            [valueArray addObject:@"Traditional Grip"];
            [valueArray addObject:@"Reverse Traditional Grip"];
            [valueArray addObject:@"German Grip"];
            [valueArray addObject:@"French Grip"];
            [valueArray addObject:@"American Grip"];
            _tagData[@"Drum Stick Grip"] = [valueArray mutableCopy];
        }
    }
    //Guitar
    if([_tagData objectForKey:@"Drum Stick Grip"] == nil){
        if ([_tagTemplate isEqualToString:@"[ All Tags ]"] ||
            [_tagTemplate isEqualToString:@"Guitar Tags"]){
        
            //Picking Technique
            [valueArray removeAllObjects];
            [valueArray addObject:@"_template"];
            [valueArray addObject:@"Down Picking"];
            [valueArray addObject:@"Alternate Picking"];
            [valueArray addObject:@"Sweep Picking"];
            [valueArray addObject:@"Finger Picking"];
        _tagData[@"Picking Technique"] = [valueArray mutableCopy];
        }
    }
    //NSLog(@"%@", _tagData);
}

-(void)saveTags{
    NSLog (@"in save tags function");
    
    //Save to cloud
    PFQuery *query = [PFQuery queryWithClassName:@"TagData"];
        
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:_tagsID
                                    block:^(PFObject *tagData, NSError *error) {
                                        tagData[@"tagData"] = [self filterTags];
                                        [tagData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {
                                                NSLog (@"Saved revised tags to parse");
                                                 
                                            } else {
                                                // There was a problem, check error.description
                                                NSLog (@"Parse error saving revises tagss:%@", error.description);
                                             }
                                         }];
                                     }];

    //_tagArray = (NSMutableArray*)[_tagData allKeys];
}


-(NSMutableDictionary*)filterTags{
    _tagArray = (NSMutableArray*)[_tagData allKeys];
    NSMutableDictionary *userTagData = [[NSMutableDictionary alloc]init];
    
    for(NSString *tag in _tagArray){
        NSArray *vals = [_tagData objectForKey:tag];
        if([[vals objectAtIndex:0] isEqualToString:@"_user"] || [[vals objectAtIndex:0] isEqualToString:@"_standard"]){
            userTagData[tag] = vals;
        }
    }
    return userTagData;
}

@end
