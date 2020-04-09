//
//  PersistentImageRepository.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SuggestAvatarService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersistentImageRepository : NSObject <ImageRepository>
- (instancetype)initWithDownloadLocation:(NSURL *)location;
@end

NS_ASSUME_NONNULL_END
