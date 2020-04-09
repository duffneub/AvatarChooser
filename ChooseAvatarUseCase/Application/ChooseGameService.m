//
//  ChooseGameService.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "ChooseGameService.h"

@interface ChooseGameService ()
@property (strong, nonatomic) id<GameRepository> gameRepo;
@end

@implementation ChooseGameService

- (instancetype)initWithGameRepository:(id<GameRepository>)gameRepo {
    if (self = [super init]) {
        self.gameRepo = gameRepo;
    }
    
    return self;
}

- (void)getAllGamesWithAvatarsWithCompletionHandler:(void (^)(NSArray<Game *> *))completionHandler {
    [self.gameRepo getAllWithCompletionHandler:completionHandler];
}

@end
