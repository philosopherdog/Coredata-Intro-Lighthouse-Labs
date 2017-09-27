//
//  TableViewController.m
//  CRUD
//
//  Created by steve on 2017-07-18.
//  Copyright © 2017 steve. All rights reserved.
//

#import "TableViewController.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"
#import "AddViewController.h"

@interface TableViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray<Person*>*persons;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic, weak) AppDelegate *delegate;
@end

@implementation TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.delegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
  self.context = self.delegate.persistentContainer.viewContext;
  [self fetchData];
  [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fetchData) name:NSManagedObjectContextDidSaveNotification object:nil];
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  Person *person = self.persons[indexPath.row];
  cell.textLabel.text = person.lastName;
  cell.detailTextLabel.text = person.firstName;
  return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"AddViewController"]) {
    AddViewController *avc = segue.destinationViewController;
    avc.delegate = self.delegate;
    avc.context = self.context;
  }
}

#pragma mark - Core Data

- (void)fetchData {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
  NSSortDescriptor *lastNameDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:NO];
  request.sortDescriptors = @[lastNameDesc];
  NSArray <Person *>*persons = [self.context executeFetchRequest:request error:nil];
  self.persons = persons;
  [self.tableView reloadData];
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self];
}


@end
