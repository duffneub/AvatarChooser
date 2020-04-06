//
//  AvatarChooser.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GamesListPresenter;

NS_ASSUME_NONNULL_BEGIN

@interface GamesListCLI : NSObject
- (instancetype)initWithPresenter:(GamesListPresenter *)presenter;
- (void)run;
@end

NS_ASSUME_NONNULL_END
