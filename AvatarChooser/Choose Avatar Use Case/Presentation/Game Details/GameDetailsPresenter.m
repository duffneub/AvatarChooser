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

@interface AvatarViewModel ()
@property (strong, nonatomic) Avatar *avatar;
@end

@implementation AvatarViewModel

- (instancetype)initWithAvatar:(Avatar *)avatar {
    if (self = [super init]) {
        self.avatar = avatar;
    }
    
    return self;
}

- (NSString *)avatarDescription {
    return [NSString stringWithFormat:@"%@ (%@)", self.avatar.name, self.avatar.imageLocation.lastPathComponent];
}


@end

@interface GameDetailsPresenter ()
@property (strong, nonatomic) Game *game;
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

- (void)updateViewWithSuggestedAvatars:(NSArray<Avatar *> *)avatars {
    NSMutableArray<AvatarViewModel *> *viewModels = [@[] mutableCopy];
    for (Avatar *avatar in avatars) {
        [viewModels addObject:[[AvatarViewModel alloc] initWithAvatar:avatar]];
    }
    
    [self.view setSuggestedAvatars:viewModels];
}

- (void)attachView:(id<GameDetailsView>)view {
    self.view = view;

    [self.view setGameName:self.game.name];
    [self updateViewWithSuggestedAvatars:[self.service suggestNewAvatars]];
    
}

- (void)suggestNewAvatars {
    [self updateViewWithSuggestedAvatars:[self.service suggestNewAvatars]];
}

- (void)suggestPreviousAvatars {
    [self updateViewWithSuggestedAvatars:[self.service suggestPreviousAvatars]];
}

- (void)chooseDifferentGame {
    [self.service resetAvatarSuggestions];
    [self.router showGamesList];
}

- (void)selectAvatar:(AvatarViewModel *)viewModel {
    [self.service selectAvatar:viewModel.avatar];
    [self.router didChooseAvatar];
}

@end
