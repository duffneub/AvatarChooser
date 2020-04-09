//
//  ChooseAvatarSceneBuilder.h
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/8/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@protocol GamesListView;
@protocol GamesListRouter;

@protocol GameDetailsView;
@protocol GameDetailsRouter;

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAvatarSceneBuilder : NSObject
- (instancetype)initWithDownloadLocation:(NSURL *)location;
- (void)buildGamesListSceneWithView:(id<GamesListView>)view router:(id<GamesListRouter>)router;
- (void)buildGameDetailsSceneWithGame:(Game *)game view:(id<GameDetailsView>)view router:(id<GameDetailsRouter>)router;
@end

NS_ASSUME_NONNULL_END
