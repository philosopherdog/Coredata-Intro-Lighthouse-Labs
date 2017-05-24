//
//  AppDelegate.m
//  UserDefaultsDemo
//
//  Created by steve on 2017-05-23.
//  Copyright © 2017 steve. All rights reserved.
//

#import "AppDelegate.h"

// Keys
static NSString *const kDarkThemeKey = @"kDarkThemeKey";
static NSString *const kLastAccessedKey = @"kLastAccessedKey";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self createSomeDefaults];
  [self accessDefaults];
  return YES;
}

- (void)createSomeDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:kDarkThemeKey];
  [defaults setObject:[NSDate date] forKey:kLastAccessedKey];
  [defaults synchronize]; // you can call this if you want to force a save, but it will auto save
}

- (void)accessDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL darkThemeSelected = [defaults boolForKey:kDarkThemeKey];
  NSDate *lastAccessedDate = [defaults objectForKey:kLastAccessedKey];
  NSLog(@"line: %d -- %@", __LINE__, darkThemeSelected ? @"Dark Theme Selected": @"Light Theme Selected");
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterShortStyle;
  formatter.timeStyle = NSDateFormatterShortStyle;
  NSLog(@"line: %d-- %@", __LINE__, [formatter stringFromDate:lastAccessedDate] );
}



@end
