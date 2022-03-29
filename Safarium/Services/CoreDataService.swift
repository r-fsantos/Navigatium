//
//  CoreDataService.swift
//  Safarium
//
//  Created by Renato F. dos Santos Jr on 28/03/22.
//

import Foundation
import CoreData
import UIKit

typealias onCompletion = (String) -> Void

protocol ServiceGetDataProtocol {
    func getData() -> [UrlData]
}

protocol ServiceUpdateProtocol {
    func update(favorite: UrlData, onCompletionHandler: (String) -> Void)
}

protocol ServiceSaveProtocol {
    func save(favorite: UrlData, onCompletionHandler: onCompletion)
}

protocol ServiceDeleteProtocol {
    func delete(favoriteUUID: String, onCompletionHandler: onCompletion)
}

class Service: ServiceGetDataProtocol, ServiceSaveProtocol, ServiceDeleteProtocol {
    
    private let entity = "Favorites"
    
    static var shared: Service = {
        let instance = Service()
        return instance
    }()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getData() -> [UrlData] {
        var listFavorites: [UrlData] = []
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            
            guard let favorites = try getContext().fetch(fetchRequest) as? [NSManagedObject] else { return listFavorites }
            
            
            for item in favorites {
                if let id = item.value(forKey: "id") as? UUID,
                   let title = item.value(forKey: "title") as? String,
                   let url = item.value(forKey: "url") as? String{
                    
                    let favorite = UrlData(id: id, title: title, url: url)
                    
                    listFavorites.append(favorite)
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return listFavorites
    }
    
    func save(favorite: UrlData, onCompletionHandler: (String) -> Void) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context) else { return }
        
        let transaction = NSManagedObject(entity: entity, insertInto: context)
        
        transaction.setValue(favorite.id, forKey: "id")
        transaction.setValue(favorite.title, forKey: "title")
        transaction.setValue(favorite.url, forKey: "url")
        
        do {
            try context.save()
            
            onCompletionHandler("Success")
        } catch let error as NSError {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    func update(favorite: UrlData, onCompletionHandler: (String) -> Void) {
        //TODO
    }
    
    func delete(favoriteUUID: String, onCompletionHandler: (String) -> Void) {
        let context = getContext()
        
        let predicate = NSPredicate(format: "id == %@", "\(favoriteUUID)")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityDelete = fetchResults.first {
                context.delete(entityDelete)
            }
            
            try context.save()
            
            onCompletionHandler("Successful delete")
        } catch let error as NSError {
            print("Delete error: \(error)")
        }
    }
}
