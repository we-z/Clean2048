//
//  Clean2048App.swift
//  Clean2048
//
//  Created by Wheezy Capowdis on 11/20/24.
//

import SwiftUI

@main
struct BXNApp: App {
    var body: some Scene {
        WindowGroup {
            CompositeView()
                .prefersPersistentSystemOverlaysHidden()
        }
    }
}