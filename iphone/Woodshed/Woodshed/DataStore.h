//
//  DataStore.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/21/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
{
    

}

+ (DataStore *) sharedInstance;


//App Status
@property (nonatomic)BOOL isOnline;


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
@property (nonatomic, strong)NSString *jsonPath;
@property (nonatomic, strong)NSString *csvPath;


-(void)resetCurrentSession;
-(void)loadTags;


@end