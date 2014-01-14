//
//  PriceBTCViewController.h
//  Satoshi
//
//  Created by Jason Ravel on 1/4/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface PriceBTCViewController : UIViewController
{
}


@property (retain, nonatomic) IBOutlet UILabel *myBalance;
@property (retain, nonatomic) IBOutlet UILabel *btcPrice;

//Core data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
