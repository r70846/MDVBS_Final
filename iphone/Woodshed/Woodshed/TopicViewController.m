//
//  TopicViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "TopicViewController.h"
#import "TagViewController.h"


@interface TopicViewController ()

@end

@implementation TopicViewController

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
    
    
    //Establishing Screen Size
    /*
    int iWidth = [[UIScreen mainScreen] bounds].size.width;
    int iHeight = [[UIScreen mainScreen] bounds].size.height;
    int iTabHeight = [[[self tabBarController] tabBar] bounds].size.height;
    NSLog(@"w=%d, h=%d, t=%d", iWidth, iHeight, iTabHeight);
    */
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Respond to click event
-(IBAction)onClick:(UIButton *)button
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the cell..
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];

    if(cell != nil)
    {
        cell.textLabel.text = (NSString*)[topicArray objectAtIndex:indexPath.row];;
    }
    return cell;
}


//This is called when we want to go to a new view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"segueToTagViewController"])
    {
        TagViewController *tagViewController = segue.destinationViewController;
        
        if(tagViewController != nil){
            if (sender != nil)                      //From a selected cell
            {
                UITableViewCell *cell = (UITableViewCell*)sender;
                NSIndexPath *indexPath = [topicTableView indexPathForCell:cell];
                
                //Get the object from the array based on the item in the tableview we clicked on
                tagViewController.topicString = [topicArray objectAtIndex:indexPath.row];
                
            }else{
                /*
                //From my 'New' button
                DoItem *doItem = [[DoItem alloc] init];
                doItem.doID = @"";
                doItem.doText = @"";
                doItem.doStatus = @"1";
                doItem.isNew = true;
                doItem.isUpdate = false;
                modViewController.currentDoItem = doItem;
                 */
            }
        }
    }else{

    }
     

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
