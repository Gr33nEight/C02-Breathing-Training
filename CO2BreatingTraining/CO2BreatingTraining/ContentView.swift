//
//  ContentView.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataController: DataController
    var body: some View {
        MainView(dataController: dataController)
    }
}
