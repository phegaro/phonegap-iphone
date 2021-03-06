//
//  UIControls.h
//  PhoneGap
//
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITabBar.h>
#import <UIKit/UIToolbar.h>

#import "PhoneGapCommand.h"

@interface UIControls : PhoneGapCommand <UITabBarDelegate> {
    UITabBar* tabBar;
    NSMutableDictionary* tabBarItems;
    
    UIToolbar* toolBar;
    UIBarButtonItem* toolBarTitle;
    NSMutableDictionary* toolBarItems;
}

/* Tab Bar methods 
 */
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;

- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;

/* Tool Bar methods
 */
- (void)createToolBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showToolBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideToolBar:(NSArray*)arguments withDict:(NSDictionary*)options;

- (void)createToolBarItem:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)updateToolBarItem:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)showToolBarItems:(NSArray *)arguments withDict:(NSDictionary *)options;

/*
- (void)setToolBarTitle:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)toolBarTitleClicked;
*/

- (void)toolBarItemSelected:(UIBarButtonItem*)item;

/*
- (void)createToolBarButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)createToolBarTitle:(NSArray*)arguments withDict:(NSDictionary*)options;
*/

- (UIBarButtonSystemItem)getSystemItemFromString:(NSString*)imageName;


@end
