//
//  main.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AvatarChooserService.h"
#import "CLIChooseAvatarUseCase.h"
#import "RemoteGameRepository.h"
#import "GameDetailsPresenter.h"
#import "GamesListPresenter.h"
#import "PersistentImageRepository.h"
#import "SuggestAvatarService.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Invalid number of arguments -- expected: 1, actual: %d", argc - 1);
        }
        
        NSURL *directory = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
        
        /* FOR TESTING PURPOSES, REMOVE FOR PROD */
        NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory
                                                                   includingPropertiesForKeys:nil options:0 error:nil];
        for (NSURL *file in contents) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        
        RemoteGameRepository *gameRepo = [[RemoteGameRepository alloc] init];
        PersistentImageRepository *imageRepo = [[PersistentImageRepository alloc] initWithDownloadLocation:directory];
        AvatarChooserService *chooserService = [[AvatarChooserService alloc] initWithGameRepository:gameRepo];
        SuggestAvatarService *suggestService = [[SuggestAvatarService alloc] initWithImageRepository:imageRepo];
        
        CLIChooseAvatarUseCase *useCase = [[CLIChooseAvatarUseCase alloc] initWithAvatarChooseService:chooserService
                                                                                 suggestAvatarService:suggestService
                                                                                    completionHandler:^{
            exit(EXIT_SUCCESS);
        }];
        [useCase start];
        
        [NSRunLoop.mainRunLoop run];
    }
    return 0;
}
