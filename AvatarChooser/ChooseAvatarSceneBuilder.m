//
//  ChooseAvatarSceneBuilder.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/8/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "ChooseAvatarSceneBuilder.h"

#import "Game.h"

#import "GamesListPresenter.h"
#import "ChooseGameService.h"
#import "RemoteGameRepository.h"

#import "GameDetailsPresenter.h"
#import "SuggestAvatarService.h"
#import "PersistentImageRepository.h"

@interface ChooseAvatarSceneBuilder ()
@property (strong) ChooseGameService *chooseGameService;
@property (strong) SuggestAvatarService *suggestAvatarService;
@end

@implementation ChooseAvatarSceneBuilder

- (instancetype)initWithDownloadLocation:(NSURL *)location {
    if (self = [super init]) {
        NSURL *databaseURL = [NSURL URLWithString:@"https://clientupdate-v6.cursecdn.com/Avatars/"];
        RemoteGameRepository *gameRepo = [[RemoteGameRepository alloc] initWithBaseURL:databaseURL
                                                                         networkClient:[NSURLSession sharedSession]];
        PersistentImageRepository *imageRepo = [[PersistentImageRepository alloc] initWithDownloadLocation:location];
        self.chooseGameService = [[ChooseGameService alloc] initWithGameRepository:gameRepo];
        self.suggestAvatarService = [[SuggestAvatarService alloc] initWithImageRepository:imageRepo];
    }
    
    return self;
}

- (void)buildGamesListSceneWithView:(id<GamesListView>)view router:(id<GamesListRouter>)router {
    view.presenter = [[GamesListPresenter alloc] initWithService:self.chooseGameService router:router];
}

- (void)buildGameDetailsSceneWithGame:(Game *)game view:(id<GameDetailsView>)view
                               router:(id<GameDetailsRouter>)router {
    self.suggestAvatarService.game = game;
    view.presenter = [[GameDetailsPresenter alloc] initWithGame:game service:self.suggestAvatarService router:router];
}

@end
