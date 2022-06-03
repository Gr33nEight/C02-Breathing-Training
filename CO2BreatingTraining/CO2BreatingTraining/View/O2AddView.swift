//
//  AddO2View.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct O2AddView: View {
    
    @Binding var isDetailView: Bool
    @ObservedObject var training: Training
    
    @State var name: String
    @State var startTimeSeconds: Int
    @State var incrementSeconds: Int
    @State var restSeconds: Int
    @State var numberOfBreathholds: Int
    
    @State var data: [(String, [String])] = [
        ("Minutes", Array(0...61).map { "\($0)" }),
        ("Seconds", Array(0...61).map { "\($0)" })
    ]
    @State var startTimeSelection: [String] = [00, 00].map { "\($0)" }
    @State var incrementSelection: [String] = [00, 00].map { "\($0)" }
    @State var restSelection: [String] = [00, 00].map { "\($0)" }
    
    @ObservedObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: []) var trainings: FetchedResults<Training>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var mode
    
    init(isDetailView: Binding<Bool>, training: Training, dataController: DataController){
        
        //If it's used in detail view it will show previous data, but if isn't it will show just zeros and empty space
        
        self.dataController = dataController
        self.training = training
        self._isDetailView = isDetailView
        
        if isDetailView.wrappedValue {
            _name = State(initialValue: training.name ?? "")
            _startTimeSeconds = State(initialValue: Int(training.starttime))
            _incrementSeconds = State(initialValue: Int(training.increment))
            _restSeconds = State(initialValue: Int(training.resttime))
            _numberOfBreathholds = State(initialValue: Int(training.breathhold))
        }else{
            _name = State(initialValue: "")
            _startTimeSeconds = State(initialValue: 0)
            _incrementSeconds = State(initialValue: 0)
            _restSeconds = State(initialValue: 0)
            _numberOfBreathholds = State(initialValue: 0)
        }
    }
    
    var body: some View {
        VStack{
            List{
                Section {
                    TextField("Enter a name...", text: $name)
                        .padding(.vertical)
                } header: {
                    Text("Name")
                        .font(.system(size: 18).bold())
                }
                Section {
                    HStack{
                        Picker("Set", selection: $numberOfBreathholds){
                            ForEach(0 ..< 100){ Text("\($0)")}
                        }.padding(.vertical)
                    }
                } header: {
                    Text("Breathhold")
                        .font(.system(size: 18).bold())
                }
                Section {
                    HStack{
                        NavigationLink {
                            CustomPickerView(data: $data, selection: $startTimeSelection, totalseconds: $startTimeSeconds)
                        } label: {
                            HStack{
                                Text("Set")
                                Spacer()
                                VStack{
                                    secondsToHoursMinutesSeconds(seconds: startTimeSeconds)
                                }.foregroundColor(Color(UIColor.systemGray))
                            }.padding(.vertical)
                            
                        }
                    }
                } header: {
                    Text("Apneol start time")
                        .font(.system(size: 18).bold())
                }
                Section {
                    HStack{
                        NavigationLink {
                            CustomPickerView(data: $data, selection: $incrementSelection, totalseconds: $incrementSeconds)
                        } label: {
                            HStack{
                                Text("Set")
                                Spacer()
                                VStack{
                                    secondsToHoursMinutesSeconds(seconds: incrementSeconds)
                                }.foregroundColor(Color(UIColor.systemGray))
                                
                            }.padding(.vertical)
                            
                        }
                    }
                } header: {
                    Text("Apneol increment")
                        .font(.system(size: 18).bold())
                }
                Section {
                    HStack{
                        NavigationLink {
                            CustomPickerView(data: $data, selection: $restSelection, totalseconds: $restSeconds)
                        } label: {
                            HStack{
                                Text("Set")
                                Spacer()
                                VStack{
                                    secondsToHoursMinutesSeconds(seconds: restSeconds)
                                }.foregroundColor(Color(UIColor.systemGray))
                            }.padding(.vertical)
                        }
                    }
                } header: {
                    Text("Rest time")
                        .font(.system(size: 18).bold())
                }
            }
            Button {
                // If this view is used in detail view this button will work as an update button but if isn't it will work as a save button
                if isDetailView {
                    dataController.updateTraining(name: name, breathhold: numberOfBreathholds, starttime: startTimeSeconds, increment: incrementSeconds, resttime: restSeconds, moc: moc, training: training)
                }else{
                    dataController.fetchTraining(name: name, breathhold: numberOfBreathholds, starttime: startTimeSeconds, increment: incrementSeconds, resttime: restSeconds, moc: moc)
                }
                mode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Spacer()
                    Text("Save")
                        .foregroundColor(.white)
                    Spacer()
                }.background(Color.blue.cornerRadius(5).frame(height: 50))
                    .padding()
                
            }
        }.navigationTitle(isDetailView ? "Edit" : "Add")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct CustomPickerView: View {
    
    @Binding var data: [(String, [String])]
    @Binding var selection: [String]
    
    @Environment(\.presentationMode) var mode
    
    @Binding var totalseconds: Int
    
    var body: some View {
        VStack{
            MultiPicker(data: data, selection: $selection)
            Button {
                
                //this button converts the input into number of seconds
                
                guard let minutes = selection.first, let convertedMinutes = Int(minutes) else {return}
                guard let seconds = selection.last, let convertedSeconds = Int(seconds) else {return}
                
                totalseconds = convertedMinutes*60 + convertedSeconds
                
                mode.wrappedValue.dismiss()
            } label: {
                Text("Set")
                    .font(.system(size: 22, weight: .semibold))
            }
            
        }
    }
}

struct MultiPicker: View  {
    
    typealias Label = String
    typealias Entry = String
    
    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: self.data[column].1[row])
                                .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
    }
}
