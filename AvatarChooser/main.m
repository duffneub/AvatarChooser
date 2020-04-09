//
//  main.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "ChooseAvatarSceneBuilder.h"

#import "ChooseGameService.h"
#import "ChooseAvatarCLI.h"
#import "RemoteGameRepository.h"
#import "GameDetailsPresenter.h"
#import "GamesListPresenter.h"
#import "PersistentImageRepository.h"
#import "SuggestAvatarService.h"

void cleanDirectory(NSURL *directory) {
    NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory
                                                               includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in contents) {
        [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
    }
}

ChooseAvatarSceneBuilder * makeBuildAvatarSceneBuilder(NSURL *directory) {
    NSURL *databaseURL = [NSURL URLWithString:@"https://clientupdate-v6.cursecdn.com/Avatars/"];
    RemoteGameRepository *gameRepo = [[RemoteGameRepository alloc] initWithBaseURL:databaseURL
                                                                     networkClient:[NSURLSession sharedSession]];
    PersistentImageRepository *imageRepo = [[PersistentImageRepository alloc] initWithDownloadLocation:directory];
    ChooseAvatarSceneBuilder *builder = [[ChooseAvatarSceneBuilder alloc] initWithGameRepository:gameRepo imageRepository:imageRepo];
    
    return builder;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSURL *executableLocation = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[0]]];
        NSString *executable = [executableLocation lastPathComponent];

        if ([executable isEqualToString:@"avatar-chooser"]) {
            NSURL *directory = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
            
            /* FOR TESTING PURPOSES, REMOVE FOR PROD */
            cleanDirectory(directory);

            ChooseAvatarCLI *cli = [[ChooseAvatarCLI alloc] initWithBuilder:makeBuildAvatarSceneBuilder(directory)];
            [cli run];
            [NSRunLoop.mainRunLoop run];
        } else {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
            NSURL *downloadsDir = [[NSURL fileURLWithPath:paths[0]] URLByAppendingPathComponent:@"Avatars/"];
            
            /* FOR TESTING PURPOSES, REMOVE FOR PROD */
            cleanDirectory(downloadsDir);
            
            [NSApplication sharedApplication];
            [[NSBundle mainBundle] loadNibNamed:@"MainMenu" owner:NSApp topLevelObjects:nil];
            ((AppDelegate *)[NSApp delegate]).chooseAvatarSceneBuilder = makeBuildAvatarSceneBuilder(downloadsDir);
            [NSApp run];
        }
    }
    
    return 0;
}
