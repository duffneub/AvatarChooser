//
//  RemoteGameRepository.h
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChooseGameService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkTask <NSObject>
- (void)resume;
@end

@protocol NetworkClient
- (id<NetworkTask>)dataTaskWithURL:(NSURL *)url
                        completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler;
@end

@interface RemoteGameRepository : NSObject <GameRepository>
- (instancetype)initWithBaseURL:(NSURL *)baseURL networkClient:(id<NetworkClient>)networkClient;
@end

@interface NSURLSessionTask (NetworkTask) <NetworkTask>
@end

@interface NSURLSession (NetworkClient) <NetworkClient>
@end

NS_ASSUME_NONNULL_END
