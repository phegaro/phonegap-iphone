//
//  UIControls.m
//  PhoneGap
//
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.
//

#import "UIControls.h"

@implementation UIControls
#ifndef __IPHONE_3_0
@synthesize webView;
#endif

-(PhoneGapCommand*) initWithWebView:(UIWebView*)theWebView
{
    self = (UIControls*)[super initWithWebView:theWebView];
    if (self) {
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
		toolBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    tabBar = [UITabBar new];
    [tabBar sizeToFit];
    tabBar.delegate = self;
    tabBar.multipleTouchEnabled   = NO;
    tabBar.autoresizesSubviews    = YES;
    tabBar.hidden                 = YES;
    tabBar.userInteractionEnabled = YES;

	[self.webView.superview addSubview:tabBar];    
}

/**
 * Show the tab bar after its been created.
 * @brief show the tab bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

	if (tabBar.hidden == NO)
		return;
	
    CGFloat height = 49.0f;
	CGFloat heightDiff = 0.0f;
    BOOL atBottom = YES;
    
    NSDictionary* tabSettings = [settings objectForKey:@"TabBarSettings"];
    if (tabSettings) {
        height   = [[tabSettings objectForKey:@"height"] floatValue];
        atBottom = [[tabSettings objectForKey:@"position"] isEqualToString:@"bottom"];
    }
    tabBar.hidden = NO;
	
	CGFloat heightOption = [[options objectForKey:@"height"] floatValue];
	if (heightOption) {
		height = heightOption;
	}
	
	NSString* position = [options objectForKey:@"position"];
	if (position) {
		atBottom = [position isEqualToString:@"bottom"];
	}
		

     CGRect webViewBounds = webView.bounds;
	
	if (webViewBounds.size.height == 480) {
		heightDiff = 20.0f;
	}
	
     CGRect tabBarBounds;
     if (atBottom) {
         tabBarBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y + webViewBounds.size.height - height - heightDiff,
             webViewBounds.size.width,
             height
         );
         webViewBounds = CGRectMake(
            webViewBounds.origin.x,
            webViewBounds.origin.y,
            webViewBounds.size.width,
            webViewBounds.size.height - height - heightDiff
		);
     } else {
         tabBarBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y,
             webViewBounds.size.width,
             height
         );
         webViewBounds = CGRectMake(
            webViewBounds.origin.x,
            webViewBounds.origin.y + height + heightDiff,
            webViewBounds.size.width,
            webViewBounds.size.height - height - heightDiff
         );
     }
     
    [tabBar setFrame:tabBarBounds];
    [webView setFrame:webViewBounds];
}

/**
 * Hide the tab bar
 * @brief hide the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
	
	if (tabBar.hidden == YES)
		return;
	
    tabBar.hidden = YES;
	
    CGFloat height = 49.0f;
    
    NSDictionary* tabSettings = [settings objectForKey:@"TabBarSettings"];
    if (tabSettings) {
        height   = [[tabSettings objectForKey:@"height"] floatValue];
    }
	
	CGFloat heightOption = [[options objectForKey:@"height"] floatValue];
	if (heightOption) {
		height = heightOption;
	}
	
	CGRect webViewBounds = webView.bounds;
	webViewBounds = CGRectMake(
							   webViewBounds.origin.x,
							   webViewBounds.origin.y,
							   webViewBounds.size.width,
							   webViewBounds.size.height + height
							   );
	
	
	[webView setFrame:webViewBounds];
}

/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 * - <b>Tab Buttons</b>
 *   - tabButton:More
 *   - tabButton:Favorites
 *   - tabButton:Featured
 *   - tabButton:TopRated
 *   - tabButton:Recents
 *   - tabButton:Contacts
 *   - tabButton:History
 *   - tabButton:Bookmarks
 *   - tabButton:Search
 *   - tabButton:Downloads
 *   - tabButton:MostRecent
 *   - tabButton:MostViewed
 * @brief create a tab bar item
 * @param arguments Parameters used to create the tab bar
 *  -# \c name internal name to refer to this tab by
 *  -# \c title title text to show on the tab, or null if no text should be shown
 *  -# \c image image filename or internal identifier to show, or null if now image should be shown
 *  -# \c tag unique number to be used as an internal reference to this button
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

    NSString  *name      = [arguments objectAtIndex:0];
    NSString  *title     = [arguments objectAtIndex:1];
    NSString  *imageName = [arguments objectAtIndex:2];
    int tag              = [[arguments objectAtIndex:3] intValue];

    UITabBarItem *item = nil;    
    if ([imageName length] > 0) {
        UIBarButtonSystemItem systemItem = -1;
		systemItem = [self getSystemItemFromString:imageName];
        if (systemItem != -1)
            item = [[UITabBarItem alloc] initWithTabBarSystemItem:systemItem tag:tag];
    }
    
    if (item == nil) {
        NSLog(@"Creating with custom image and title");
        item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    }

    if ([options objectForKey:@"badge"])
        item.badgeValue = [options objectForKey:@"badge"];
    
    [tabBarItems setObject:item forKey:name];
	[item release];
}

/**
 * Update an existing tab bar item to change its badge value.
 * @brief update the badge value on an existing tab bar item
 * @param arguments Parameters used to identify the tab bar item to update
 *  -# \c name internal name used to represent this item when it was created
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

    NSString  *name = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:name];
    if (item)
        item.badgeValue = [options objectForKey:@"badge"];
}

/**
 * Show previously created items on the tab bar
 * @brief show a list of tab bar items
 * @param arguments the item names to be shown
 * @param options dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    int i, count = [arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 0; i < count; i++) {
        NSString *itemName = [arguments objectAtIndex:i];
        UITabBarItem *item = [tabBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }
    
    BOOL animateItems = YES;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
    [tabBar setItems:items animated:animateItems];
	[items release];
}

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @brief manually select a tab bar item
 * @param arguments the name of the tab bar item to select
 * @see createTabBarItem
 * @see showTabBarItems
 */
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

    NSString *itemName = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:itemName];
    if (item)
        tabBar.selectedItem = item;
    else
        tabBar.selectedItem = nil;
}

