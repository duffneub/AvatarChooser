//
//  ChooseAvatarCLI.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "ChooseAvatarCLI.h"

#import "ChooseAvatarSceneBuilder.h"
#import "ChooseGameService.h"
#import "GamesListCLI.h"
#import "GameDetailsCLI.h"
#import "GameDetailsPresenter.h"
#import "GamesListPresenter.h"
#import "SuggestAvatarService.h"

@interface ChooseAvatarCLI () <GamesListRouter, GameDetailsRouter>
@property (strong, nullable) ChooseAvatarSceneBuilder *builder;
//@property (strong, nonatomic) ChooseGameService *chooseGameService;
//@property (strong, nonatomic) SuggestAvatarService *suggestAvatarService;
//@property (copy, nonatomic) void (^completionHandler)(void);
@property (strong, nonatomic) GamesListCLI *gamesListCLI;
@end

@implementation ChooseAvatarCLI

- (instancetype)initWithBuilder:(ChooseAvatarSceneBuilder *)builder {
    if (self = [super init]) {
        self.builder = builder;
    }
    
    return self;
}

- (void)run {
    [self showGamesList];
}

#pragma mark - GamesListRouter

- (void)showAvatarsForGame:(Game *)game {
    GameDetailsCLI *detailsCLI = [[GameDetailsCLI alloc] init];
    [self.builder buildGameDetailsSceneWithGame:game view:detailsCLI router:self];
    
    [detailsCLI run];
}

#pragma mark - GameDetailsRouter

- (void)showGamesList {
    if (!self.gamesListCLI) {
        self.gamesListCLI = [[GamesListCLI alloc] init];
        [self.builder buildGamesListSceneWithView:self.gamesListCLI router:self];
    }
    
    [self.gamesListCLI run];
}

- (void)didChooseAvatar {
    exit(EXIT_SUCCESS);
}

@end
