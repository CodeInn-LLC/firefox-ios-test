// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

@testable import Client

final class MockPocketManager: PocketManagerProvider, @unchecked Sendable {
    var getPocketItemsCalled = 0
    func getPocketItems() async -> [PocketStoryConfiguration] {
        getPocketItemsCalled += 1
        let stories: [PocketFeedStory] = [
            .make(title: "feed1"),
            .make(title: "feed2"),
            .make(title: "feed3"),
        ]

        return stories.compactMap { PocketStoryConfiguration(story: PocketStory(pocketFeedStory: $0)) }
    }
}
