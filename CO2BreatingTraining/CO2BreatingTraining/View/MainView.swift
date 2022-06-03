//
//  MainView.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct MainView: View {
    @State var isDetailView = false
    @State var pickedTab = 0
    @ObservedObject var dataController: DataController
    var body: some View {
        
        TabView(selection: $pickedTab){
            NavigationView{
                O2List(isHistoryView: false, dataController: dataController)
                    .navigationTitle("O2")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        HStack{
                            Spacer()
                            NavigationLink {
                                O2AddView(isDetailView: $isDetailView, training: Training(), dataController: dataController)
                            } label: {
                                Text("Add")
                            }
                        }
                        
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
            }
            .tag(0)
            NavigationView{
                HistoryView(dataController: dataController)
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {
                Image(systemName: "clock.arrow.circlepath")
            }
            .tag(1)
        }
    }
}

