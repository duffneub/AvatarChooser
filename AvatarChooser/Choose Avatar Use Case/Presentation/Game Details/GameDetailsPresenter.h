//
//  GameDetailsPresenter.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@class GameDetailsPresenter;
@class SuggestAvatarService;

NS_ASSUME_NONNULL_BEGIN

@protocol GameDetailsRouter <NSObject>
- (void)showGamesList;
- (void)didChooseAvatar;
@end

@protocol GameDetailsView <NSObject>
@property (strong) GameDetailsPresenter *presenter;
- (void)reloadAvatarSuggestions;

@end

@interface GameDetailsPresenter : NSObject
- (instancetype)initWithGame:(Game *)game service:(SuggestAvatarService *)service router:(id<GameDetailsRouter>)router;

- (void)attachView:(id<GameDetailsView>)view;
- (void)suggestNewAvatars;
- (void)suggestPreviousAvatars;
- (void)chooseDifferentGame;
- (void)selectAvatarAtIndex:(NSUInteger)index;

- (NSString *)nameOfGame;
- (NSUInteger)numberOfAvatars;
- (NSString *)nameOfAvatarAtIndex:(NSUInteger)index;
- (NSURL *)locationOfAvatarAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
