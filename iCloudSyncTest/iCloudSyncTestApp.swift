//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import SwiftUI
import CoreData

@main
struct iCloudSyncTestApp: App {
    
    private let coreDataStore: CoreDataStore

    init() {
        let storeURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("store.sqlite")

        do {
            self.coreDataStore = try CoreDataStore(storeURL: storeURL, containerIdentifier: Static.cloudIdentifier)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStore.container.viewContext)
        }
    }
}
