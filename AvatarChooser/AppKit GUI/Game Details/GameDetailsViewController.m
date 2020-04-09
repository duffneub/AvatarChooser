//
//  GameDetailsViewController.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/8/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GameDetailsViewController.h"

@interface GameDetailsViewController () <NSCollectionViewDataSource>
@property (strong) IBOutlet NSCollectionView *collectionView;
@end

@implementation GameDetailsViewController
@synthesize presenter;

NSUserInterfaceItemIdentifier const itemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:@"AvatarCollectionViewItem" bundle:nil] forItemWithIdentifier:@"AvatarCollectionViewItem"];
    [self.presenter attachView:self];
}

- (IBAction)nextButtonWasClicked:(id)sender {
    [self.presenter suggestNewAvatars];
}

- (IBAction)previousButtonWasClicked:(id)sender {
    [self.presenter suggestPreviousAvatars];
}

- (IBAction)chooseAvatarButtonWasClicked:(id)sender {
    // Watch for errors!
    [self.presenter selectAvatarAtIndex:self.collectionView.selectionIndexes.firstIndex];
}

#pragma mark - GameDetailsView

- (void)reloadAvatarSuggestions {
    [self.collectionView reloadData];
}

#pragma mark - NSCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.presenter numberOfAvatars];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"AvatarCollectionViewItem" forIndexPath:indexPath];
    item.textField.stringValue = [self.presenter nameOfAvatarAtIndex:indexPath.item];
    
    // Watch out for race conditions here!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:[self.presenter locationOfAvatarAtIndex:indexPath.item]];
        dispatch_async(dispatch_get_main_queue(), ^{
            item.imageView.image = image;
        });
    });
    
    return item;
}

@end
