//
//  HistoryContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "HistoryContentViewController.h"
#import "HistoryViewController.h"

@interface HistoryContentViewController ()

@end

@implementation HistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {

    [historyTableView reloadData ];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger iCnt;
    if (tableView==historyTableView)
    {
        iCnt = [dataStore.sessions count];
    }
    else if (tableView==detailTableView)
    {
        iCnt = 0;
    }
    else
    {
        iCnt = 0;
    }
    return iCnt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView==historyTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        if(cell != nil)
        {
            //Get data
            NSMutableDictionary *session = [dataStore.sessions objectAtIndex:indexPath.row];
           NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[session objectForKey:@"date"], [session objectForKey:@"time"]];
            
            //Load cell
            cell.textLabel.text = [session objectForKey:@"topic"];
            cell.detailTextLabel.text = dateTime;
           
        }
    }
    else if (tableView==detailTableView)
    {
        cell = nil;
    }

    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClick:(UIButton *)button
{
    HistoryViewController *historyViewController = (HistoryViewController*) self.parentViewController;

    [historyViewController setScrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
