//
//  SetupViewController.h
//  Satoshi
//
//  Created by Jason Ravel on 1/7/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController <UITextFieldDelegate>


//UI
@property (retain, nonatomic) IBOutlet UITextField *myBalanceTextField;
@property (retain, nonatomic) IBOutlet UILabel *firstQuestion;
@property (retain, nonatomic) IBOutlet UILabel *dummyLabel1;
@property (retain, nonatomic) IBOutlet UILabel *dummyLabel2;
@property (retain, nonatomic) IBOutlet UIImageView *bitcoinLogo;


//Counter for animations
@property (retain, nonatomic) NSNumber *animationNumber;


//Save Data
@property (retain, nonatomic) NSNumber *myBalance;
@property (retain, nonatomic) NSString *myCurrency;
@property (retain, nonatomic) NSArray *priceAlerts;


//Satoshi's Animation
- (void)animateLabelShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay;


@end
