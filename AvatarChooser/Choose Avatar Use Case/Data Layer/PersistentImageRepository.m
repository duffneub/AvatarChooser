//
//  PersistentImageRepository.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "PersistentImageRepository.h"

#import "Avatar.h"

@interface PersistentImageRepository ()
@property (copy, nonatomic) NSURL *location;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation PersistentImageRepository

- (instancetype)initWithDownloadLocation:(NSURL *)location {
    if (self = [super init]) {
        self.location = location;
        self.session = [NSURLSession sharedSession];
        self.fileManager = [NSFileManager defaultManager];
        
        [self createDirectoryIfNeeded:location];
    }
    
    return self;
}

- (BOOL)createDirectoryIfNeeded:(NSURL *)directory {
    BOOL success = YES;
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory.path isDirectory:&isDir];
    
    if (fileExists && !isDir) {
        success = NO;
    } else if (!fileExists) {
        success = [[NSFileManager defaultManager] createDirectoryAtURL:directory withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        // Make sure it is empty
//        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:0 error:nil];
//        success = contents.count == 0;
//        cout << "Error: '" << directory.path.UTF8String << "' must be empty.\n";
    }
    
    return success;
}

- (void)deleteAll {
    [self deleteWithBlock:^BOOL(NSURL * _Nonnull url) {
        return YES;
    }];
}

- (void)deleteWithBlock:(BOOL (^)(NSURL *url))block {
    NSArray<NSURL *> *contents = [self.fileManager contentsOfDirectoryAtURL:self.location includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in contents) {
        if (block(file)) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
    }
}

- (void)addImageWithContentsOfURL:(NSURL *)url {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSURL *destination = [self.location URLByAppendingPathComponent:url.lastPathComponent];
        [self.fileManager moveItemAtURL:location toURL:destination error:nil];
    }];
    [task resume];
}

@end