/*
 * - <b>Tool Buttons</b>
 *   - toolButton:Done
 *   - toolButton:Cancel
 *   - toolButton:Edit
 *   - toolButton:Save
 *   - toolButton:Add
 *   - toolButton:FlexibleSpace
 *   - toolButton:FixedSpace
 *   - toolButton:Compose
 *   - toolButton:Reply
 *   - toolButton:Action
 *   - toolButton:Organize
 *   - toolButton:Bookmarks
 *   - toolButton:Search
 *   - toolButton:Refresh
 *   - toolButton:Stop
 *   - toolButton:Camera
 *   - toolButton:Trash
 *   - toolButton:Play
 *   - toolButton:Pause
 *   - toolButton:Rewind
 *   - toolButton:FastForward
 */
- (UIBarButtonSystemItem)getSystemItemFromString:(NSString*)imageName
{
	if (!imageName)
		return -1;
	
    if ([[imageName substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"tabButton:"]) {
        NSLog(@"Tab button!!");
        if ([imageName isEqualToString:@"tabButton:More"])       return UITabBarSystemItemMore;
        if ([imageName isEqualToString:@"tabButton:Favorites"])  return UITabBarSystemItemFavorites;
        if ([imageName isEqualToString:@"tabButton:Featured"])   return UITabBarSystemItemFeatured;
        if ([imageName isEqualToString:@"tabButton:TopRated"])   return UITabBarSystemItemTopRated;
        if ([imageName isEqualToString:@"tabButton:Recents"])    return UITabBarSystemItemRecents;
        if ([imageName isEqualToString:@"tabButton:Contacts"])   return UITabBarSystemItemContacts;
        if ([imageName isEqualToString:@"tabButton:History"])    return UITabBarSystemItemHistory;
        if ([imageName isEqualToString:@"tabButton:Bookmarks"])  return UITabBarSystemItemBookmarks;
        if ([imageName isEqualToString:@"tabButton:Search"])     return UITabBarSystemItemSearch;
        if ([imageName isEqualToString:@"tabButton:Downloads"])  return UITabBarSystemItemDownloads;
        if ([imageName isEqualToString:@"tabButton:MostRecent"]) return UITabBarSystemItemMostRecent;
        if ([imageName isEqualToString:@"tabButton:MostViewed"]) return UITabBarSystemItemMostViewed;
        NSLog(@"Couldn't figure out what it was");
        return -1;
    }
    else if ([[imageName substringWithRange:NSMakeRange(0, 11)] isEqualToString:@"toolButton:"]) {
        NSLog(@"Tool button!!");
		if ([imageName isEqualToString:@"toolButton:Plain"])		 return UIBarButtonSystemItemFastForward;	
        if ([imageName isEqualToString:@"toolButton:Done"])          return UIBarButtonSystemItemDone;
        if ([imageName isEqualToString:@"toolButton:Cancel"])        return UIBarButtonSystemItemCancel;
        if ([imageName isEqualToString:@"toolButton:Edit"])          return UIBarButtonSystemItemEdit;
        if ([imageName isEqualToString:@"toolButton:Save"])          return UIBarButtonSystemItemSave;
        if ([imageName isEqualToString:@"toolButton:Add"])           return UIBarButtonSystemItemAdd;
        if ([imageName isEqualToString:@"toolButton:FlexibleSpace"]) return UIBarButtonSystemItemFlexibleSpace;
        if ([imageName isEqualToString:@"toolButton:FixedSpace"])    return UIBarButtonSystemItemFixedSpace;
        if ([imageName isEqualToString:@"toolButton:Compose"])       return UIBarButtonSystemItemCompose;
        if ([imageName isEqualToString:@"toolButton:Reply"])         return UIBarButtonSystemItemReply;
        if ([imageName isEqualToString:@"toolButton:Action"])        return UIBarButtonSystemItemAction;
        if ([imageName isEqualToString:@"toolButton:Organize"])      return UIBarButtonSystemItemOrganize;
        if ([imageName isEqualToString:@"toolButton:Bookmarks"])     return UIBarButtonSystemItemBookmarks;
        if ([imageName isEqualToString:@"toolButton:Search"])        return UIBarButtonSystemItemSearch;
        if ([imageName isEqualToString:@"toolButton:Refresh"])       return UIBarButtonSystemItemRefresh;
        if ([imageName isEqualToString:@"toolButton:Stop"])          return UIBarButtonSystemItemStop;
        if ([imageName isEqualToString:@"toolButton:Camera"])        return UIBarButtonSystemItemCamera;
        if ([imageName isEqualToString:@"toolButton:Trash"])         return UIBarButtonSystemItemTrash;
        if ([imageName isEqualToString:@"toolButton:Play"])          return UIBarButtonSystemItemPlay;
        if ([imageName isEqualToString:@"toolButton:Pause"])         return UIBarButtonSystemItemPause;
        if ([imageName isEqualToString:@"toolButton:Rewind"])        return UIBarButtonSystemItemRewind;
        if ([imageName isEqualToString:@"toolButton:FastForward"])   return UIBarButtonSystemItemFastForward;
        if ([imageName isEqualToString:@"toolButton:Undo"])			 return UIBarButtonSystemItemUndo;
        if ([imageName isEqualToString:@"toolButton:Redo"])			 return UIBarButtonSystemItemRedo;
        return -1;
    } else {
        return -1;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"uicontrols.tabBarItemSelected(%d);", item.tag];    
    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

/*********************************************************************************/


/**
 * Create a native tool bar at either the top or the bottom of the display.
 * @brief creates a tool bar
 * @param arguments unused
 * @param options unused
 */
- (void)createToolBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    UIBarStyle style = UIBarStyleDefault;
    NSDictionary* toolBarSettings = [settings objectForKey:@"ToolBarSettings"];
    if (toolBarSettings) {
        NSString *styleStr = [toolBarSettings objectForKey:@"style"];
        if ([styleStr isEqualToString:@"Default"])
            style = UIBarStyleDefault;
        else if ([styleStr isEqualToString:@"BlackOpaque"])
            style = UIBarStyleBlackOpaque;
        else if ([styleStr isEqualToString:@"BlackTranslucent"])
            style = UIBarStyleBlackTranslucent;
	}		

    toolBar = [UIToolbar new];
    [toolBar sizeToFit];
    toolBar.hidden                 = YES;
    toolBar.multipleTouchEnabled   = NO;
    toolBar.autoresizesSubviews    = YES;
    toolBar.userInteractionEnabled = YES;
    toolBar.barStyle               = style;

    [self.webView.superview addSubview:toolBar];
}


/**
 * Show the tool bar after its been created.
 * @brief show the tool bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49) [Currently not supported]
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c top) [Currently not supported]
 */
- (void)showToolBar:(NSArray *)arguments withDict:(NSDictionary *)options
{
	if (!toolBar)
		[self createToolBar:nil withDict:nil];

	if (toolBar.hidden == NO)
		return;
	
    CGFloat height = 49.0f;
	CGFloat heightDiff = 0.0f;
    BOOL atTop = YES;

    NSDictionary* toolBarSettings = [settings objectForKey:@"ToolBarSettings"];
    if (toolBarSettings) {
        if ([toolBarSettings objectForKey:@"height"])
            height = [[toolBarSettings objectForKey:@"height"] floatValue];
        if ([toolBarSettings objectForKey:@"position"])
            atTop  = [[toolBarSettings objectForKey:@"position"] isEqualToString:@"top"];
		
    }
	
	CGFloat heightOption = [[options objectForKey:@"height"] floatValue];
	if (heightOption) {
		height = heightOption;
	}
	
	NSString* position = [options objectForKey:@"position"];
	if (position) {
		atTop = [position isEqualToString:@"top"];
	}
	
    CGRect webViewBounds = webView.bounds;

	if (webViewBounds.size.height == 480) {
		heightDiff = 20.0f;
	}
	
	CGRect toolBarBounds;
	
	if (atTop) {
		toolBarBounds = CGRectMake(
			webViewBounds.origin.x,
			webViewBounds.origin.y,
			webViewBounds.size.width,
			height
		);
		webViewBounds = CGRectMake(
		   webViewBounds.origin.x,
		   webViewBounds.origin.y + height + heightDiff,
		   webViewBounds.size.width,
		   webViewBounds.size.height - height - heightDiff
		);
	} else {
		toolBarBounds = CGRectMake(
								   webViewBounds.origin.x,
								   webViewBounds.origin.y + webViewBounds.size.height - height - heightDiff,
								   webViewBounds.size.width,
								   height
								   );
		webViewBounds = CGRectMake(
								   webViewBounds.origin.x,
								   webViewBounds.origin.y,
								   webViewBounds.size.width,
								   webViewBounds.size.height - height - heightDiff
								   );		
		
	}
	toolBar.hidden= NO;
	
	[toolBar setFrame:toolBarBounds];
	[webView setFrame:webViewBounds];
}

/**
 * Hide the tool bar
 * @brief hide the tool bar
 * @param arguments unused
 * @param options unused
 */

- (void)hideToolBar:(NSArray *)arguments withDict:(NSDictionary *)options 
{
	if (!toolBar)
		[self createToolBar:nil withDict:nil];
	if (toolBar.hidden == YES)
		return;
	
    CGFloat height = 49.0f;
    BOOL atTop = YES;
	
    NSDictionary* toolBarSettings = [settings objectForKey:@"ToolBarSettings"];
    if (toolBarSettings) {
        if ([toolBarSettings objectForKey:@"height"])
            height = [[toolBarSettings objectForKey:@"height"] floatValue];		
    }
	
	CGFloat heightOption = [[options objectForKey:@"height"] floatValue];
	if (heightOption) {
		height = heightOption;
	}
		
    CGRect webViewBounds = webView.bounds;
		
	webViewBounds = CGRectMake(
							   webViewBounds.origin.x,
							   webViewBounds.origin.y,
							   webViewBounds.size.width,
							   webViewBounds.size.height + height
							   );
	
	toolBar.hidden = YES;
	[webView setFrame:webViewBounds];
}


/**
 * Create a new tool bar item for use on a previously created tab bar.  Use ::showToolBarItems to show the new item on the tool bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 * - <b>Tool Buttons</b>
 *   - toolButton:Done
 *   - toolButton:Cancel
 *   - toolButton:Edit
 *   - toolButton:Save
 *   - toolButton:Add
 *   - toolButton:FlexibleSpace
 *   - toolButton:FixedSpace
 *   - toolButton:Compose
 *   - toolButton:Reply
 *   - toolButton:Action
 *   - toolButton:Organize
 *   - toolButton:Bookmarks
 *   - toolButton:Search
 *   - toolButton:Refresh
 *   - toolButton:Stop
 *   - toolButton:Camera
 *   - toolButton:Trash
 *   - toolButton:Play
 *   - toolButton:Pause
 *   - toolButton:Rewind
 *   - toolButton:FastForward
 *   - toolButton:Undo
 *   - toolButton:Redo 
 * @brief create a tool bar item
 * @param arguments Parameters used to create the tab bar
 *  -# \c name internal name to refer to this tab by
 *  -# \c title title text to show on the tab, or null if no text should be shown
 *  -# \c image image filename or internal identifier to show, or null if now image should be shown
 *  -# \c tag unique number to be used as an internal reference to this button
 * @param options Options for customizing the individual tab item
 *  - \c style value to define the style of the button. Options are 'plain', 'done', 'border' and will default to plain if not specified
 *  - \c enabled if set to true then the button is enabled (default) else it is disabled
 */

- (void)createToolBarItem:(NSArray*)arguments withDict:(NSDictionary *)options
{
    if (!toolBar)
        [self createToolBar:nil withDict:nil];
    
    NSString  *name  = [arguments objectAtIndex:0];
    NSString  *title = [arguments objectAtIndex:1];
    NSString  *imageName = [arguments objectAtIndex:2];
    int tag              = [[arguments objectAtIndex:3] intValue];
	
    
	UIBarButtonItemStyle styleRef = UIBarButtonItemStylePlain;
	NSString* style = [options objectForKey:@"style"];
	
	if (style) {
		if ([style isEqualToString:@"plain"])        styleRef = UIBarButtonItemStylePlain;
		else if ([style isEqualToString:@"border"])        styleRef = UIBarButtonItemStyleBordered;
		else if ([style isEqualToString:@"done"])        styleRef = UIBarButtonItemStyleDone;		
	}
	
	
	UIBarButtonItem *item = nil;
	if ([imageName length] > 0) {
		UIBarButtonSystemItem systemItem = -1;
		systemItem = [self getSystemItemFromString:imageName];
		if (systemItem != 1) 
			item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(toolBarItemSelected:)];
	}
	
	if (!item && [title length] > 0) {
		NSLog(@"Creating with custom title");
		item = [[UIBarButtonItem alloc] initWithTitle:title style:styleRef target:self action:@selector(toolBarItemSelected:)];		
	}
	
	if (!item) {
		NSLog(@"Creating with custom image");
		item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:styleRef target:self action:@selector(toolBarItemSelected:)];
	}
	
	if (item) {
		item.tag = tag;
		
		
		NSString* enabled = [options objectForKey:@"enabled"];
		if (enabled) {
			if ([enabled isEqualToString:@"true"]) {
				item.enabled = YES;
			} else {
				item.enabled = NO;
			}
		} 
	}
	
    [toolBarItems setObject:item forKey:name];
}


