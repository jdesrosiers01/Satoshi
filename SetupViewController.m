//
//  SetupViewController.m
//  Satoshi
//
//  Created by Jason Ravel on 1/7/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import "SetupViewController.h"
#import "PriceBTCViewController.h"
#import "AppDelegate.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

@synthesize myBalanceTextField = _myBalanceTextField;
@synthesize firstQuestion = _firstQuestion;
@synthesize myBalance = _myBalance;
@synthesize myCurrency = _myCurrency;
@synthesize priceAlerts = _priceAlerts;
@synthesize animationNumber = _animationNumber;
@synthesize dummyLabel1 = _dummyLabel1;
@synthesize dummyLabel2 = _dummyLabel2;
@synthesize bitcoinLogo = _bitcoinLogo;


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
    
    //Set number of lines equal to 2
    self.firstQuestion.lineBreakMode = NSLineBreakByWordWrapping;
    self.firstQuestion.numberOfLines = 4;
    
    //[1] make textfield black and delegate it
    self.myBalanceTextField.backgroundColor = [UIColor blackColor];
    self.myBalanceTextField.delegate = self;
    self.bitcoinLogo.hidden = YES;
    //[2] Set animation number to 1
    self.animationNumber = [NSNumber numberWithInt:1];

    
    //[3] show the typing text animation
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [self animateLabelShowText:@"How many BTC do you own?" characterDelay:0.1];
                    
                   });

}
//whenever the user hits next on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    //[1] Set myBalance to value typed.
    if([self.animationNumber intValue] ==1)
    {
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *setMe = [formatter numberFromString:self.myBalanceTextField.text];
       if(!setMe)
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"That isn't a valid number. Please enter a valid number." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
           [alert release];
           [formatter release];
           return NO;
       }
       else
       {
        self.myBalance = setMe;
        [formatter release];
       }

    }
    else if ([self.animationNumber intValue] == 2)
    {
        if([self isValidCurrency:self.myBalanceTextField.text] == YES)
        {
            self.myCurrency = self.myBalanceTextField.text;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"That isn't a valid Currency. Please enter a valid currency." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    else if ([self.animationNumber intValue] == 3)
    {
        NSArray *items = [self.myBalanceTextField.text componentsSeparatedByString:@","];
        for(NSString *current_string in items)
        {
            NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:current_string];
            
            if (![_NumericOnly isSupersetOfSet: myStringSet])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"One or more of those prices aren't valid integers. That, or you put a space between commas. No spaces." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return NO;
                
                
            }
            else
            {

                NSString *prices = self.myBalanceTextField.text;
                self.priceAlerts = [prices componentsSeparatedByString:@","];

            }
           
        }
    }
    
    
    //[2] Fade the text out
    self.firstQuestion.alpha = 1;
    self.myBalanceTextField.alpha = 1;
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ self.firstQuestion.alpha = 0;
                             self.myBalanceTextField.alpha = 0;}
                         completion:^(BOOL finished){
                             //Once the text has faded out
                             //increment the animation number
                             int count = [self.animationNumber intValue];
                             self.animationNumber = [NSNumber numberWithInt:count + 1];
                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                                            ^{
                                                 self.firstQuestion.alpha = 1;
                                                 self.myBalanceTextField.text = @"";
                                                 self.myBalanceTextField.alpha = 1;
                                                if([self.animationNumber intValue] == 2)
                                                {
                                                    [self animateLabelShowText:@"What currency do you use? (e.g.,USD,JPY,EUR)" characterDelay:0.1];
                                                }
                                                if([self.animationNumber intValue] == 3)
                                                {
                                                    [self animateLabelShowText:@"What prices shall I notify you of? (e.g.,1000,500,230)" characterDelay:0.1];
                                                }
                                                if([self.animationNumber intValue] == 4)
                                                {
                                                    [self animateLabelShowText:@"Welcome to the revolution." characterDelay:0.1];
                                                  
                                                }
                                                
                                            });
                         }];
    
    
    //[3] Remove Keyboard
    [textField resignFirstResponder];
    
    
   
    
    
    return NO;
}

//Satoshi's typing
- (void)animateLabelShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay
{
    [self.firstQuestion setText:@""];
    
    for (int i=0; i<newText.length; i++)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.firstQuestion setText:[NSString stringWithFormat:@"%@%C", self.firstQuestion.text, [newText characterAtIndex:i]]];
                           
                           if(i == newText.length -1 && [self.animationNumber intValue] == 4)
                           {
                            self.firstQuestion.text = @"";
                            self.myBalanceTextField.text = @"";
                            self.dummyLabel1.text = @"";
                            self.dummyLabel2.text = @"";
                            self.bitcoinLogo.hidden = NO;
                               
                               //Show Logo Animation
                               self.bitcoinLogo.alpha = 0;
                               [UIView beginAnimations:@"fade in" context:nil];
                               [UIView setAnimationDuration:3.0];
                               self.bitcoinLogo.alpha = 1.0;
                               [UIView setAnimationDelegate:self];
                               [UIView commitAnimations];

                         

                               
                               
                               //works!
                               NSLog(@"My balance is %@, my currency is %@, my alert prices are %@", self.myBalance, self.myCurrency, self.priceAlerts);
                           }
                           
                           
                       });
        
        [NSThread sleepForTimeInterval:delay];
        
        
        
    }
    
    
}

- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context
{
    if ([finished boolValue]) {
        NSLog(@"Animation Done!");
        //Go to the tabbar controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *test = [storyboard instantiateViewControllerWithIdentifier:@"tab"];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.window.rootViewController = test;
        [app.window makeKeyAndVisible];

    }
}




//Check if its a valid currency
-(BOOL) isValidCurrency:(NSString*) myCurrency
{
    
    NSArray *allCurrencies = [NSArray arrayWithObjects:@"USD", @"usd", @"EUR", @"eur", @"GBP", @"gbp", @"AUD", @"aud", @"CAD", @"cad", @"PLN", @"pln", @"RUB", @"rub", @"CNY", @"cny", @"JPY", @"jpy", @"INR", @"inr", nil];
    
    for(NSString *current_string in allCurrencies)
    {
        if([current_string isEqualToString: myCurrency])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myBalanceTextField release];
    [_firstQuestion release];
    [_myCurrency release];
    [_myBalance release];
    [_priceAlerts release];
    [_dummyLabel1 release];
    [_dummyLabel2 release];
    [_bitcoinLogo release];
    [super dealloc];
}


@end
