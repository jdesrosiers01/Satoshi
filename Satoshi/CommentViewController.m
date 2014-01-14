//
//  CommentViewController.m
//  Satoshi
//
//  Created by Jason Ravel on 1/13/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import "CommentViewController.h"
#import "RedditBTCViewController.h"

@interface CommentViewController ()
{

}
@property (strong) UIView* topBar;



@property (retain, nonatomic) NSMutableArray *commentObjects;


@end

@implementation CommentViewController

@synthesize commentObjects = _commentObjects;

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
    //self.tableView.backgroundColor = [UIColor blackColor];

    //move tableview down to make room for navbar
   // [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,40)];
    [self makeButtonShiny:l withBackgroundColor:[UIColor blackColor]];

    l.text = @"Back";
    l.textColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = l;
    
    //add this
    [self.tableView setContentInset:UIEdgeInsetsMake(-l.bounds.size.height, 0.0f, 0.0f, 0.0f)];
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [l addGestureRecognizer:tapGestureRecognizer];
    l.userInteractionEnabled = YES;
    [tapGestureRecognizer release];


    
    //Comments For links
    NSString *article_id = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"article_id"];
    NSString *append_articleID = [article_id stringByAppendingString:@"/.json"];
    
    NSString *reddit_data_url = @"http://www.reddit.com/r/bitcoin/comments/";
    NSString *final_link = [reddit_data_url stringByAppendingString:append_articleID];
    
    NSURL *url = [[NSURL alloc] initWithString:final_link];
    
    
    //parse the nsdata received for commnet
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //fail
        } else
        {
            //put it into a dict
            
            id level1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            
            NSLog(@"the dict is %@", level1);
            
            NSArray *test = [level1 allObjects];
            NSLog(@"first is %@", [test objectAtIndex:1]);
            NSDictionary *level2 = [test objectAtIndex:1];
            NSLog(@"level 2 is %@", level2);
            NSDictionary *level3 = [level2 objectForKey:@"data"];
            NSLog(@"level 3 is %@", level3);
            NSDictionary *level4 = [level3 objectForKey:@"children"];
            NSLog(@"level 4 is %@", level4);
            
            self.commentObjects = [[NSMutableArray alloc] init];
            for(id key in level4)
            {
                NSLog(@"%lu comment size", (unsigned long)[level4 count]);
                NSLog(@"the value is %@",key);
                id val = key;
                NSDictionary *loop = val;
                NSLog(@"loop %@", loop);
                NSDictionary *inside_loop = [loop objectForKey:@"data"];
                NSLog(@"inside loop %@", inside_loop);
                NSLog(@"body: %@", [inside_loop objectForKey:@"body"]);
                   NSLog(@"author: %@", [inside_loop objectForKey:@"author"]);
                [self.commentObjects addObject:inside_loop];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.tableView reloadData];
                    
                });
                NSLog(@"its this %lu", (unsigned long)[self.commentObjects count]);

            }
            
            
     
            
        }
    }];
    
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) labelTapped
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    RedditBTCViewController *redditBTC = [storyboard instantiateViewControllerWithIdentifier:@"redditBTC"];
    [redditBTC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:redditBTC animated:YES completion:^{
        NSLog(@"it worked");
    }];
}

- (void)makeButtonShiny:(UIView*)button withBackgroundColor:(UIColor*)backgroundColor
{
    // Get the button layer and give it rounded corners with a semi-transparant button
    CALayer *layer = button.layer;
    // layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    // Create a shiny layer that goes on top of the button
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    // Set the gradient colors
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    // Set the relative positions of the gradien stops
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    // Add the layer to the button
    [button.layer addSublayer:shineLayer];
    
    [button setBackgroundColor:backgroundColor];
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
  NSLog(@"its this num rows %lu", (unsigned long)[self.commentObjects count]);
    return [self.commentObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
    
   
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    //get object
    NSDictionary *postObject = [self.commentObjects objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Courier" size: 12.0];
    UIFont *smallestFont = [ UIFont fontWithName: @"Courier" size: 8.0];
    
    NSString *author = [postObject objectForKey:@"author"];

    NSString *author_append1 = [author stringByAppendingString:@":  "];
    NSString *full_comment = [author_append1 stringByAppendingString:[postObject objectForKey:@"body"]];
    
    
    cell.textLabel.font = smallestFont;
    cell.textLabel.text = full_comment;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.numberOfLines = 10;
    
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
