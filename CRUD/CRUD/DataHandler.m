//
//  DataHandler.m
//  CRUD
//
//  Created by steve on 2017-09-27.
//  Copyright © 2017 steve. All rights reserved.
//

#import "DataHandler.h"
#import "AppDelegate.h"

@interface DataHandler()
@property (nonatomic, weak) AppDelegate *delegate;
@property (nonatomic) NSManagedObjectContext *context;
@end

@implementation DataHandler
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.delegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    self.context = self.delegate.persistentContainer.viewContext;
  }
  return self;
}

- (NSArray<Person*>*)fetchData {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
  NSSortDescriptor *lastNameDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:NO];
  request.sortDescriptors = @[lastNameDesc];
  return [self.context executeFetchRequest:request error:nil];
}

- (void)savePerson:(NSDictionary *)dict {
  Person *person = [[Person alloc] initWithContext:self.context];
  person.firstName = dict[@"fName"];
  person.lastName = dict[@"lName"];
  person.age = [dict[@"age"] intValue];
  [self.context insertObject:person];
  [self.delegate saveContext];
}
@end
