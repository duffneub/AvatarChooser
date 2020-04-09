//
//  RemoteGameRepository.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "RemoteGameRepository.h"

#import "Avatar.h"
#import "Game.h"

@interface RemoteGameRepository ()
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) id<NetworkClient> networkClient;
@end

@implementation RemoteGameRepository

- (instancetype)initWithBaseURL:(NSURL *)baseURL networkClient:(id<NetworkClient>)networkClient
{
    if (self = [super init]) {
        self.baseURL = baseURL;
        self.networkClient = networkClient;
    }
    
    return self;
}

- (void)getAllWithCompletionHandler:(void (^)(NSArray<Game *> *))completionHandler {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"avatars.json"];
    id<NetworkTask> task = [self.networkClient dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // TODO: Error checking
        NSArray *gamesList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray<Game *> *games = [@[] mutableCopy];
        for (NSDictionary *gameJSON in gamesList) {
            [games addObject:[self makeGameWithJSON:gameJSON]];
        }
        
        completionHandler(games);
    }];
    
    [task resume];
}

- (Game *)makeGameWithJSON:(NSDictionary *)json {
    NSArray *avatarListJSON = json[@"avatars"];
    NSMutableArray<Avatar *> *avatars = [NSMutableArray arrayWithCapacity:avatarListJSON.count];
    for (NSDictionary *avatarJSON in avatarListJSON) {
        [avatars addObject:[self makeAvatarWithJSON:avatarJSON]];
    }
    
    return [[Game alloc] initWithName:json[@"name"] avatars:avatars];
}

- (Avatar *)makeAvatarWithJSON:(NSDictionary *)json {
    NSURL *imageLocation = [self.baseURL URLByAppendingPathComponent:json[@"url"]];
    return [[Avatar alloc] initWithName:json[@"name"] imageLocation:imageLocation];
}

@end
