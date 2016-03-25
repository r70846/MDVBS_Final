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
        
        //Create Dictionary Object to hold user keys
        _userKeys = [[NSMutableDictionary alloc]init];
        
        //Create Dictionary Object to hold user keys
        _parseObjects = [[NSMutableDictionary alloc]init];
        
        //Create Array to hold Sessions Data
        _sessions = [[NSMutableArray alloc] init];
        
        //Create Array to hold Topic Data
        _topicArray = [[NSMutableArray alloc] init];
        
        //Create Dictionary Object to hold tag data
        _topicData = [[NSMutableDictionary alloc]init];
        
        //Create Dictionary Object to hold tag data
        _topicFilter = [[NSMutableDictionary alloc]init];

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
        NSLog(@"Docuemnt Path: %@", path);
        
        //get path to my local json data files
        _jsonTopicsPath = [path stringByAppendingPathComponent:@"topics.json"];
        _jsonTopicsPath = [path stringByAppendingPathComponent:@"tags.json"];
        _jsonSessionsPath = [path stringByAppendingPathComponent:@"session.json"];
        _playbackPath = [path stringByAppendingPathComponent:@"snippet.m4a"];
        
        _isOnline = false;
        
    }
    return self;
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

///////// TRACK STATE ////////////////////////////

//Boolean Connectivity Monitor


////////// TOPICS //////////////////////
-(NSMutableDictionary*)getDefaultTopics{
    
    NSMutableDictionary *topicData = [[NSMutableDictionary alloc]init];
    topicData[@"All of Me"] = @"0";
    topicData[@"How High the Moon"] = @"0";
    topicData[@"Autumn Leaves"] = @"0";
    topicData[@"Bach Minuet in D"] = @"0";
    topicData[@"Malaguena"] = @"0";
    topicData[@"Minor 7th Arpeggio"] = @"0";
    topicData[@"Major 7th Arpeggio"] = @"0";
    topicData[@"Augmented 7th Arpeggios"] = @"0";
    topicData[@"Major Scale"] = @"0";
    topicData[@"Natural Minor Scale"] = @"0";
    topicData[@"Harmonic Minor Scale"] = @"0";
    topicData[@"Melodic Minor Scale"] = @"0";
    topicData[@"Diminished Scale"] = @"0";
    topicData[@"Whole Tone Scale"] = @"0";
    topicData[@"Dorian Mode"] = @"0";
    topicData[@"Phrygian Mode"] = @"0";
    
    return topicData;
}

-(void)loadTopicFilter{
    [_topicFilter removeAllObjects];
    NSString *sTopic;
    NSString *sCount;
    for(NSMutableDictionary *session in _sessions){
        sTopic = session[@"topic"];
        sCount = _topicFilter[sTopic];
        if(sCount == nil){
            _topicFilter[sTopic] = @"0";
        }else{
            int count = [sCount intValue];
            count++;
            _topicFilter[sTopic] = [NSString stringWithFormat:@"%i",count];
        }
    }
}
////////// SESSIONS //////////////////////

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


-(void)loadTagTemplates{
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    [tmpArray addObject:@"[ none ]"];
    [tmpArray addObject:@"Bowed String Tags"];
    [tmpArray addObject:@"Woodwind Tags"];
    [tmpArray addObject:@"Brass Tags"];
    [tmpArray addObject:@"Drum Tags"];
    [tmpArray addObject:@"Guitar Tags"];
    tmpArray = (NSMutableArray*)[tmpArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _templateArray = [tmpArray mutableCopy ];
}

////////// TAGS //////////////////////


-(NSMutableDictionary*)getDefaultTags{
    
    NSMutableDictionary *tagData = [[NSMutableDictionary alloc] init];
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
    tagData[@"Key Center"] = [valueArray mutableCopy];
    
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
    tagData[@"Tempo"] = [valueArray mutableCopy];
    
    return tagData;
}

-(void)addTagsFromTemplate{
    
    //Create temp array to load dictionary
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    //Instrument specific tags
    
    //Bowed Strings
    if([_tagData objectForKey:@"Bowing Pattern"]== nil){
        if ([_userKeys[@"template"] isEqualToString:@"[ All Tags ]"] ||
            [_userKeys[@"template"] isEqualToString:@"Bowed String Tags"]){
            
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
        if ([_userKeys[@"template"] isEqualToString:@"[ All Tags ]"] ||
            [_userKeys[@"template"] isEqualToString:@"Woodwind Tags"] ||
            [_userKeys[@"template"] isEqualToString:@"Brass Tags"]){
            
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
        if ([_userKeys[@"template"] isEqualToString:@"[ All Tags ]"] ||
            [_userKeys[@"template"] isEqualToString:@"Brass Tags"]){
            
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
        if ([_userKeys[@"template"] isEqualToString:@"[ All Tags ]"] ||
            [_userKeys[@"template"] isEqualToString:@"Drum Tags"]){
            
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
        if ([_userKeys[@"template"] isEqualToString:@"[ All Tags ]"] ||
            [_userKeys[@"template"] isEqualToString:@"Guitar Tags"]){
            
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
