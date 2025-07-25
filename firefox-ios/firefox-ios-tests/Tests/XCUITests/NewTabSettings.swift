// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import XCTest

let websiteUrl = "www.mozilla.org"
class NewTabSettingsTest: FeatureFlaggedTestBase {
    // https://mozilla.testrail.io/index.php?/cases/view/2307026
    // Smoketest
    func testCheckNewTabSettingsByDefault() {
        app.launch()
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        waitForElementsToExist(
            [
                app.navigationBars["New Tab"],
                app.tables.cells["Firefox Home"],
                app.tables.cells["Blank Page"],
                app.tables.cells["NewTabAsCustomURL"]
            ]
        )
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307027
    // Smoketest
    func testChangeNewTabSettingsShowBlankPage_tabTrayExperimentOff_swipingTabsExperimentOff() {
        addLaunchArgument(jsonFileName: "defaultEnabledOff", featureName: "tab-tray-ui-experiments")
        addLaunchArgument(jsonFileName: "swipingTabsOff", featureName: "toolbar-refactor-feature")
        app.launch()
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])

        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        XCTAssertTrue(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
        let keyboardCount = app.keyboards.count
        XCTAssert(keyboardCount > 0, "The keyboard is not shown")
        mozWaitForElementToNotExist(app.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell])
        mozWaitForElementToNotExist(app.collectionViews.cells.staticTexts["YouTube"])
        mozWaitForElementToNotExist(app.staticTexts["Highlights"])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307027
    // Smoketest
    func testChangeNewTabSettingsShowBlankPage_tabTrayExperimentOff_swipinTabsExperimentOn() {
        addLaunchArgument(jsonFileName: "defaultEnabledOff", featureName: "tab-tray-ui-experiments")
        addLaunchArgument(jsonFileName: "swipingTabsOn", featureName: "toolbar-refactor-feature")
        app.launch()
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])

        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        XCTAssertTrue(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
        let keyboardCount = app.keyboards.count
        XCTAssert(keyboardCount > 0, "The keyboard is not shown")
        // With swiping tabs on, the homepage is cached so it should be having those elements
        mozWaitForElementToExist(app.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell])
        mozWaitForElementToExist(app.links.staticTexts["YouTube"])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307027
    // Smoketest
    func testChangeNewTabSettingsShowBlankPage_tabTrayToolbarOnHomepageOff() {
        addLaunchArgument(jsonFileName: "defaultEnabledOn", featureName: "toolbar-refactor-feature")
        addLaunchArgument(jsonFileName: "defaultEnabledOn", featureName: "tab-tray-ui-experiments")
        addLaunchArgument(jsonFileName: "homepageSearchBarOff", featureName: "homepage-redesign-feature")
        addLaunchArgument(jsonFileName: "storiesRedesignOff", featureName: "homepage-redesign-feature")
        app.launch()
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])

        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        // Keyboard is not focused with the experiment ON on iPhone
        // For iPad the keyboard is shown
        if iPad() {
            XCTAssertTrue(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
            let keyboardCount = app.keyboards.count
            XCTAssertEqual(keyboardCount, 1, "The keyboard should be shown on iPad")
        } else {
            XCTAssertFalse(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
            let keyboardCount = app.keyboards.count
            XCTAssertEqual(keyboardCount, 0, "The keyboard should not show")
        }
        XCTAssertFalse(
            app.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell].isHittable,
            "TopSitesCell should not be visible or interactable on the current screen"
        )
        mozWaitForElementToNotExist(app.collectionViews.cells.staticTexts["YouTube"])
        mozWaitForElementToNotExist(app.staticTexts["Highlights"])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307027
    // Smoketest
    func testChangeNewTabSettingsShowBlankPage_tabTrayExperimentOn_swipinTabsExperimentOn() {
        addLaunchArgument(jsonFileName: "swipingTabsOn", featureName: "toolbar-refactor-feature")
        addLaunchArgument(jsonFileName: "defaultEnabledOn", featureName: "tab-tray-ui-experiments")
        app.launch()
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])

        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        // Keyboard is not focused with the experiment ON on iPhone
        // For iPad the keyboard is shown
        if iPad() {
            XCTAssertTrue(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
            let keyboardCount = app.keyboards.count
            XCTAssertEqual(keyboardCount, 1, "The keyboard should be shown on iPad")
        } else {
            XCTAssertFalse(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
            let keyboardCount = app.keyboards.count
            XCTAssertEqual(keyboardCount, 0, "The keyboard should not show")
        }
        // With swiping tabs on, the homepage is cached so it should be having those elements
        mozWaitForElementToExist(app.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell])
        mozWaitForElementToExist(app.links.staticTexts["YouTube"])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307028
    func testChangeNewTabSettingsShowFirefoxHome_tabTrayExperimentOff_swipingTabsExperimentOff() {
        addLaunchArgument(jsonFileName: "swipingTabsOff", featureName: "toolbar-refactor-feature")
        addLaunchArgument(jsonFileName: "defaultEnabledOff", featureName: "tab-tray-ui-experiments")
        app.launch()
        // Set to history page first since FF Home is default
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Browser.UrlBar.cancelButton])
        navigator.performAction(Action.CloseURLBarOpen)
        navigator.nowAt(NewTabScreen)
        mozWaitForElementToNotExist(
            app.collectionViews.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell]
        )

        // Now check if it switches to FF Home
        navigator.goto(SettingsScreen)
        navigator.goto(NewTabSettings)
        navigator.performAction(Action.SelectNewTabAsFirefoxHomePage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        mozWaitForElementToExist(app.collectionViews.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell])
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307028
    func testChangeNewTabSettingsShowFirefoxHome_tabTrayExperimentOff_swipingTabsExperimentOn() {
        addLaunchArgument(jsonFileName: "swipingTabsOn", featureName: "toolbar-refactor-feature")
        addLaunchArgument(jsonFileName: "defaultEnabledOff", featureName: "tab-tray-ui-experiments")
        app.launch()
        // Set to history page first since FF Home is default
        waitForTabsButton()
        navigator.nowAt(NewTabScreen)
        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Browser.UrlBar.cancelButton])
        navigator.performAction(Action.CloseURLBarOpen)
        navigator.nowAt(NewTabScreen)
        // homepage has to be still there since it is cached when swiping tabs is on
        mozWaitForElementToExist(
            app.collectionViews.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell]
        )

        // Now check if it switches to FF Home
        navigator.goto(SettingsScreen)
        navigator.goto(NewTabSettings)
        navigator.performAction(Action.SelectNewTabAsFirefoxHomePage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        mozWaitForElementToExist(
            app.collectionViews.links[AccessibilityIdentifiers.FirefoxHomepage.TopSites.itemCell]
        )
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307029
    // Smoketest
    func testChangeNewTabSettingsShowCustomURL() {
        app.launch()
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])
        // Check the placeholder value
        mozWaitForValueContains(app.textFields["NewTabAsCustomURLTextField"], value: "Custom URL")
        navigator.performAction(Action.SelectNewTabAsCustomURL)
        // Check the value typed
        app.textFields["NewTabAsCustomURLTextField"].typeText("mozilla.org")
        guard let valueTyped = app.textFields["NewTabAsCustomURLTextField"].value as? String else {
            XCTFail("Failed to retreive the value from 'NewTabAsCustomURLTextField' text field")
            return
        }
        mozWaitForValueContains(app.textFields["NewTabAsCustomURLTextField"], value: "mozilla")
        XCTAssertEqual(valueTyped, "mozilla.org")
        // Open new page and check that the custom url is used
        navigator.performAction(Action.OpenNewTabFromTabTray)

        navigator.nowAt(NewTabScreen)
        // Check that website is open
        mozWaitForElementToExist(app.webViews.firstMatch, timeout: TIMEOUT_LONG)
        mozWaitForValueContains(app.textFields[AccessibilityIdentifiers.Browser.AddressToolbar.searchTextField],
                                value: "mozilla")
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2307030
    func testChangeNewTabSettingsLabel() {
        app.launch()
        navigator.nowAt(NewTabScreen)
        // Go to New Tab settings and select Custom URL option
        navigator.performAction(Action.SelectNewTabAsCustomURL)
        navigator.nowAt(NewTabSettings)
        // Enter a custom URL
        app.textFields["NewTabAsCustomURLTextField"].typeText(websiteUrl)
        mozWaitForValueContains(app.textFields["NewTabAsCustomURLTextField"], value: "mozilla")
        navigator.goto(SettingsScreen)
        // Assert that the label showing up in Settings is equal to Custom
        XCTAssertEqual(app.tables.cells["NewTab"].label, "New Tab, Custom")
        // Switch to Blank page and check label
        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.nowAt(NewTabSettings)
        navigator.goto(SettingsScreen)
        XCTAssertEqual(app.tables.cells["NewTab"].label, "New Tab, Blank Page")
        // Switch to FXHome and check label
        navigator.performAction(Action.SelectNewTabAsFirefoxHomePage)
        navigator.nowAt(NewTabSettings)
        navigator.goto(SettingsScreen)
        XCTAssertEqual(app.tables.cells["NewTab"].label, "New Tab, Firefox Home")
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306877
    // Smoketest
    func testKeyboardRaisedWhenTabOpenedFromTabTray_tabTrayExperimentOff() {
        addLaunchArgument(jsonFileName: "defaultEnabledOff", featureName: "tab-tray-ui-experiments")
        app.launch()
        // Add New tab and set it as Blank
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])
        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        validateKeyboardIsRaisedAndDismissed()

        // Switch to Private Browsing
        navigator.nowAt(NewTabScreen)
        navigator.toggleOn(userState.isPrivate, withAction: Action.TogglePrivateMode)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        validateKeyboardIsRaisedAndDismissed()
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306877
    // Smoketest
    func testKeyboardNotRaisedWhenTabOpenedFromTabTray_tabTrayExperimentOn() {
        addLaunchArgument(jsonFileName: "defaultEnabledOn", featureName: "tab-tray-ui-experiments")
        app.launch()
        // Add New tab and set it as Blank
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        mozWaitForElementToExist(app.navigationBars["New Tab"])
        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        validateKeyboardIsRaised()

        // Switch to Private Browsing
        navigator.nowAt(NewTabScreen)
        navigator.toggleOn(userState.isPrivate, withAction: Action.ToggleExperimentPrivateMode)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        validateKeyboardIsRaised()
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306875
    // Smoketest
    func testNewTabCustomURLKeyboardNotRaised() {
        app.launch()
        // Set a custom URL
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        navigator.nowAt(NewTabScreen)
        navigator.goto(NewTabSettings)
        navigator.performAction(Action.SelectNewTabAsCustomURL)
        // Check the value typed
        app.textFields["NewTabAsCustomURLTextField"].typeText("mozilla.org")
        mozWaitForValueContains(app.textFields["NewTabAsCustomURLTextField"], value: "mozilla")
        // Open new page and check that the custom url is used and he keyboard is not raised up
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitUntilPageLoad()
        let url = app.textFields[AccessibilityIdentifiers.Browser.AddressToolbar.searchTextField]
        mozWaitForValueContains(url, value: "mozilla")
        XCTAssertFalse(url.isSelected, "The URL has the focus")
        XCTAssertFalse(app.keyboards.element.isVisible(), "The keyboard is shown")
        app.textFields[AccessibilityIdentifiers.Browser.AddressToolbar.searchTextField].waitAndTap()
    }

    private func validateKeyboardIsRaisedAndDismissed() {
        // The keyboard is raised up
        XCTAssertTrue(urlBarAddress.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
        XCTAssertTrue(app.keyboards.element.isVisible(), "The keyboard is not shown")
        // Tap the back button
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Browser.UrlBar.cancelButton])
        navigator.performAction(Action.CloseURLBarOpen)
        // The keyboard is dismissed and the URL is unfocused
        let url = app.textFields[AccessibilityIdentifiers.Browser.AddressToolbar.searchTextField]
        mozWaitForElementToExist(url)
        XCTAssertFalse(url.isSelected, "The URL has the focus")
        XCTAssertFalse(app.keyboards.element.isVisible(), "The keyboard is shown")
    }

    private func validateKeyboardIsRaised() {
        let url = app.textFields[AccessibilityIdentifiers.Browser.AddressToolbar.searchTextField]
        mozWaitForElementToExist(url)
        XCTAssertFalse(url.isSelected, "The URL has the focus")
        if iPad() {
            XCTAssertTrue(app.keyboards.element.isVisible(), "The keyboard should be shown on iPad")
        } else {
            XCTAssertFalse(app.keyboards.element.isVisible(), "The keyboard is shown")
        }
    }
}
