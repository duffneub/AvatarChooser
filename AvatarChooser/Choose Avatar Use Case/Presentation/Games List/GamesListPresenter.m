//
//  GamesListPresenter.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GamesListPresenter.h"

#import "AvatarChooserService.h"
#import "Game.h"

@interface GameViewModel ()
@property (strong, nonatomic) Game *game;
- (instancetype)initWithGame:(Game *)game;
@end

@implementation GameViewModel

- (instancetype)initWithGame:(Game *)game {
    if (self = [super init]) {
        self.game = game;
    }
    
    return self;
}

- (NSString *)gameDescription {
    return [NSString stringWithFormat:@"%@ (%ld)", self.game.name, self.game.numberOfAvatars];
}

- (Game *)base {
    return self.game;
}

@end

@interface GamesListPresenter ()
@property (strong, nonatomic) AvatarChooserService *service;
@property (weak, nonatomic) id<GamesListRouter> router;
@property (weak, nonatomic) id<GamesListView> view;
@end

@implementation GamesListPresenter

- (instancetype)initWithService:(AvatarChooserService *)service router:(id<GamesListRouter>)router {
    if (self = [super init]) {
        self.service = service;
        self.router = router;
    }
    return self;
}

- (void)presentView:(id<GamesListView>)view {
    self.view = view;

    [self.service getAllGamesWithAvatarsWithCompletionHandler:^(NSArray<Game *> *games) {
        NSMutableArray<GameViewModel *> *viewModels = [@[] mutableCopy];
        for (Game *game in games) {
            [viewModels addObject:[[GameViewModel alloc] initWithGame:game]];
        }
        [self.view setGamesList:viewModels];
    }];
}

- (void)userDidSelectGame:(GameViewModel *)viewModel {
    Game *game = viewModel.base;
    [self.router showAvatarsForGame:game];
}

@end
