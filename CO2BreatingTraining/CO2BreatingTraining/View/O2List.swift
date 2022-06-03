//
//  O2List.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 19/01/2022.
//

import SwiftUI

struct O2List: View {
    var isHistoryView: Bool
    @FetchRequest(sortDescriptors: []) var trainings: FetchedResults<Training>
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var dataController: DataController
    var body: some View {
        if trainings.isEmpty {
            VStack{
                Spacer()
                Text("There is no training yet")
                Spacer()
            }
        }else{
            List{
                if isHistoryView {
                    ForEach(trainings.filter({ training in
                        training.isfinished
                    }), id:\.self){ training in
                        NavigationLink {
                            O2DetailView(training: training, dataController: dataController)
                        } label: {
                            O2ListItem(isDetailView: false, training: training, dataController: dataController)
                        }
                    }.onDelete { indx in
                        deleteTraining(at: indx)
                    }
                }else{
                    ForEach(trainings, id:\.self){ training in
                        NavigationLink {
                            O2DetailView(training: training, dataController: dataController)
                        } label: {
                            O2ListItem(isDetailView: false, training: training, dataController: dataController)
                        }
                    }.onDelete { indx in
                        deleteTraining(at: indx)
                    }
                }
            }
        }
    }
    // function delete training from core data.
    func deleteTraining(at offsets: IndexSet){
        for offset in offsets {
            let training = trainings[offset]
            
            moc.delete(training)
        }
        try? moc.save()
    }
}
