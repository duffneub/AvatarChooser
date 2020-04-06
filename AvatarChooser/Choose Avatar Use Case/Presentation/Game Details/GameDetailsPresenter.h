//
//  GameDetailsPresenter.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@class SuggestAvatarService;

NS_ASSUME_NONNULL_BEGIN

@protocol GameDetailsRouter <NSObject>
- (void)showGamesList;
- (void)didChooseAvatar;
@end

@interface AvatarViewModel : NSObject
@property (readonly, copy, nonatomic) NSString *avatarDescription;
@end

@protocol GameDetailsView <NSObject>
- (void)setGameName:(NSString *)name;
- (void)setSuggestedAvatars:(NSArray<AvatarViewModel *> *)avatars;
@end

@interface GameDetailsPresenter : NSObject
- (instancetype)initWithGame:(Game *)game service:(SuggestAvatarService *)service router:(id<GameDetailsRouter>)router;

- (void)attachView:(id<GameDetailsView>)view;
- (void)suggestNewAvatars;
- (void)suggestPreviousAvatars;
- (void)chooseDifferentGame;
- (void)selectAvatar:(AvatarViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
