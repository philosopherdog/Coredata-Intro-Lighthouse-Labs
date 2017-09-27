//
//  AppDelegate.m
//  CRUD
//
//  Created by steve on 2017-07-18.
//  Copyright © 2017 steve. All rights reserved.
//

#import "AppDelegate.h"
#import "Person+CoreDataClass.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation AppDelegate

/*
 CRUD
 - create
 - read/fetch
 - simple
 - sorted
 - filtered
 - update
 - delete
 */

//  [self createPerson]; // firstName, lastName, age
//  [self fetchPersons]; // simple fetch, loop through results
//  [self fetchWithSort]; // sort by age, ascending
//  [self fetchWithPredicate]; // fetch people where age > 30
//  [self fetchWithPredicateAndUpdate]; // fetch someone where name is Fred and update his age
//  [self deletePerson];



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.context = self.persistentContainer.viewContext;
//  [self createPerson];
//  [self fetchPersons];
//  [self fetchWithSort];
//  [self fetchWithPredicate];
//  [self fetchWithPredicateAndUpdate];
//  [self deletePerson];
  return YES;
}

#pragma mark - Create

- (void)createPerson {
  Person *p1 = [[Person alloc] initWithContext:self.context];
  p1.age = 44;
  p1.firstName = @"Fred";
  p1.lastName = @"FlintStone";
  
  Person *p2 = [[Person alloc] initWithContext:self.context];
  p2.age = 23;
  p2.firstName = @"Justin";
  p2.lastName = @"Bieber";
  
  Person *p3 = [[Person alloc] initWithContext:self.context];
  p3.age = 70;
  p3.firstName = @"Taylor";
  p3.lastName = @"Swift";
  [self saveContext];
}

#pragma mark - Read

- (void)fetchPersons {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
  NSArray <Person *>*persons = [self.context executeFetchRequest:request error:nil];
  [self printEntities:persons];
}

- (void)printEntities:(NSArray<Person *>*)entities {
  for (Person *person in entities) {
    NSLog(@"%@ %@ is %@ years old", person.firstName, person.lastName, @(person.age));
  }
}

- (void)fetchWithSort {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
  NSSortDescriptor *ageDesc = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
  request.sortDescriptors = @[ageDesc];
  NSArray <Person *>*persons = [self.context executeFetchRequest:request error:nil];
  [self printEntities:persons];
}

- (Person *)fetchWithPredicate {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age >= 70"];
  request.predicate = predicate;
  NSArray <Person *>*persons = [self.context executeFetchRequest:request error:nil];
  [self printEntities:persons];
  return persons.firstObject;
}

#pragma  mark - Update

- (void)fetchWithPredicateAndUpdate {
  Person *taylor = [self fetchWithPredicate];
  taylor.age = 71;
  [self saveContext];
  
}

#pragma mark - Delete

- (void)deletePerson {
  Person *taylor = [self fetchWithPredicate];
  [self.context deleteObject:taylor];
  [self saveContext];
}


- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
  @synchronized (self) {
    if (_persistentContainer == nil) {
      _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CRUD"];
      [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
          abort();
        }
      }];
    }
  }
  
  return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSError *error = nil;
  if ([self.context hasChanges] && ![self.context save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
}

@end
