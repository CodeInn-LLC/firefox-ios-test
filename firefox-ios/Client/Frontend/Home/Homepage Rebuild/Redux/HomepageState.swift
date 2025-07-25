// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Redux

struct HomepageState: ScreenState, Equatable {
    var windowUUID: WindowUUID

    // Homepage sections state in the order they appear on the collection view
    let headerState: HeaderState
    let messageState: MessageCardState
    let topSitesState: TopSitesSectionState
    let searchState: SearchBarState
    let jumpBackInState: JumpBackInSectionState
    let bookmarkState: BookmarksSectionState
    let pocketState: PocketState
    let wallpaperState: WallpaperState

    /// FXIOS-11504 - This is mainly used for telemetry for top sites and pocket and presenting CFRs.
    /// At this time, we are keeping `isZeroSearch` the same as legacy. However, we should revisit this value
    /// and confirm what the expectation is, as it seems inconsistent. See more details in ticket.
    ///
    /// FXIOS-6203 - Comment from legacy homepage:
    /// `isZeroSearch` is true when the homepage is created from the tab tray, a long press
    /// on the tab bar to open a new tab or by pressing the home page button on the tab bar.
    /// The zero search page, aka when the home page is shown by clicking the url bar from a loaded web page.
    /// This needs to be set properly for telemetry and the contextual pop overs that appears on homepage
    let isZeroSearch: Bool
    let shouldTriggerImpression: Bool
    let shouldShowSpacer: Bool

    init(appState: AppState, uuid: WindowUUID) {
        guard let homepageState = store.state.screenState(
            HomepageState.self,
            for: .homepage,
            window: uuid
        ) else {
            self.init(windowUUID: uuid)
            return
        }

        self.init(
            windowUUID: homepageState.windowUUID,
            headerState: homepageState.headerState,
            messageState: homepageState.messageState,
            topSitesState: homepageState.topSitesState,
            searchState: homepageState.searchState,
            jumpBackInState: homepageState.jumpBackInState,
            bookmarkState: homepageState.bookmarkState,
            pocketState: homepageState.pocketState,
            wallpaperState: homepageState.wallpaperState,
            isZeroSearch: homepageState.isZeroSearch,
            shouldTriggerImpression: homepageState.shouldTriggerImpression,
            shouldShowSpacer: homepageState.shouldShowSpacer
        )
    }

    init(windowUUID: WindowUUID) {
        self.init(
            windowUUID: windowUUID,
            headerState: HeaderState(windowUUID: windowUUID),
            messageState: MessageCardState(windowUUID: windowUUID),
            topSitesState: TopSitesSectionState(windowUUID: windowUUID),
            searchState: SearchBarState(windowUUID: windowUUID),
            jumpBackInState: JumpBackInSectionState(windowUUID: windowUUID),
            bookmarkState: BookmarksSectionState(windowUUID: windowUUID),
            pocketState: PocketState(windowUUID: windowUUID),
            wallpaperState: WallpaperState(windowUUID: windowUUID),
            isZeroSearch: false,
            shouldTriggerImpression: false,
            shouldShowSpacer: false
        )
    }

    private init(
        windowUUID: WindowUUID,
        headerState: HeaderState,
        messageState: MessageCardState,
        topSitesState: TopSitesSectionState,
        searchState: SearchBarState,
        jumpBackInState: JumpBackInSectionState,
        bookmarkState: BookmarksSectionState,
        pocketState: PocketState,
        wallpaperState: WallpaperState,
        isZeroSearch: Bool,
        shouldTriggerImpression: Bool,
        shouldShowSpacer: Bool
    ) {
        self.windowUUID = windowUUID
        self.headerState = headerState
        self.messageState = messageState
        self.topSitesState = topSitesState
        self.searchState = searchState
        self.jumpBackInState = jumpBackInState
        self.bookmarkState = bookmarkState
        self.pocketState = pocketState
        self.wallpaperState = wallpaperState
        self.isZeroSearch = isZeroSearch
        self.shouldTriggerImpression = shouldTriggerImpression
        self.shouldShowSpacer = shouldShowSpacer
    }

    static let reducer: Reducer<Self> = { state, action in
        guard action.windowUUID == .unavailable || action.windowUUID == state.windowUUID
        else {
            return defaultState(from: state, action: action)
        }

        switch action.actionType {
        case HomepageActionType.initialize, HomepageActionType.viewWillTransition:
            return handleInitializeAndViewWillTransitionAction(state: state, action: action)
        case HomepageActionType.embeddedHomepage:
            guard let isZeroSearch = (action as? HomepageAction)?.isZeroSearch else {
                return defaultState(from: state)
            }

            return handleEmbeddedHomepageAction(state: state, action: action, isZeroSearch: isZeroSearch)
        case GeneralBrowserActionType.didSelectedTabChangeToHomepage:
            return handleDidTabChangeToHomepageAction(state: state, action: action)
        case HomepageMiddlewareActionType.configuredSpacer:
            return handleSpacerInitialization(action: action, state: state)
        default:
            return defaultState(from: state, action: action)
        }
    }

