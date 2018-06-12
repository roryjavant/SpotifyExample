//
//  ChainsModel.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation
import  CoreData

class ChainsModel {
    
    var chainOne = [Int]()
    var chainTwo = [Int]()
    var chainThree = [Int]()
    var chainFour = [Int]()
    var chains = [[Int]]()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    
}
