//
//  GamesListPresenter.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GamesListPresenter.h"

#import "ChooseGameService.h"
#import "Game.h"

@interface GamesListPresenter ()
@property (strong, nonatomic) ChooseGameService *service;
@property (weak, nonatomic) id<GamesListRouter> router;
@property (weak, nonatomic) id<GamesListView> view;

// UI State
@property (strong, nonatomic) NSArray<Game *> *games;

@end

@implementation GamesListPresenter

- (instancetype)initWithService:(ChooseGameService *)service router:(id<GamesListRouter>)router {
    if (self = [super init]) {
        self.service = service;
        self.router = router;
        self.view = nil;
        self.games = @[];
    }
    return self;
}

- (void)attachView:(id<GamesListView>)view {
    self.view = view;

    [self.service getAllGamesWithAvatarsWithCompletionHandler:^(NSArray<Game *> *games) {
        self.games = [games sortedArrayUsingComparator:^NSComparisonResult(Game *lhs, Game *rhs) {
            return [lhs.name compare:rhs.name];
        }];
        [self.view reloadGamesList];
    }];
}

- (void)userDidSelectGameAtIndex:(NSUInteger)index {
    Game *game = self.games[index];
    [self.router showAvatarsForGame:game];
}

- (NSUInteger)numberOfGames {
    return self.games.count;
}

- (NSString *)nameOfGameAtIndex:(NSUInteger)index {
    return self.games[index].name;
}

- (NSUInteger)numberOfAvatarsForGameAtIndex:(NSUInteger)index {
    return self.games[index].numberOfAvatars;
}

@end
