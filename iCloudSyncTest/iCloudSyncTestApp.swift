//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import SwiftUI

@main
struct iCloudSyncTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
