//
//  AddViewController.m
//  CRUD
//
//  Created by steve on 2017-07-18.
//  Copyright © 2017 steve. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveTapped:(UIBarButtonItem *)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
