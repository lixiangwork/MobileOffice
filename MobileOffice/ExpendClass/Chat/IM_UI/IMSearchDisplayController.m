//
//  IMSearchDisplayController.m
//  JLWeChat
//
//  Created by Lee jimney on 6/2/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "IMSearchDisplayController.h"
#import "IMLocalSearchViewModel.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject+RecentContact.h"

#import "IMContactCell.h"
#import "IMChatVC.h"
#import "IMSearchChatContactCell.h"
#import "IMUIHelper.h"

@interface IMSearchDisplayController()<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IMLocalSearchViewModel *searchViewModel;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIViewController *searchContentsController;

@end

@implementation IMSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                     contentsController:viewController];
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.searchResultsTableView.rowHeight = ADDRESS_BOOK_ROW_HEIGHT;
        _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchDisplayController.searchResultsTableView.tableFooterView = [IMUIHelper createDefaultTableFooterView];
        _searchDisplayController.searchBar.delegate = self;

        // fix bug:http://stackoverflow.com/questions/19140020/ios7-uisearchbar-statusbar-color
        viewController.navigationController.view.backgroundColor = SEARCH_ACTIVE_BG_COLOR;
    }
    return self;
}

- (UISearchBar *)searchBar
{
   return self.searchDisplayController.searchBar;
}

- (UIViewController *)searchContentsController
{
    return self.searchDisplayController.searchContentsController;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataSource
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.searchViewModel numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.searchViewModel titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.searchViewModel numberOfItemsInSection:sectionIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *IMContactCellIdentifier = @"IMContactCell";
    static NSString *IMRecentContactCellIdentifier = @"IMRecentContactCell";
	id object = [self.searchViewModel objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[XMPPUserCoreDataStorageObject class]]) {
        IMContactCell *cell = [tableView dequeueReusableCellWithIdentifier:IMContactCellIdentifier];
        if (!cell) {
            cell = [[IMContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:IMContactCellIdentifier];
        }
        XMPPUserCoreDataStorageObject *user = (XMPPUserCoreDataStorageObject *)object;
        [cell shouldUpdateCellWithObject:user];
        return cell;
    }
    else if ([object isKindOfClass:[XMPPMessageArchiving_Contact_CoreDataObject class]]) {
        IMSearchChatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:IMRecentContactCellIdentifier];
        if (!cell) {
            cell = [[IMSearchChatContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:IMRecentContactCellIdentifier];
        }
        XMPPMessageArchiving_Contact_CoreDataObject *user = (XMPPMessageArchiving_Contact_CoreDataObject *)object;
        [cell shouldUpdateCellWithObject:user];
        return cell;
    }
	
	return [[UITableViewCell alloc] init];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 由于进入聊天界面会莫名崩溃，经调试跟键盘显示有关系，所以先把键盘隐藏
    [self.searchBar resignFirstResponder];
    
    id object = [self.searchViewModel objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[XMPPUserCoreDataStorageObject class]]) {
        XMPPUserCoreDataStorageObject *contact = (XMPPUserCoreDataStorageObject *)object;
        IMChatVC *chatC = [[IMChatVC alloc] initWithBuddyJID:contact.jid
                                                               buddyName:contact.displayName];
        [self.searchContentsController.navigationController pushViewController:chatC animated:YES];
    }
    else if ([object isKindOfClass:[XMPPMessageArchiving_Contact_CoreDataObject class]]) {
        XMPPMessageArchiving_Contact_CoreDataObject *contact = (XMPPMessageArchiving_Contact_CoreDataObject *)object;
        
        IMChatVC *chatC = [[IMChatVC alloc] initWithBuddyJID:contact.bareJid
                                                               buddyName:contact.displayName];
        [self.searchContentsController.navigationController pushViewController:chatC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // TODO: 隐藏tabbar
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (!self.searchViewModel) {
        self.searchViewModel = [[IMLocalSearchViewModel alloc] init];
    }
    [self.searchViewModel searchWithkeywords:searchBar.text];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
