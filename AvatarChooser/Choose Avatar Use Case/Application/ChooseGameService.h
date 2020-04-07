//
//  ChooseGameService.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Avatar;
@class Game;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRepository
- (void)getAllWithCompletionHandler:(void (^)(NSArray<Game *> *))completionHandler;
@end

@protocol AvatarRepository
- (void)deleteAllImages;
- (void)loadImageForAvatar:(Avatar *)avatar;
@end

@interface ChooseGameService : NSObject
- (instancetype)initWithGameRepository:(id<GameRepository>)gameRepo;
- (void)getAllGamesWithAvatarsWithCompletionHandler:(void (^)(NSArray<Game *> *))completionHandler;
@end

NS_ASSUME_NONNULL_END
