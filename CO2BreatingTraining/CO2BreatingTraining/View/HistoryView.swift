//
//  HistoryView.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var dataController: DataController
    var body: some View {
        O2List(isHistoryView: true, dataController: dataController)

    }
}
