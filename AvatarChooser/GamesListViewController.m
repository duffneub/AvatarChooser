//
//  GamesListViewController.m
//  AvatarChooser
//
//  Created by Duff Neubauer on 4/7/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

#import "GamesListViewController.h"

@interface GamesListViewController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (strong) IBOutlet NSOutlineView *outlineView;
@property (strong) NSString *headerItem;
@end

@implementation GamesListViewController
@synthesize presenter;

NSUserInterfaceItemIdentifier const headerCellIdentifier = @"HeaderCell";
NSUserInterfaceItemIdentifier const dataCellIdentifier = @"DataCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerItem = @"Games";
    [self.presenter attachView:self];
}

#pragma mark - GamesListView

- (void)reloadGamesList {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.outlineView reloadData];
        [self.outlineView expandItem:self.headerItem];
    });
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSInteger numberOfChildren = 0;
    
    if (item == nil) {
        numberOfChildren = 1; // Games header
    } else if ([item isEqual:self.headerItem]) {
        numberOfChildren = [self.presenter numberOfGames];
    }
    
    return numberOfChildren;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return item == nil ? self.headerItem : [NSString stringWithFormat:@"%@ (%ld)", [self.presenter nameOfGameAtIndex:index], [self.presenter numberOfAvatarsForGameAtIndex:index]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [item isEqual:self.headerItem];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [item isEqual:self.headerItem];
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSUserInterfaceItemIdentifier identifier = [item isEqual:self.headerItem] ? headerCellIdentifier : dataCellIdentifier;
    NSTableCellView *cellView = [self.outlineView makeViewWithIdentifier:identifier owner:self];
    cellView.textField.stringValue = (NSString *)item;
    
    return cellView;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return ![item isEqual:self.headerItem];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [self.presenter userDidSelectGameAtIndex:self.outlineView.selectedRow - 1];
}

@end
