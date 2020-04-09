//
//  GameDetailsPresenter.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GameDetailsPresenter.h"

#import "Avatar.h"
#import "Game.h"
#import "SuggestAvatarService.h"

@interface GameDetailsPresenter ()
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) NSArray<Avatar *> *avatars;
@property (strong, nonatomic) SuggestAvatarService *service;
@property (weak, nonatomic) id<GameDetailsRouter> router;
@property (weak, nonatomic) id<GameDetailsView> view;
@end

@implementation GameDetailsPresenter

- (instancetype)initWithGame:(Game *)game service:(SuggestAvatarService *)service router:(id<GameDetailsRouter>)router {
    if (self = [super init]) {
        self.game = game;
        self.service = service;
        self.router = router;
    }
    
    return self;
}

- (void)attachView:(id<GameDetailsView>)view {
    self.view = view;
    [self suggestNewAvatars];
}

- (void)suggestNewAvatars {
    self.avatars = [self.service suggestNewAvatars];
    [self.view reloadAvatarSuggestions];
}

- (void)suggestPreviousAvatars {
    self.avatars = [self.service suggestPreviousAvatars];
    [self.view reloadAvatarSuggestions];
}

- (void)chooseDifferentGame {
    [self.service resetAvatarSuggestions];
    [self.router showGamesList];
}

- (void)selectAvatarAtIndex:(NSUInteger)index {
    [self.service selectAvatar:self.avatars[index]];
    [self.router didChooseAvatar];
}

- (NSString *)nameOfGame {
    return self.game.name;
}

- (NSUInteger)numberOfAvatars {
    return self.avatars.count;
}

- (NSString *)nameOfAvatarAtIndex:(NSUInteger)index {
    return self.avatars[index].name;
}

- (NSURL *)locationOfAvatarAtIndex:(NSUInteger)index {
    return self.avatars[index].imageLocation;
}

@end
