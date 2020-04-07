//
//  CLIChooseAvatarUseCase.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChooseGameService;
@class SuggestAvatarService;

NS_ASSUME_NONNULL_BEGIN

@interface CLIChooseAvatarUseCase : NSObject
- (instancetype)initWithChooseGameService:(ChooseGameService *)avatarChooserService
                       suggestAvatarService:(SuggestAvatarService *)suggestAvatarService
                          completionHandler:(void (^)(void))completionHandler;
- (void)start;
@end

NS_ASSUME_NONNULL_END
