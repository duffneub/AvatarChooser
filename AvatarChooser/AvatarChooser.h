//
//  AvatarChooser.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarChooser : NSObject
- (instancetype)initWithDownloadsDirectory:(NSURL *)directory;
- (void)run;
@end

NS_ASSUME_NONNULL_END