/**
 * Update an existing tool bar item to change its title string, image or enable/disable it value.
 * @brief update the title string, image, or enable/disable a tool bar item
 * @param arguments Parameters used to identify the tab bar item to update
 *  -# \c name internal name used to represent this item when it was created
 *  -# \c value New title for a title item, new image path to a new image item or nil if you just want to disable/enable
 * @param options Options for customizing the individual tab item
 *  - \c enabled true to enable the item and anything else will disable it
 */
- (void)updateToolBarItem:(NSArray *)arguments withDict:(NSDictionary *)options
{
	if (!toolBar)
		[self createToolBar:nil withDict:nil];
	
	NSString *name = [arguments objectAtIndex:0];
	NSString *value = [arguments objectAtIndex:1];
	
	
	UIBarButtonItem *item = [toolBarItems objectForKey:name];
	if (item) {
		
		if (value) {
			if (item.title) {
				item.title = value;
			} else if (item.image) {
				item.image = [UIImage imageNamed:value];
			}
		}

		NSString* enabled = [options objectForKey:@"enabled"];
		if (enabled) {
			if ([enabled isEqualToString:@"true"]) {
				item.enabled = YES;
			} else {
				item.enabled = NO;
			}
		} 
	}
}

/**
 * Show previously created items on the tool bar
 * @brief show a list of tool bar items
 * @param arguments the item names to be shown
 * @param options dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createToolBarItem
 * @see createToolBar
 */
- (void)showToolBarItems:(NSArray *)arguments withDict:(NSDictionary *)options
{
	if (!toolBar)
		[self createToolBar:nil withDict:nil];

    int i, count = [arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 0; i < count; i++) {
        NSString *itemName = [arguments objectAtIndex:i];
        UITabBarItem *item = [toolBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }
    
    BOOL animateItems = NO;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
	
    [toolBar setItems:items animated:animateItems];
	[items release];
}

/**
 * Callback that handles all the tool bar button presses
 */
- (void)toolBarItemSelected:(UIBarButtonItem*)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"uicontrols.toolBarItemSelected(%d);", item.tag];    
    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)dealloc
{
    if (tabBar)
        [tabBar release];
	if (toolBar) {
		[toolBar release];
	}
    [super dealloc];
}

@end
