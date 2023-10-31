//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import CoreData

import CoreData

extension NSManagedObjectModel {
    public static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

public final class CoreDataStore {
    private static let modelName = "iCloudSyncTest"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle.main)
    
    let container: NSPersistentContainer
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
        case failedToGetPersistentStoreDescription
    }
    
    public init(storeURL: URL, containerIdentifier: String? = nil) throws {
        guard let model = Self.model else {
            throw StoreError.modelNotFound
        }

        container = NSPersistentCloudKitContainer(name: Self.modelName, managedObjectModel: model)
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        if let containerIdentifier = containerIdentifier {
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        }
        
        container.persistentStoreDescriptions = [storeDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
    }
}
