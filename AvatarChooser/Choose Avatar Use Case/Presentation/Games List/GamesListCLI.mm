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
#import "GamesListPresenter.h"
#import "RemoteGameRepository.h"

@interface GamesListCLI () <GamesListView>
@property (strong, nonatomic) GamesListPresenter *presenter;

// UI State
@property (strong, nonatomic) NSArray<GameViewModel *> *games;
@end

@implementation GamesListCLI

- (instancetype)initWithPresenter:(GamesListPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
    }
    
    return self;
}

- (void)run {
    [self.presenter presentView:self];
}

#pragma mark - GamesListView

- (void)setGamesList:(NSArray<GameViewModel *> *)games {
    self.games = games;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _displayGamesList];
        [self _waitForUserToChooseGame];
    });
}

- (void)_displayGamesList {
    cout << "Games with Avatars:\n";
    
    [self.games enumerateObjectsUsingBlock:^(GameViewModel * _Nonnull game, NSUInteger idx, BOOL * _Nonnull stop) {
        printf("\t%ld. %s\n", idx + 1, game.gameDescription.UTF8String);
    }];
}

- (void)_waitForUserToChooseGame {
    int gamePlace;
    
    cout << "Please enter an integer between 1 and " << self.games.count << ":\n";
    cin >> gamePlace;
    
    // Seems like validation logic should be in presenter?
    [self.presenter userDidSelectGameAtIndex:gamePlace - 1];
}

@end
