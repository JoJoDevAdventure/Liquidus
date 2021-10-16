//
//  OnboardingAppleHealthView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI
import HealthKit

struct OnboardingAppleHealthView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var healthKitEnabled : Bool
    
    var body: some View {
        
        VStack {
            Text("Liquidus can read and write water consumption data from Apple Health.")
                .font(.title2)
                .padding(.bottom)
            
            Text("You can always enable this later in the app's Settings.")
                .font(.title3)
                .padding(.bottom)
            
            Button(action: {
                if let healthStore = model.healthStore {
                    if model.drinkData.lastHKSave == nil {
                        healthStore.requestAuthorization { succcess in
                            if succcess {
                                healthKitEnabled = true
                                healthStore.getHealthKitData { statsCollection in
                                    if let statsCollection = statsCollection {
                                        model.retrieveFromHealthKit(statsCollection)
                                        model.saveToHealthKit()
                                    }
                                }
                            }
                        }
                    }
                }
            }, label: {
                ZStack {
                    RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                        .frame(width: 200, height: 45)
                        .shadow(radius: 5)
                    
                    Text("Sync with Apple Health")
                        .foregroundColor(Color(.systemPink))
                }
            })
                .padding(.bottom)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
}

struct OnboardingAppleHealthView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAppleHealthView(healthKitEnabled: .constant(true))
            .environmentObject(DrinkModel())
    }
}