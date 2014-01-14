//
//  PriceBTCViewController.m
//  Satoshi
//
//  Created by Jason Ravel on 1/4/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import "PriceBTCViewController.h"
#import "AppDelegate.h"
#import "BTC.h"


@interface PriceBTCViewController ()

@end

@implementation PriceBTCViewController

@synthesize myBalance = _myBalance;
@synthesize btcPrice = _btcPrice;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //show activity progress 
    
    //Fetch object from core data
    //Fetch from core data and see if something exists
    // initializing NSFetchRequest
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTC"
                                              inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"fetched %@", fetchedObjects);
    BTC *balance = [fetchedObjects objectAtIndex:0];
    NSLog(@"My balance is %@ %@ %@", balance.myBalance, balance.myAlertPrices, balance.myCurrency);
    self.myBalance.text = [balance.myBalance stringValue];
    
    //Get BTC Price
    //api ticker
    NSString *urlAsString = [NSString stringWithFormat:@"https://www.bitstamp.net/api/ticker/"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error");
        } else {
            [self receivedGroupsJSON:data];
        }
    }];
    
    
}

- (void)receivedGroupsJSON:(NSData *)data
{
    
    NSError *error = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        NSLog(@"Array: %@", jsonArray);
    }
    
    self.cost_of_one_bitcoin = [jsonArray objectForKey:@"last"];
    self.btcPrice.text = self.cost_of_one_bitcoin;
    
    double cal = [self.cost_of_one_bitcoin doubleValue] * ([self.myBalance.text doubleValue]);
    NSLog(@"cal is %f", cal);
    NSString *total_balance =[[NSString alloc] initWithFormat:@"%f",cal];

   
    self.myBalance.text = total_balance;
    
}

-(void) viewDidDisappear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myBalance release];
    [_btcPrice release];
    [super dealloc];
}
@end
