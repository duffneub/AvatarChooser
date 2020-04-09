//
//  GamesListCLI.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GamesListCLI.h"

#include <iostream>
using namespace std;

#import "Game.h"
#import "Avatar.h"

#import "ChooseGameService.h"
#import "RemoteGameRepository.h"

@interface GamesListCLI () <GamesListView>
@end

@implementation GamesListCLI
@synthesize presenter;

- (void)run {
    [self.presenter attachView:self];
}

#pragma mark - GamesListView

- (void)reloadGamesList {
    dispatch_async(dispatch_get_main_queue(), ^{
        cout << "Games with Avatars:\n";
        
        NSUInteger numberOfGames = [self.presenter numberOfGames];
        for (int i = 0; i < numberOfGames; i++) {
            NSString *name = [self.presenter nameOfGameAtIndex:i];
            NSUInteger numberOfAvatars = [self.presenter numberOfAvatarsForGameAtIndex:i];
            printf("\t%d. %s (%ld)\n", i+1, name.UTF8String, numberOfAvatars);
        }
        
        [self listenForUserToChooseGame];
    });
}

- (void)listenForUserToChooseGame {
    NSUInteger numberOfGames = [self.presenter numberOfGames];
    cout << "Please enter an integer between 1 and " << numberOfGames << ":\n";
    
    int game;
    cin >> game;
    
    // Should validation logic be in presenter?
    if (1 <= game && game <= numberOfGames) {
        [self.presenter userDidSelectGameAtIndex:game - 1];
    } else {
        cin.clear();
        cin.ignore(INT_MAX, '\n');

        cout << "Invalid entry. Try again.\n";
        [self listenForUserToChooseGame];
        return;
    }
}

@end
