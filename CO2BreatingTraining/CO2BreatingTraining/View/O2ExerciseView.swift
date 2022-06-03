//
//  O2ExerciseView.swift
//  CO2BreatingTraining
//
//  Created by Natanael  on 15/01/2022.
//

import SwiftUI

struct O2ExerciseView: View {
    
    @ObservedObject var training: Training
    @ObservedObject var dataController: DataController
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    
    //this counter is counting down to start the training ps.you can delete that if you don't want this counting down.
    let startCounter = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var starterTime = 5
    
    //this timer is handling whole functionality of rounds.
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var countdownTime: Int = 0
    
    @State var breathHold = 0
    @State var trainingIsFinished = false
    @State var roundIsFinished = true
    @State var numOfDoneRound = 0
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(lineWidth: 3)
                    .fill(Color.blue)
                    .padding(40)
                VStack{
                    //this shows counting down to start the training and if it's over it starts the training.
                    if trainingIsFinished {
                        Text("You finished training.")
                            .font(.system(size: 30, weight: .semibold))
                            .frame(width: 150)
                            .multilineTextAlignment(.center)
                    }else{
                        if starterTime > 0 {
                            VStack(alignment: .center){
                                Text("The training starts in")
                                Text("\(starterTime)")
                            }.font(.system(size: 30, weight: .semibold))
                        }else{
                            CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: countdownTime)
                                .font(.system(size: 40, weight: .semibold))
                        }
                    }
                    //starterCounter handles the starter counter down.
                }.onReceive(startCounter) { time in
                    withAnimation {
                        starterTime -= 1
                    }
                }
            }
            VStack(alignment: .leading){
                List{
                    Section {
                        //this is creating the whole list by taking the range of 0 to number of breathholds
                        ForEach(0..<Int(training.breathhold)){ num in
                            HStack{
                                ZStack{
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .fill(Color.blue)
                                    Text("\(num+1)")
                                }.frame(width: 30, height: 30)
                                CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: Int(training.resttime))
                                    .padding(.horizontal)
                                CO2BreatingTraining.secondsToHoursMinutesSeconds(seconds: Int(training.starttime) + Int(training.increment)*num)
                                Spacer()
                                Image(systemName: numOfDoneRound-1 >= num ? "checkmark" : "")
                                
                                Spacer()
                            }.padding(10)
                        }
                    } header: {
                        Text("Round")
                            .font(.system(size: 18).bold())
                    }
                    
                }
            }
            // this gets the time of start time which user picked before and set that as a first countdow value
        }.onAppear(perform: {
            countdownTime = Int(training.starttime)
        })
            .navigationTitle("Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack{
                    Spacer()
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                }
            }
            .onReceive(timer) { time in
                //this if checks if first timer is over. So if the first counting down is over than the main timer starts counting down
                if starterTime < 0 {
                    //this if checks if countdownTime is bigger than 0, if it is it's decreasing the value.
                    if countdownTime > 0 {
                        countdownTime -= 1
                        //this if checks if the counting down is over, and if breathold value is still lower than the breathholds inputed by the user, and if round is finished.
                    }else if countdownTime == 0 && breathHold < training.breathhold && roundIsFinished {
                        withAnimation {
                            //if it is it changes the roundIsFinished to false to prevent from breaking the whole counter and go to the apneol round
                            roundIsFinished = false
                            //it's increasing the breathhold value to track the how many breathhold user already had.
                            breathHold += 1
                            //this is setting up the time to resttime to start counting down the rest time round.
                            countdownTime = Int(training.resttime)+1
                            countdownTime -= 1
                        }
                        // everything is the same except roundIsFinished it starts the apneol timer to count down.
                    }else if countdownTime == 0 && breathHold < training.breathhold && !roundIsFinished {
                        withAnimation {
                            //this is setting up the time to apneol time to start counting down the apneol round.
                            countdownTime = Int(training.starttime) + (Int(training.increment)*breathHold)+1
                            countdownTime -= 1
                            //and at the end if everything is done we set up roundIsFinished to true to finish the round.
                            roundIsFinished = true
                            numOfDoneRound += 1
                        }
                    }
                    else{
                        //and if every round is finished we set up trainingIsFinished to true to go back and update the history view.
                        withAnimation {
                            trainingIsFinished = true
                            dataController.updateHistory(isFinished: true, training: training, moc: moc)
                        }
                    }
                }
            }
    }
}
