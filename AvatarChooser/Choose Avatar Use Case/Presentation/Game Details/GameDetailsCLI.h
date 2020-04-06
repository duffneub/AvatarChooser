//
//  GameDetailsCLI.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameDetailsPresenter;

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailsCLI : NSObject
- (instancetype)initWithPresenter:(GameDetailsPresenter *)presenter;
- (void)run;
@end

NS_ASSUME_NONNULL_END
