//
//  CO2BreatingTrainingApp.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

@main
struct CO2BreatingTrainingApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView(dataController: dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
