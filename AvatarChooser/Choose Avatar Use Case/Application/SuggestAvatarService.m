//
//  SuggestAvatarService.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "SuggestAvatarService.h"

#import "Avatar.h"
#import "Game.h"

@interface SuggestAvatarService ()
@property (strong, nonatomic) id<ImageRepository> imageRepo;
@end

@implementation SuggestAvatarService

- (instancetype)initWithImageRepository:(id<ImageRepository>)imageRepo {
    if (self = [super init]) {
        self.game = nil;
        self.imageRepo = imageRepo;
    }
    
    return self;
}

- (void)resetAvatarSuggestions {
    [self.game resetAvatarSuggestions];
    [self.imageRepo deleteAll];
}

- (NSArray<Avatar *> *)suggestNewAvatars {
    NSArray<Avatar *> *avatars = [self.game suggestNewAvatars];
    [self replaceContentsOfImageRepoWithAvatars:avatars];
    
    return avatars;
}

- (NSArray<Avatar *> *)suggestPreviousAvatars {
    NSArray<Avatar *> *avatars = [self.game suggestPreviousAvatars];
    [self replaceContentsOfImageRepoWithAvatars:avatars];
    
    return avatars;
}

- (void)replaceContentsOfImageRepoWithAvatars:(NSArray<Avatar *> *)avatars {
    [self.imageRepo deleteAll];
    for (Avatar *avatar in avatars) {
        [self.imageRepo addImageWithContentsOfURL:avatar.imageLocation];
    }
}

- (void)selectAvatar:(Avatar *)avatar {
    [self.imageRepo deleteWithBlock:^BOOL(NSURL * _Nonnull url) {
        return ![avatar.imageLocation.lastPathComponent isEqualToString:url.lastPathComponent];
    }];
}

@end
