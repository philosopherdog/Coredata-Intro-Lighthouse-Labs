//
//  AppDelegate.m
//  FileSystemDemo
//
//  Created by steve on 2017-05-23.
//  Copyright © 2017 steve. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  [self testAccessDocumentsFolder];
  [self testAccessDocumentsFolderSecondWay];
  [self testSaveStringToDisk];
  [self testReadTextFileFromDisk];
  [self testWriteImageToTempFolder];
  [self testReadImageFromTempFolder];
  return YES;
}


#pragma mark - NSFileManager File System
/*
 - (NSArray<NSURL *> *)URLsForDirectory:(NSSearchPathDirectory)directory inDomains:(NSSearchPathDomainMask)domainMask;
 
 */

- (void)testAccessDocumentsFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray<NSURL *> *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
  
  NSLog(@"%d: %@", __LINE__, documentsURL);
  
  NSString *documentPathComponent = [documentsURL[0] lastPathComponent];
  NSString *expected = @"Documents";
  NSAssert([expected isEqualToString:documentPathComponent], @"last path component should be 'Documents'");
}


/*
 - (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domain appropriateForURL:(NSURL *)url create:(BOOL)shouldCreate error:(NSError * _Nullable *)error;
 */

- (void)testAccessDocumentsFolderSecondWay {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *libraryURL = [fileManager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
  NSLog(@"%d: %@", __LINE__, libraryURL);
  
  NSString *libraryPathComponent = [libraryURL lastPathComponent];
  NSString *expected = @"Library";
  NSAssert([expected isEqualToString:libraryPathComponent], @"last path component should be 'Library'");
}

#pragma mark - String to Disk

- (void)testSaveStringToDisk {
  NSString *str = @"Hello from LHL";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
  documentURL = [documentURL URLByAppendingPathComponent:@"test.txt"];
  if ([fileManager fileExistsAtPath:documentURL.path]) {
    return;
  }
  NSLog(@"%d: %@", __LINE__, documentURL);
  BOOL result = [str writeToURL:documentURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
  NSAssert(result == YES, @"Should write to file system");
}

- (void)testReadTextFileFromDisk {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
  documentURL = [documentURL URLByAppendingPathComponent:@"test.txt"];
  if (![fileManager fileExistsAtPath:documentURL.path]) {
    return;
  }
  NSString *str = [NSString stringWithContentsOfURL:documentURL encoding:NSUTF8StringEncoding error:nil];
  NSAssert([str isEqualToString:@"Hello from LHL"], @"couldn't get string from file system, make sure testSaveStringToDisk runs first");
}

#pragma mark - UIImage to Disk

- (void)testWriteImageToTempFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *tempDir = [NSURL URLWithString:NSTemporaryDirectory()];
  tempDir = [tempDir URLByAppendingPathComponent:@"data"];
  if ([fileManager fileExistsAtPath:tempDir.path]) {
    return;
  }
  NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"toronto.jpg"], 1.0);
  BOOL result = [fileManager createFileAtPath:tempDir.path contents:data attributes:nil];
  NSAssert(result == YES, @"should be able to write");
}

- (void)testReadImageFromTempFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *tempDir = [NSURL URLWithString:NSTemporaryDirectory()];
  tempDir = [tempDir URLByAppendingPathComponent:@"data"];
  if (![fileManager fileExistsAtPath:tempDir.path]) {
    return;
  }
  NSData *data = [fileManager contentsAtPath:tempDir.path];
  UIImage *image = [UIImage imageWithData:data];
  NSLog(@"%d: %@", __LINE__, image);
}

@end
