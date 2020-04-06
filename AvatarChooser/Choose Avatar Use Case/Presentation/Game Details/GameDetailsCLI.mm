//
//  GameDetailsCLI.m
//  avatar-chooser
//
//  Created by Duff Neubauer on 4/5/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GameDetailsCLI.h"

#include <iostream>
using namespace std;

#import "GameDetailsPresenter.h"

@interface GameDetailsCLI () <GameDetailsView>
@property (strong, nonatomic) GameDetailsPresenter *presenter;
@property (strong, nonatomic) NSString *gameName;
@property (strong, nonatomic) NSArray<AvatarViewModel *> *suggestedAvatars;
@end

@implementation GameDetailsCLI

- (instancetype)initWithPresenter:(GameDetailsPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
    }
    
    return self;
}

- (void)run {
    [self.presenter attachView:self];
}

- (void)setSuggestedAvatars:(NSArray<AvatarViewModel *> *)avatars {
    _suggestedAvatars = avatars;
    [self refreshUI];
}

- (void)refreshUI {
    cout << "Suggested Avatars for '" << self.gameName.UTF8String << "':\n";
    
    [self.suggestedAvatars enumerateObjectsUsingBlock:^(AvatarViewModel * _Nonnull avatar, NSUInteger idx, BOOL * _Nonnull stop) {
        printf("\t%ld. %s\n", idx + 1, avatar.avatarDescription.UTF8String);
    }];
    
    [self listenForUserInput];
}

- (void)listenForUserInput {
    // Display help?
//    cout << "\n";
//    cout << "To choose an avatar:     \tEnter a number between 1 and " << avatars.count << "\n";
//    cout << "To see more avatars:     \tEnter '>'\n";
//    cout << "To see previous avatars: \tEnter '<'\n";
//    cout << "To change game:          \tEnter '0'\n";
    
    char input;
    cin >> input;
    int inputAsInt = input - '0';
    
    if (input == '>') {
        [self.presenter suggestNewAvatars];
    } else if (input == '<') {
        [self.presenter suggestPreviousAvatars];
    } else if (input == '0') {
        [self.presenter chooseDifferentGame];
    } else if (1 <= inputAsInt && inputAsInt <= self.suggestedAvatars.count ) {
        [self.presenter selectAvatar:self.suggestedAvatars[inputAsInt - 1]];
    }
}

@end
