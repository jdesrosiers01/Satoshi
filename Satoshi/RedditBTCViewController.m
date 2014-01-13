//
//  RedditBTCViewController.m
//  Satoshi
//
//  Created by Jason Ravel on 1/4/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import "RedditBTCViewController.h"

@interface RedditBTCViewController ()

@end

@implementation RedditBTCViewController

@synthesize redditObjects = _redditObjects;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self redditDataRequest];
    

}


-(void) redditDataRequest
{
     NSString *reddit_data_url = @"http://www.reddit.com/r/bitcoin/.json";
    NSError *error = nil;
    //[1] Store the url in NSData
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:reddit_data_url]];
    
    if (jsonData) {
        
        //[2] Convert NSData to id object
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            NSLog(@"error is %@", [error localizedDescription]);
            // Handle Error and return
            return;
        }
        
        
        NSDictionary *test = [jsonObjects objectForKey:@"data"];
        NSLog(@"im testing %@", test);
        NSDictionary *level2 = [test objectForKey:@"children"];
        NSLog(@"level 2 %@", level2);

        
        self.redditObjects = [[NSMutableArray alloc] init];
        for(id key in level2)
        {
            NSLog(@"the value is %@",key);
            id val = key;
            NSDictionary *loop = val;
            NSLog(@"loop %@", loop);
            NSDictionary *inside_loop = [loop objectForKey:@"data"];
            NSLog(@"inside loop %@", inside_loop);
            [self.redditObjects addObject:inside_loop];
        }
        
        
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Failed with Reddit network request" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    

    
}

-(void) viewDidUnload
{
  
}

-(void) dealloc
{
   
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"count is %lu" ,(unsigned long)[self.redditObjects count]);
    return [self.redditObjects count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reddit_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //TODO
    
    //1. title
    //2. poster name
    //3. num comments
    //4. timestamp
    //5. thumbnail
    
    //Get Object
    NSDictionary *postObject = [self.redditObjects objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Courier" size: 10.0];
    UIFont *smallestFont = [ UIFont fontWithName: @"Courier" size: 7.0];


    
    //[1] Get title
    NSString* title = [postObject objectForKey:@"title"];
    UILabel *title_label= [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 200,60)];
    title_label.backgroundColor = [UIColor blackColor];
    title_label.numberOfLines = 7;
    title_label.text = title;
    title_label.textColor = [UIColor greenColor];
    title_label.font = myFont;
    [cell addSubview:title_label];
  
    //[2] Get poster
    NSString *poster = [postObject objectForKey:@"author"];
    UILabel *poster_label= [[UILabel alloc] initWithFrame:CGRectMake(265, 40, 80,10)];
    poster_label.backgroundColor = [UIColor blackColor];
    poster_label.numberOfLines = 1;
    poster_label.text = poster;
    poster_label.textColor = [UIColor greenColor];
    poster_label.font = smallestFont;
    [cell addSubview:poster_label];
    
    //[3] Get # of comments
    NSNumber *num_comments = [postObject objectForKey:@"num_comments"];
    UILabel *num_comments_label= [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 20,10)];
    num_comments_label.backgroundColor = [UIColor blackColor];
    num_comments_label.numberOfLines = 1;
    num_comments_label.text = [num_comments stringValue];
    num_comments_label.textColor = [UIColor greenColor];
    num_comments_label.font = myFont;
    [cell addSubview:num_comments_label];
  
    
    //[4] Get Timestamp
    NSString *time_stamp = [postObject objectForKey:@"created_utc"];
    double unixTimeStamp = [time_stamp doubleValue];
    NSTimeInterval interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *date_string=[formatter stringFromDate:date];
    UILabel *time_label= [[UILabel alloc] initWithFrame:CGRectMake(265, 50, 80,10)];
    time_label.backgroundColor = [UIColor blackColor];
    time_label.numberOfLines = 1;
    time_label.text = date_string;
    time_label.textColor = [UIColor greenColor];
    time_label.font = smallestFont;
    [cell addSubview:time_label];
    
    
    //[5] Get Thumbnail
    NSString *ImageURL =[postObject objectForKey:@"thumbnail"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    UIImageView *thumbnail_image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
    thumbnail_image.image = [UIImage imageWithData:imageData];
    [cell addSubview:thumbnail_image];
    
    UIImageView *comment_icon = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 20,10)];
    comment_icon.image = [UIImage imageNamed:@"comment-icon.png"];
    [cell addSubview:comment_icon];

    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
