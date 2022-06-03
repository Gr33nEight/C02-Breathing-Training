//
//  DataController.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import CoreData
import SwiftUI
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error: \(error)")
            }
        }
    }
    
    @Published var isFinished = false
    
    func fetchTraining(name: String, breathhold: Int, starttime: Int, increment: Int, resttime: Int, moc: NSManagedObjectContext) {
        
        let training = Training(context: moc)
        
        training.name = name
        training.breathhold = Int64(breathhold)
        training.starttime = Int64(starttime)
        training.increment = Int64(increment)
        training.resttime = Int64(resttime)
        training.isfinished = isFinished
        
        try? moc.save()
    }

    func updateTraining(name: String, breathhold: Int, starttime: Int, increment: Int, resttime: Int, moc: NSManagedObjectContext, training: Training) {
    
        moc.performAndWait {
            
            training.name = name
            training.breathhold = Int64(breathhold)
            training.starttime = Int64(starttime)
            training.increment = Int64(increment)
            training.resttime = Int64(resttime)
            training.isfinished = isFinished
            
            
            try? moc.save()
        }
        
    }
    
    func updateHistory(isFinished: Bool, training: Training, moc: NSManagedObjectContext){
        training.isfinished = isFinished
        
        try? moc.save()
    }
}
