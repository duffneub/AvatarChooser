//
//  CLIChooseAvatarUseCase.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvatarChooserService;
@class SuggestAvatarService;

NS_ASSUME_NONNULL_BEGIN

@interface CLIChooseAvatarUseCase : NSObject
- (instancetype)initWithAvatarChooseService:(AvatarChooserService *)avatarChooserService
                       suggestAvatarService:(SuggestAvatarService *)suggestAvatarService
                          completionHandler:(void (^)(void))completionHandler;
- (void)start;
@end

NS_ASSUME_NONNULL_END
