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
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, strong, nonatomic) NSString *path;
@property (readonly, strong, nonatomic) NSString *imageName;

- (instancetype)initWithJSON:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
