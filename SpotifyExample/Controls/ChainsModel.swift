//
//  ChainsModel.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation
import CoreData

struct ChainsStruct {
    var clipOne = ""
    var clipTwo = ""
    var clipThree = ""
    var clipFour = ""
}

class ChainsModel {
    static let sharedModel = ChainsModel()
    
    var isChainsActivated = false
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ChainOne", in: managedContext)
        
        let chainOne = NSManagedObject(entity: entity!, insertInto: managedContext)
        chainOne.setValue("1", forKey: "clipOne")
        chainOne.setValue("2", forKey: "clipTwo")
        chainOne.setValue("3", forKey: "clipThree")
        chainOne.setValue("4", forKey: "clipFour")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieve() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ChainOne", in: managedContext)!
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ChainOne")
        
        do {
            let chainOne = try managedContext.fetch(fetchRequest)
            let chain = chainOne.first as! ChainOne
            print(chain.clipOne)
            print(chain.clipTwo)
            print(chain.clipThree)
            print(chain.clipFour)            
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }               
    }
    
}
