//
//  PracticeContentViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "PracticeContentViewController.h"
#import "PracticeViewController.h"

@interface PracticeContentViewController ()

@end

@implementation PracticeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Static Data
    topicArray = [[NSMutableArray alloc] init];
    [topicArray addObject:@"Major Scale"];
    [topicArray addObject:@"Natural Minor Scale"];
    [topicArray addObject:@"Harmonic Minor Scale"];
    [topicArray addObject:@"Melodic Minor Scale"];
    [topicArray addObject:@"Diminished Scale"];
    [topicArray addObject:@"Whole Tone Scale"];
    [topicArray addObject:@"Dorian Mode"];
    [topicArray addObject:@"Phrygian Mode"];
    
    tagArray = [[NSMutableArray alloc] init];
    [tagArray addObject:@"Key Center"];
    [tagArray addObject:@"Practice Tempo"];
    [tagArray addObject:@"Bowing Pattern"];
    
    //Establishing Screen Size
    /*
     int iWidth = [[UIScreen mainScreen] bounds].size.width;
     int iHeight = [[UIScreen mainScreen] bounds].size.height;
     int iTabHeight = [[[self tabBarController] tabBar] bounds].size.height;
     NSLog(@"w=%d, h=%d, t=%d", iWidth, iHeight, iTabHeight);
     */
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==topicTableView)
    {
        return [topicArray count];
    }
    else
    {
        return [tagArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView==topicTableView)
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        if(cell != nil)
        {
            cell.textLabel.text = (NSString*)[topicArray objectAtIndex:indexPath.row];
        }
    }
    else
    {
        //Get the cell..
        cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
        if(cell != nil)
        {
            cell.textLabel.text =(NSString*)[tagArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = @"[ None ]";
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    
    if (tableView==topicTableView)
    {
            topicDisplayLabel.text = [topicArray objectAtIndex:indexPath.row];
            PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
            practiceViewController.iDisplayMode = 600;
            [practiceViewController setScrollView];
    }
    else
    {
        
    }
    
}


-(IBAction)onClick:(UIButton *)button
{
    PracticeViewController *practiceViewController = (PracticeViewController*) self.parentViewController;
    practiceViewController.iDisplayMode = 0;
    [practiceViewController setScrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
