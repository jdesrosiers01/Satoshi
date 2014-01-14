//
//  RedditLinkViewController.m
//  Satoshi
//
//  Created by Jason Ravel on 1/13/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import "RedditLinkViewController.h"
#import "RedditBTCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentViewController.h"


@interface RedditLinkViewController ()
//@property (strong) UINavigationBar* navigationBar;
@property (strong) UIView* bottomBar;
@property (strong) UIView* topBar;


@end

@implementation RedditLinkViewController

@synthesize linkView = _linkView;


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
    [super viewDidLoad];
    
    //retrieve link selected from nsuserdefaults
    NSString *fullURL = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"url_selected"];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.linkView loadRequest:requestObj];
	
    

    //add back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Back"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //add bottom bar
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0,530,320,40)];
    [self makeButtonShiny:self.bottomBar withBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_bottomBar];
    
    
    //add top bar
    self.topBar = [[UIView alloc] initWithFrame:CGRectMake(0,21,320,40)];
    [self makeButtonShiny:self.topBar withBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_topBar];
    
    //add back button
    UIFont *smallestFont = [ UIFont fontWithName: @"Courier" size: 14.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(goBack)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    button.frame = CGRectMake(5.0, 20.0, 50.0, 40.0);
    button.titleLabel.textColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.titleLabel.font = smallestFont;
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:button];
    
    //add comments button
    UIButton *commentsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [commentsButton addTarget:self
               action:@selector(gotoComments)
     forControlEvents:UIControlEventTouchDown];
    [commentsButton setTitle:@"comments" forState:UIControlStateNormal];
    commentsButton.frame = CGRectMake(130, 530.0, 70.0, 40.0);
    commentsButton.titleLabel.textColor = [UIColor orangeColor];
    [commentsButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    commentsButton.titleLabel.font = smallestFont;
    commentsButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commentsButton];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:commentsButton];
    

    
   
}
-(void) gotoComments
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

    CommentViewController *commentView = [storyboard instantiateViewControllerWithIdentifier:@"commentView"];
    [commentView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:commentView animated:YES completion:^{
        NSLog(@"It worked");
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


#pragma mark navbar delegation




-(void) goBack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    RedditBTCViewController *redditBTC = [storyboard instantiateViewControllerWithIdentifier:@"tab"];
    [redditBTC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:redditBTC animated:YES completion:^{
        NSLog(@"it worked");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_linkView release];
    [super dealloc];
}
@end
