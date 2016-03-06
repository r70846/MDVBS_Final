//
//  DataStore.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/21/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

static DataStore *_sharedInstance;


- (id) init
{
    if (self = [super init])
    {
        //Create Array to hold Sessions Data
        _sessions = [[NSMutableArray alloc] init];
        
        //Create Dictionary Object to hold tag data
        _tagData = [[NSMutableDictionary alloc]init];
        
        //Create "Session" Dictionary Object to hold session data
        _currentSession = [[NSMutableDictionary alloc]init];
        [self resetCurrentSession];
        
        //Static Data
        _topicArray = [[NSMutableArray alloc] init];
        [_topicArray addObject:@"All of Me"];
        [_topicArray addObject:@"How High the Moon"];
        [_topicArray addObject:@"Autumn Leaves"];
        [_topicArray addObject:@"Bach Minuet in D"];
        [_topicArray addObject:@"Malaguena"];
        [_topicArray addObject:@"Minor 7th Arpeggio"];
        [_topicArray addObject:@"Major 7th Arpeggio"];
        [_topicArray addObject:@"Diminished 7th Arpeggios"];
        [_topicArray addObject:@"Augmented 7th Arpeggios"];
        [_topicArray addObject:@"Major Scale"];
        [_topicArray addObject:@"Natural Minor Scale"];
        [_topicArray addObject:@"Harmonic Minor Scale"];
        [_topicArray addObject:@"Melodic Minor Scale"];
        [_topicArray addObject:@"Diminished Scale"];
        [_topicArray addObject:@"Whole Tone Scale"];
        [_topicArray addObject:@"Dorian Mode"];
        [_topicArray addObject:@"Phrygian Mode"];
        
    ///////// LOAD MENUS: TOPICS, TAGS, AND VALUES
        
    //Create temp array to load dictionary
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];

        //Key Center
        [valueArray removeAllObjects];
        [valueArray addObject:@"A"];
        [valueArray addObject:@"A#"];
        [valueArray addObject:@"Bb"];
        [valueArray addObject:@"C"];
        [valueArray addObject:@"C#"];
        [valueArray addObject:@"Db"];
        [valueArray addObject:@"D"];
        [valueArray addObject:@"D#"];
        [valueArray addObject:@"Eb"];
        [valueArray addObject:@"E"];
        [valueArray addObject:@"F"];
        [valueArray addObject:@"F#"];
        [valueArray addObject:@"Gb"];
        [valueArray addObject:@"G"];
        [valueArray addObject:@"G#"];
        [valueArray addObject:@"Ab"];
        _tagData[@"Key Center"] = [valueArray mutableCopy];
    
        //Tempo
        [valueArray removeAllObjects];
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
        
        //Bowing Pattern
        [valueArray removeAllObjects];
        [valueArray addObject:@"Straight Bowing"];
        [valueArray addObject:@"Shuffle Bowing"];
        [valueArray addObject:@"Swing Bowing"];
        [valueArray addObject:@"Chain Bowing"];
        [valueArray addObject:@"Long Bow"];
        [valueArray addObject:@"Three Notes Per Bow"];
        _tagData[@"Bowing Pattern"] = [valueArray mutableCopy];
        
        
        //Tonguing Technique
        [valueArray removeAllObjects];
        [valueArray addObject:@"Single Tongue"];
        [valueArray addObject:@"Double Tongue"];
        [valueArray addObject:@"Triple Tongue"];
        _tagData[@"Tonguing Technique"] = [valueArray mutableCopy];
        
        //Lip Slurs
        [valueArray removeAllObjects];
        [valueArray addObject:@"Two Note Slurs"];
        [valueArray addObject:@"Three Note Slurs"];
        [valueArray addObject:@"Four Note Slurs"];
        _tagData[@"Lip Slurs"] = [valueArray mutableCopy];
        
        //Drum Stick Grip
        [valueArray removeAllObjects];
        [valueArray addObject:@"Traditional Grip"];
        [valueArray addObject:@"Reverse Traditional Grip"];
        [valueArray addObject:@"German Grip"];
        [valueArray addObject:@"French Grip"];
        [valueArray addObject:@"American Grip"];
        _tagData[@"Drum Stick Grip"] = [valueArray mutableCopy];
        
        //Picking Technique
        [valueArray removeAllObjects];
        [valueArray addObject:@"Down Picking"];
        [valueArray addObject:@"Alternate Picking"];
        [valueArray addObject:@"Sweep Picking"];
        [valueArray addObject:@"Finger Picking"];
        _tagData[@"Picking Technique"] = [valueArray mutableCopy];
        
        NSLog(@"%@", _tagData);
        
        //Boolean Connectivity Monitor
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



@end
