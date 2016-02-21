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
        //_sessions = [[NSMutableArray alloc] init];
        
        //Create Dictionary Object to hold tag data
        _tagData = [[NSMutableDictionary alloc]init];

        //Create Dictionary Object to hold tag data
        _currentSession = [[NSMutableDictionary alloc]init];
        
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
    
        //Bowing Pattern
        [valueArray removeAllObjects];
        [valueArray addObject:@"Staright Bowing"];
        [valueArray addObject:@"Shuffle Bowing"];
        [valueArray addObject:@"Swing Bowing"];
        [valueArray addObject:@"Chain Bowing"];
        [valueArray addObject:@"Long Bow"];
        [valueArray addObject:@"Three Notes Per Bow"];
        _tagData[@"Bowing Pattern"] = [valueArray mutableCopy];
        
        NSLog(@"%@", _tagData);
        
        //Boolean Connectivity Monitor
        _isOnline = false;
        
    }
    return self;
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