    private static func handleInitializeAndViewWillTransitionAction(state: HomepageState, action: Action) -> HomepageState {
        return HomepageState(
            windowUUID: state.windowUUID,
            headerState: HeaderState.reducer(state.headerState, action),
            messageState: MessageCardState.reducer(state.messageState, action),
            topSitesState: TopSitesSectionState.reducer(state.topSitesState, action),
            searchState: SearchBarState.reducer(state.searchState, action),
            jumpBackInState: JumpBackInSectionState.reducer(state.jumpBackInState, action),
            bookmarkState: BookmarksSectionState.reducer(state.bookmarkState, action),
            pocketState: PocketState.reducer(state.pocketState, action),
            wallpaperState: WallpaperState.reducer(state.wallpaperState, action),
            isZeroSearch: state.isZeroSearch,
            shouldTriggerImpression: false,
            shouldShowSpacer: state.shouldShowSpacer
        )
    }

    private static func handleEmbeddedHomepageAction(state: HomepageState,
                                                     action: Action,
                                                     isZeroSearch: Bool) -> HomepageState {
        return HomepageState(
            windowUUID: state.windowUUID,
            headerState: HeaderState.reducer(state.headerState, action),
            messageState: MessageCardState.reducer(state.messageState, action),
            topSitesState: TopSitesSectionState.reducer(state.topSitesState, action),
            searchState: SearchBarState.reducer(state.searchState, action),
            jumpBackInState: JumpBackInSectionState.reducer(state.jumpBackInState, action),
            bookmarkState: BookmarksSectionState.reducer(state.bookmarkState, action),
            pocketState: PocketState.reducer(state.pocketState, action),
            wallpaperState: WallpaperState.reducer(state.wallpaperState, action),
            isZeroSearch: isZeroSearch,
            shouldTriggerImpression: false,
            shouldShowSpacer: state.shouldShowSpacer
        )
    }

    private static func handleDidTabChangeToHomepageAction(state: HomepageState, action: Action) -> HomepageState {
        return HomepageState(
            windowUUID: state.windowUUID,
            headerState: HeaderState.reducer(state.headerState, action),
            messageState: MessageCardState.reducer(state.messageState, action),
            topSitesState: TopSitesSectionState.reducer(state.topSitesState, action),
            searchState: SearchBarState.reducer(state.searchState, action),
            jumpBackInState: JumpBackInSectionState.reducer(state.jumpBackInState, action),
            bookmarkState: BookmarksSectionState.reducer(state.bookmarkState, action),
            pocketState: PocketState.reducer(state.pocketState, action),
            wallpaperState: WallpaperState.reducer(state.wallpaperState, action),
            isZeroSearch: state.isZeroSearch,
            shouldTriggerImpression: true,
            shouldShowSpacer: state.shouldShowSpacer
        )
    }

    private static func handleSpacerInitialization(action: Action, state: Self) -> HomepageState {
        guard let isSpacerEnabled = (action as? HomepageAction)?.shouldShowSpacer else {
            return defaultState(from: state)
        }

        return HomepageState(
            windowUUID: state.windowUUID,
            headerState: HeaderState.reducer(state.headerState, action),
            messageState: MessageCardState.reducer(state.messageState, action),
            topSitesState: TopSitesSectionState.reducer(state.topSitesState, action),
            searchState: SearchBarState.reducer(state.searchState, action),
            jumpBackInState: JumpBackInSectionState.reducer(state.jumpBackInState, action),
            bookmarkState: BookmarksSectionState.reducer(state.bookmarkState, action),
            pocketState: PocketState.reducer(state.pocketState, action),
            wallpaperState: WallpaperState.reducer(state.wallpaperState, action),
            isZeroSearch: state.isZeroSearch,
            shouldTriggerImpression: false,
            shouldShowSpacer: isSpacerEnabled
        )
    }

    private static func defaultState(from state: HomepageState, action: Action?) -> HomepageState {
        var headerState = state.headerState
        var messageState = state.messageState
        var pocketState = state.pocketState
        var topSitesState = state.topSitesState
        var searchState = state.searchState
        var jumpBackInState = state.jumpBackInState
        var bookmarkState = state.bookmarkState
        var wallpaperState = state.wallpaperState

        if let action {
            headerState = HeaderState.reducer(state.headerState, action)
            messageState = MessageCardState.reducer(state.messageState, action)
            pocketState = PocketState.reducer(state.pocketState, action)
            searchState = SearchBarState.reducer(state.searchState, action)
            jumpBackInState = JumpBackInSectionState.reducer(state.jumpBackInState, action)
            bookmarkState = BookmarksSectionState.reducer(state.bookmarkState, action)
            topSitesState = TopSitesSectionState.reducer(state.topSitesState, action)
            wallpaperState = WallpaperState.reducer(state.wallpaperState, action)
        }

        return HomepageState(
            windowUUID: state.windowUUID,
            headerState: headerState,
            messageState: messageState,
            topSitesState: topSitesState,
            searchState: searchState,
            jumpBackInState: jumpBackInState,
            bookmarkState: bookmarkState,
            pocketState: pocketState,
            wallpaperState: wallpaperState,
            isZeroSearch: state.isZeroSearch,
            shouldTriggerImpression: false,
            shouldShowSpacer: state.shouldShowSpacer
        )
    }

    static func defaultState(from state: HomepageState) -> HomepageState {
        return defaultState(from: state, action: nil)
    }
}
