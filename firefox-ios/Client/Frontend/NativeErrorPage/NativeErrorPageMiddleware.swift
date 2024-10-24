// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Redux
import Shared
import Common

final class NativeErrorPageMiddleware {
    lazy var nativeErrorPageProvider: Middleware<AppState> = { state, action in
        let windowUUID = action.windowUUID
        print(action.actionType)
        switch action.actionType {
        case NativeErrorPageActionType.receivedError:
            guard let action = action as? NativeErrorPageAction, let error = action.networkError else {return}
            self.initializeNativeErrorPage(windowUUID: windowUUID, error: error)
            break
        default:
           break
        }
    }

    private func initializeNativeErrorPage(windowUUID: WindowUUID, error: NSError) {
        let model = NativeErrorPageHelper(error: error).parseErrorDetails()
        let newAction = NativeErrorPageAction(nativePageErrorModel: model,
                                              windowUUID: windowUUID,
                                              actionType: NativeErrorPageMiddlewareActionType.initialize
        )
        store.dispatch(newAction)
    }
}
