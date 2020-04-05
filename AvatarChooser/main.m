//
//  main.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AvatarChooser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Invalid number of arguments -- expected: 1, actual: %d", argc - 1);
        }
        
        NSURL *directory = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
        NSLog(@"Duff -- Download avatars to %@", directory.absoluteString);
        
        AvatarChooser *chooser = [[AvatarChooser alloc] initWithDownloadsDirectory:directory];
        [chooser run];
        
        [NSRunLoop.mainRunLoop run];
    }
    return 0;
}
