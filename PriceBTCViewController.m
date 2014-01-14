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
    
    //Fetch object from core data
    //Fetch from core data and see if something exists
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"BTC"
                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    
    //if something exists go straight to the tab bar, else show the animation
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"the count is %lu and the array is %@", (unsigned long)count, array);
    }
    
    
    
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
