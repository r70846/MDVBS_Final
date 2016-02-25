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

@property (nonatomic)BOOL isOnline;


@property (nonatomic, strong)NSMutableDictionary *tagData;
@property (nonatomic, strong)NSMutableDictionary *currentSession;
@property (nonatomic, strong) NSDate *startDateTime;
@property (nonatomic, strong)NSMutableArray *sessions;


@property (nonatomic, strong)NSString *jsonPath;
@property (nonatomic, strong)NSString *csvPath;

@end