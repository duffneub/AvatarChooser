//
//  Avatar.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Avatar : NSObject
@property (readonly, copy, nonatomic) NSString *name;
@property (readonly, copy, nonatomic) NSString *imageLocation;
@property (readonly, copy, nonatomic) NSString *imageName;

- (instancetype)initWithName:(NSString *)name imageLocation:(NSString *)location;

@end

NS_ASSUME_NONNULL_END
