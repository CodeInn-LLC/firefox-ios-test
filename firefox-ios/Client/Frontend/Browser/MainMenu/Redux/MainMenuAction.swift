// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import MenuKit
import Redux

final class MainMenuAction: Action {
    var navigationDestination: MainMenuNavigationDestination?

    init(
        windowUUID: WindowUUID,
        actionType: any ActionType,
        navigationDestination: MainMenuNavigationDestination? = nil
    ) {
        self.navigationDestination = navigationDestination
        super.init(windowUUID: windowUUID, actionType: actionType)
    }
}

enum MainMenuDetailsViewType {
    case tools
    case save
}

enum MainMenuActionType: ActionType {
    case closeMenu
    case mainMenuDidAppear
    case show
    case openDetailsViewTo(MainMenuDetailsViewType, title: String)
    case toggleNightMode
    case toggleUserAgent
    case updateCurrentTabInfo(MainMenuTabInfo?)
    case viewDidLoad
    case viewWillDisappear
}

enum MainMenuNavigationDestination: Equatable {
    case bookmarks
    case customizeHomepage
    case downloads
    case findInPage
    case goToURL(URL?)
    case history
    case newTab
    case newPrivateTab
    case passwords
    case settings

    /// This must manually be done, because we can't conform to `CaseIterable`
    /// when we have enums with associated types
    static var allCases: [MainMenuNavigationDestination] {
        return [
            .bookmarks,
            .customizeHomepage,
            .downloads,
            .findInPage,
            .goToURL(nil),
            .history,
            .newTab,
            .newPrivateTab,
            .passwords,
            .settings,
        ]
    }
}

enum MainMenuMiddlewareActionType: ActionType {
    case provideTabInfo(MainMenuTabInfo?)
    case requestTabInfo
    case updateSubmenuTypeTo(MainMenuDetailsViewType)
}

enum MainMenuDetailsActionType: ActionType {
    case dismissView
    case updateSubmenuType(MainMenuDetailsViewType)
    case viewDidLoad
    case viewDidDisappear
}