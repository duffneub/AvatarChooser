//
//  GamesListPresenter.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvatarChooserService;
@class Game;

NS_ASSUME_NONNULL_BEGIN

@protocol GamesListRouter <NSObject>
- (void)showAvatarsForGame:(Game *)game;
@end

@interface GameViewModel : NSObject
@property (readonly, strong, nonatomic) Game *base; // temporarily expose this
@property (readonly, copy, nonatomic) NSString *gameDescription;
@end

@protocol GamesListView <NSObject>
- (void)setGamesList:(NSArray<GameViewModel *> *)games;
@end

@interface GamesListPresenter : NSObject
- (instancetype)initWithService:(AvatarChooserService *)service router:(id<GamesListRouter>)router;

- (void)presentView:(id<GamesListView>)view;
- (void)userDidSelectGame:(GameViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
