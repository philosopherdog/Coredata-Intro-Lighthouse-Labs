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
//  [self testAccessDocumentsFolderSecondWay];
//  [self testSaveStringToDisk];
//  [self testReadTextFileFromDisk];
//  [self testWriteImageToTempFolder];
//  [self testReadImageFromTempFolder];
  [self writeDictionaryToFileSystem];
//  [self readDictionaryfromFileSystem];
  return YES;
}


#pragma mark - NSFileManager File System
/*
 - (NSArray<NSURL *> *)URLsForDirectory:(NSSearchPathDirectory)directory inDomains:(NSSearchPathDomainMask)domainMask;
 
 */

- (void)testAccessDocumentsFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray<NSURL *> *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask];
  
  NSLog(@"\n%d: %@", __LINE__, documentsURL);
  
  NSString *documentPathComponent = [documentsURL.firstObject lastPathComponent];
  NSString *expected = @"Documents";
  NSAssert([expected isEqualToString:documentPathComponent], @"last path component should be 'Documents'");
}


/*
 - (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domain appropriateForURL:(NSURL *)url create:(BOOL)shouldCreate error:(NSError * _Nullable *)error;
 */

// Prefer this technique

- (void)testAccessDocumentsFolderSecondWay {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *libraryURL = [fileManager URLForDirectory:NSLibraryDirectory
                                          inDomain:NSUserDomainMask
                                 appropriateForURL:nil
                                            create:NO
                                             error:nil];
  NSLog(@"\n%d: %@", __LINE__, libraryURL);
  
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
  // don't do anything if the file already exists
  if ([fileManager fileExistsAtPath:documentURL.path]) {
    NSLog(@"\n%d: %@", __LINE__, @"File already exists, no writing");
    return;
  }
  NSLog(@"\n%d: %@", __LINE__, documentURL);
  BOOL result = [str writeToURL:documentURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
  NSAssert(result == YES, @"Should write to file system");
}

- (void)testReadTextFileFromDisk {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
  documentURL = [documentURL URLByAppendingPathComponent:@"test.txt"];
  if (![fileManager fileExistsAtPath:documentURL.path]) {
    NSLog(@"\n%d: %@", __LINE__, @"File doesn't exists, no reading");
    return;
  }
  NSString *str = [NSString stringWithContentsOfURL:documentURL encoding:NSUTF8StringEncoding error:nil];
  NSAssert([str isEqualToString:@"Hello from LHL"], @"couldn't get string from file system, make sure testSaveStringToDisk runs first");
  NSLog(@"\n%d: %@", __LINE__, str);
}

#pragma mark - UIImage to Disk

- (void)testWriteImageToTempFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *tempDir = [NSURL URLWithString:NSTemporaryDirectory()];
  tempDir = [tempDir URLByAppendingPathComponent:@"data"];
  if ([fileManager fileExistsAtPath:tempDir.path]) {
    NSLog(@"\n%d: %@", __LINE__, @"file already exists");
    return;
  }
  NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"toronto.jpg"], 1.0);
  BOOL result = [fileManager createFileAtPath:tempDir.path contents:data attributes:nil];
  NSAssert(result == YES, @"should be able to write");
  NSLog(@"\n%d: %@", __LINE__, @"image was written to temp file data");
}

- (void)testReadImageFromTempFolder {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *tempDir = [NSURL URLWithString:NSTemporaryDirectory()];
  tempDir = [tempDir URLByAppendingPathComponent:@"data"];
  if (![fileManager fileExistsAtPath:tempDir.path]) {
    NSLog(@"\n%d: %@", __LINE__, @"no image file exists to read");
    return;
  }
  NSData *data = [fileManager contentsAtPath:tempDir.path];
  UIImage *image = [UIImage imageWithData:data];
  NSLog(@"\n%d: %@: %@", __LINE__, @"raw image data dump", image);
}

// NSArray & NSDictionary Can Read/Write to File System

- (NSString *)pathToTempDirectoryWithComponent:(NSString *)component {
  NSURL *tempDir = [NSURL URLWithString:NSTemporaryDirectory()];
  tempDir = [tempDir URLByAppendingPathComponent:component];
  return tempDir.path;
}

- (void)writeDictionaryToFileSystem {
  NSString *path = [self pathToTempDirectoryWithComponent:@"MyDict"];
  NSDictionary *dict = @{@"name": @"Charlie Sheen", @"phone": @[@"555-555-5555", @"666-666-6666"]};
  BOOL success = [dict writeToFile:path atomically:YES];
  NSLog(@"\n%d: %@", __LINE__, success ? @"Dictionary successfully written": @"Dictionary borked");
}

- (void)readDictionaryfromFileSystem {
  NSString *path = [self pathToTempDirectoryWithComponent:@"MyDict"];
  NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:path];
  NSLog(@"\n%d: %@", __LINE__, result);
}








@end
