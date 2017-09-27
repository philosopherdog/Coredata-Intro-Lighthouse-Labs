//
//  DataHandler.h
//  CRUD
//
//  Created by steve on 2017-09-27.
//  Copyright © 2017 steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+CoreDataClass.h"

@interface DataHandler : NSObject
- (NSArray<Person*>*)fetchData;
- (void)savePerson:(NSDictionary *)person;
@end
