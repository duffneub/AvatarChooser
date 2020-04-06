//
//  Game.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Avatar;

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject
@property (readonly, copy, nonatomic) NSString *name;
@property (readonly, nonatomic) NSUInteger numberOfAvatars;

- (instancetype)initWithName:(NSString *)name avatars:(NSArray<Avatar *> *)avatars;

- (void)resetAvatarSuggestions;
- (NSArray<Avatar *> *)suggestNewAvatars;
- (NSArray<Avatar *> *)previousAvatarSuggestion;
@end

NS_ASSUME_NONNULL_END
