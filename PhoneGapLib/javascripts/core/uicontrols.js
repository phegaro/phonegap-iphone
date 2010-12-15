/**
 * This class exposes mobile phone interface controls to JavaScript, such as
 * native tab and tool bars, etc.
 * @constructor
 */
function UIControls() {
    this.tabBarTag = 0;
    this.tabBarCallbacks = {};

    this.toolBarTag = 0;
    this.toolBarItems = [];
}

/**
 * Create a native tab bar that can have tab buttons added to it which can respond to events.
 */
UIControls.prototype.createTabBar = function() {
    PhoneGap.exec("UIControls.createTabBar");
};

/**
 * Show a tab bar.  The tab bar has to be created first.
 * @param {Object} [options] Options indicating how the tab bar should be shown:
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
UIControls.prototype.showTabBar = function(options) {
    if (!options) options = {};
    PhoneGap.exec("UIControls.showTabBar", options);
};

/**
 * Hide a tab bar.  The tab bar has to be created first.
 */
UIControls.prototype.hideTabBar = function(animate) {
    if (animate == undefined || animate == null)
        animate = true;
    PhoneGap.exec("UIControls.hideTabBar", { animate: animate });
};

/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 *
 * <b>Tab Buttons</b>
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
 * @param {String} name internal name to refer to this tab by
 * @param {String} [title] title text to show on the tab, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
UIControls.prototype.createTabBarItem = function(name, label, image, options) {
    var tag = this.tabBarTag++;
    if (options && 'onSelect' in options && typeof(options['onSelect']) == 'function') {
        this.tabBarCallbacks[tag] = options.onSelect;
        delete options.onSelect;
    }
    PhoneGap.exec("UIControls.createTabBarItem", name, label, image, tag, options);
};

/**
 * Update an existing tab bar item to change its badge value.
 * @param {String} name internal name used to represent this item when it was created
 * @param {Object} options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
UIControls.prototype.updateTabBarItem = function(name, options) {
    if (!options) options = {};
    PhoneGap.exec("UIControls.updateTabBarItem", name, options);
};

/**
 * Show previously created items on the tab bar
 * @param {String} arguments... the item names to be shown
 * @param {Object} [options] dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
UIControls.prototype.showTabBarItems = function() {
    var parameters = [ "UIControls.showTabBarItems" ];
    for (var i = 0; i < arguments.length; i++) {
        parameters.push(arguments[i]);
    }
    PhoneGap.exec.apply(this, parameters);
};

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @param {String} tabName the name of the tab to select, or null if all tabs should be deselected
 * @see createTabBarItem
 * @see showTabBarItems
 */
UIControls.prototype.selectTabBarItem = function(tab) {
    PhoneGap.exec("UIControls.selectTabBarItem", tab);
};

/**
 * Function called when a tab bar item has been selected.
 * @param {Number} tag the tag number for the item that has been selected
 */
UIControls.prototype.tabBarItemSelected = function(tag) {
    if (typeof(this.tabBarCallbacks[tag]) == 'function')
        this.tabBarCallbacks[tag]();
};

/**
 * Create a native tool bar that can have buttons / text added to it which can respond to events.
 */
UIControls.prototype.createToolBar = function() {
    PhoneGap.exec("UIControls.createToolBar");
};

/**
 * Show a toolbar (Currently options are not supported)
 * @param {Object} [options] Options indicating how the tab bar should be shown:
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
UIControls.prototype.showToolBar = function(options) {
    if (!options) options = {};
    PhoneGap.exec("UIControls.showToolBar", options);
};

/**
 * Hide a tab bar.  The tool bar has to be created first.
 */
UIControls.prototype.hideToolBar = function(animate) {
    if (animate == undefined || animate == null)
        animate = true;
    PhoneGap.exec("UIControls.hideToolBar", { animate: animate });
};

/**
 * Create a new tool bar item for use on a previously created tool bar.  Use ::showToolBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 *
 * <b>Tool Buttons</b>
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
 * @param {String} name internal name to refer to this button by
 * @param {String} [title] title text to show on the button, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item
 *  - \c style value to define the style of the button. Options are 'plain', 'done', 'border' and will default to plain if not specified
 *  - \c enabled if set to true then the button is enabled (default) else it is disabled
 *  - \c onSelect function to call when this item is selected
 */
UIControls.prototype.createToolBarItem = function(name, label, image, options) {
    var tag = this.toolBarTag++;

    var toolBarItem = {name: name};
    if (options && 'onSelect' in options && typeof(options['onSelect']) == 'function') {
        toolBarItem.onSelect = options.onSelect;
        delete options.onSelect;
    }
    this.toolBarItems.push(toolBarItem);
    PhoneGap.exec("UIControls.createToolBarItem", name, label, image, tag, options);
};

/**
 * Update an existing tool bar item to change its label or its image
 * @param {String} name internal name used to represent this item when it was created
 * @param {String} label new label for this item. This only works for text items
 * @param {Object} [options] Options for customizing the individual tab item
 *  - \c enabled if set to true then the button is enabled (default) else it is disabled
 */
UIControls.prototype.updateToolBarItem = function(name, label, options) {
    if (options && 'onSelect' in options && typeof(options['onSelect']) == 'function') {
      for (var i=0; i < this.toolBarItems.length; i++) {
        var item = this.toolBarItems[i];
          if (item.name == name) {
            item.onSelect = options.onSelect;
            delete options.onSelect;
          }
        }
    }
    PhoneGap.exec("UIControls.updateToolBarItem", name, label, options);
};

/**
 * Show previously created items on the tool bar
 * @param {String} arguments... the item names to be shown
 * @param {Object} [options] dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tool bar
 * @see createToolBarItem
 * @see createToolBar
 */
UIControls.prototype.showToolBarItems = function() {
    var parameters = [ "UIControls.showToolBarItems" ];
    for (var i = 0; i < arguments.length; i++) {
        parameters.push(arguments[i]);
    }
    PhoneGap.exec.apply(this, parameters);
};

/**
 * Function called when a tool bar item has been selected.
 * @param {Number} name the name for the item that has been selected
 */
UIControls.prototype.toolBarItemSelected = function(tag) {
    if (typeof(this.toolBarItems[tag].onSelect) == 'function')
        this.toolBarItems[tag].onSelect();
};

PhoneGap.addConstructor(function() {
    window.uicontrols = new UIControls();
});

