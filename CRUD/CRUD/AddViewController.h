//
//  AddViewController.h
//  CRUD
//
//  Created by steve on 2017-07-18.
//  Copyright © 2017 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
#import "Person+CoreDataClass.h"

@interface AddViewController : UIViewController
@property (nonatomic,weak) AppDelegate *delegate;
@property (nonatomic) NSManagedObjectContext *context;
@end
