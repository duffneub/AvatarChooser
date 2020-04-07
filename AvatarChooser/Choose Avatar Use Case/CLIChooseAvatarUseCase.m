//
//  CLIChooseAvatarUseCase.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "CLIChooseAvatarUseCase.h"

#import "ChooseGameService.h"
#import "GamesListCLI.h"
#import "GameDetailsCLI.h"
#import "GameDetailsPresenter.h"
#import "GamesListPresenter.h"
#import "SuggestAvatarService.h"

@interface CLIChooseAvatarUseCase () <GamesListRouter, GameDetailsRouter>
@property (strong, nonatomic) ChooseGameService *chooseGameService;
@property (strong, nonatomic) SuggestAvatarService *suggestAvatarService;
@property (copy, nonatomic) void (^completionHandler)(void);
@property (strong, nonatomic) GamesListCLI *gamesListCLI;
@property (strong, nonatomic) GameDetailsCLI *detailsCLI;
@end

@implementation CLIChooseAvatarUseCase

- (instancetype)initWithChooseGameService:(ChooseGameService *)chooseGameService
                       suggestAvatarService:(SuggestAvatarService *)suggestAvatarService
                          completionHandler:(void (^)(void))completionHandler {
    if (self = [super init]) {
        self.chooseGameService = chooseGameService;
        self.suggestAvatarService = suggestAvatarService;
        self.completionHandler = completionHandler;
    }
    
    return self;
}

- (void)start {
    [self showGamesList];
}

#pragma mark - GamesListRouter

- (void)showAvatarsForGame:(Game *)game {
    if (!self.detailsCLI) {
        self.suggestAvatarService.game = game;
        GameDetailsPresenter *presenter = [[GameDetailsPresenter alloc] initWithGame:game service:self.suggestAvatarService router:self];
        self.detailsCLI = [[GameDetailsCLI alloc] initWithPresenter:presenter];
    }
    
    [self.detailsCLI run];
}

#pragma mark - GameDetailsRouter

- (void)showGamesList {
    self.detailsCLI = nil;

    if (!self.gamesListCLI) {
        GamesListPresenter *presenter = [[GamesListPresenter alloc] initWithService:self.chooseGameService router:self];
        self.gamesListCLI = [[GamesListCLI alloc] initWithPresenter:presenter];
    }
    
    [self.gamesListCLI run];
}

- (void)didChooseAvatar {
    self.completionHandler();
}

@end
