//
//  ViewController.m
//  CoreDataIntro
//
//  Created by steve on 2016-11-23.
//  Copyright © 2016 steve. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"
@import CoreData;

@interface ViewController ()
@property (nonatomic, weak) AppDelegate *appDelegate;
@end

/*
 
 CRUD
 - create
 - read
 - update
 - delete
 */

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  self.context = self.appDelegate.persistentContainer.viewContext;
//  [self createPerson];
//  [self fetchPersons];
//  [self fetchWithSort];
//  [self fetchWithPredicate];
//  [self fetchWithPredicateAndUpdate];
  [self deletePerson];
}

- (void)createPerson {
  Person *newObject = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"Person"
                                         inManagedObjectContext:self.context];
  newObject.firstName = @"Jane";
  newObject.lastName = @"Green";
  newObject.age = 24;
  [self.appDelegate saveContext];
}

- (void)fetchPersons {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person"
                                            inManagedObjectContext:self.context];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  NSArray <Person*>* fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
//  if (fetchedObjects == nil) {
//    
//  }
//  if (error != nil) {
//    
//  }
  
  for (Person *person in fetchedObjects) {
    NSLog(@"fName %@", person.firstName);
    NSLog(@"lName %@", person.lastName);
    NSLog(@"age %@", @(person.age));
  }
}

- (void)fetchWithSort {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person"
                                            inManagedObjectContext:self.context];
  [fetchRequest setEntity:entity];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                                 ascending:YES];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  NSError *error;
  NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
  for (Person *person in fetchedObjects) {
    NSLog(@"fName %@", person.firstName);
    NSLog(@"lName %@", person.lastName);
    NSLog(@"age %@", @(person.age));
  }
}

- (Person *)fetchWithPredicate {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person"
                                            inManagedObjectContext:self.context];
  [fetchRequest setEntity:entity];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > 30"];
  [fetchRequest setPredicate:predicate];
  
  NSError *error;
  NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
  for (Person *person in fetchedObjects) {
    NSLog(@"fName %@", person.firstName);
    NSLog(@"lName %@", person.lastName);
    NSLog(@"age %@", @(person.age));
  }
  return [fetchedObjects firstObject];
}

- (void)fetchWithPredicateAndUpdate {
  Person *fred = [self fetchWithPredicate];
  fred.age += 1;
  [self.appDelegate saveContext];
  
  Person *updatedFred = [self fetchWithPredicate];
  NSLog(@"age %@", @(updatedFred.age));
}

- (void)deletePerson {
  Person *fred = [self fetchWithPredicate];
  [self.context deleteObject:fred];
  [self.appDelegate saveContext];
}

@end
