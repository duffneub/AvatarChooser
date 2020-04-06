//
//  SuggestAvatarService.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Avatar;
@class Game;

NS_ASSUME_NONNULL_BEGIN

@protocol ImageRepository
- (void)deleteAll;
- (void)deleteWithBlock:(BOOL (^)(NSURL *url))block;
- (void)addImageWithContentsOfURL:(NSURL *)url;
@end

@interface SuggestAvatarService : NSObject
@property (strong, nonatomic, nullable) Game *game;

- (instancetype)initWithImageRepository:(id<ImageRepository>)imageRepo;

- (void)resetAvatarSuggestions;
- (NSArray<Avatar *> *)suggestNewAvatars;
- (NSArray<Avatar *> *)suggestPreviousAvatars;

- (void)selectAvatar:(Avatar *)avatar;

@end

NS_ASSUME_NONNULL_END
