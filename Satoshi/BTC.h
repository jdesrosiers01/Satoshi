//
//  BTC.h
//  Satoshi
//
//  Created by Jason Ravel on 1/14/14.
//  Copyright (c) 2014 Jason Ravel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTC : NSManagedObject

@property (nonatomic, retain) NSNumber * myBalance;
@property (nonatomic, retain) NSString * myCurrency;
@property (nonatomic, retain) NSString * myAlertPrices;

@end
