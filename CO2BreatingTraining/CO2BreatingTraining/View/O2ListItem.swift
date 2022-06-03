//
//  O2ListItem.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct O2ListItem: View {
    @State var isDetailView = false
    @ObservedObject var training: Training
    @ObservedObject var dataController: DataController
    var body: some View {
        HStack{
            //MARK: Here should be your icon.
            Image(systemName: "02.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Spacer()
            VStack(alignment: .leading){
                Text(training.name ?? "")
                    .font(.system(size: 30, weight: .semibold))
                HStack(spacing: 20){
                    VStack{
                        HStack(spacing:0){
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("\(training.breathhold)")
                        }
                        secondsToHoursMinutesSeconds(seconds: Int(training.starttime))
                    }

                    VStack{
                        secondsToHoursMinutesSeconds(seconds: Int(training.increment))
                        secondsToHoursMinutesSeconds(seconds: Int(training.resttime))
                    }
                    
                }
                
            }
            Spacer()
            if isDetailView {
                NavigationLink {
                    O2AddView(isDetailView: $isDetailView, training: training, dataController: dataController)
                } label: {
                    Text("Edit")
                }
            }

        }
    }
}
//this function converst input value - seconds, and returns the String of minutes and seconds with 0 at the beginning if necessary.
func secondsToHoursMinutesSeconds (seconds : Int) -> Text {
    let minute = ((seconds % 3600) / 60)
    let second = ((seconds % 3600) % 60)
        
    var output = ""
    
    if minute < 10 && second < 10{
        output = "0\(minute):0\(second)"
    }else if minute < 10 {
        output = "0\(minute):\(second)"
    }else if second < 10 {
        output = "\(minute):0\(second)"
    }else{
        output = "\(minute):\(second)"
    }
    
    return Text(output)
}
