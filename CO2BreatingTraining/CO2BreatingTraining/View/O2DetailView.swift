//
//  O2Detail.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct O2DetailView: View {
    var id = UUID()
    @ObservedObject var training: Training
    @ObservedObject var dataController: DataController
    var body: some View {
        VStack{
            O2ListItem(isDetailView: true, training: training, dataController: dataController)
                .padding()
            ScrollView(){
                LazyVStack(spacing: 30){
                    //this is creating the whole list by taking the range of 0 to number of breathholds
                    ForEach(0..<Int(training.breathhold), id:\.self){ num in
                        VStack(alignment:.leading){
                            HStack{
                                CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: Int(training.resttime))
                                Text("breath")
                            }
                            HStack{
                                CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: Int(training.starttime) + Int(training.increment)*num)
                                Text("hold")
                                Spacer()
                            }
                            Divider()
                        }.padding(.horizontal, 30)
                            .font(.system(size: 25))
                    }
                }.padding(.top, 30)
                    
                
            }
            HStack{
                //total number of seconds converts into minutes and seconds as string
                Text("Total training duration: \(CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: totalTimerCounter()))")
                Spacer()
            }.padding()
            Spacer()
            NavigationLink {
                O2ExerciseView(training: training, dataController: dataController)
            } label: {
                HStack{
                    Spacer()
                    Text("Start training")
                        .foregroundColor(.white)
                    Spacer()
                }.background(Color.blue.cornerRadius(5).frame(height: 50))
                        .padding()
            }

        }
    }
    
    
    //this function calculate how many seconds are in total in whole training
    func totalTimerCounter() -> Int {
        
        var number = Int(training.resttime * training.breathhold) + 1
        
        if training.breathhold != 0 {
            for num in 1..<Int(training.breathhold) {
                number += (Int(training.starttime) + Int(training.increment)*num)
                print(number)
            }
        }
        
        
        return number
    }
}


