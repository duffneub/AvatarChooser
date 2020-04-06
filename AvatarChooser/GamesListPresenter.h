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

@interface GameViewModel : NSObject
@property (readonly, strong, nonatomic) Game *base; // temporarily expose this
@property (readonly, copy, nonatomic) NSString *gameDescription;
@end

@protocol GamesListView <NSObject>
- (void)setGamesList:(NSArray<GameViewModel *> *)games;
- (void)displayGamesList;
@end

@interface GamesListPresenter : NSObject
- (instancetype)initWithAvatarChooserService:(AvatarChooserService *)service;

- (void)presentView:(id<GamesListView>)view;
@end

NS_ASSUME_NONNULL_END
