//
//  IntakeDayDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeDayDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @Binding var selectedDate: Date
    
    @State var isTomorrow = false
    
    var body: some View {
        HStack {
            Button(action: {
                // Set new date
                let calendar = Calendar.current
                selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                // Check if the next day is today or passed
                isTomorrow = self.isTomorrow(currentDate: selectedDate)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)

            Spacer()
            
            // Display Month Day, Year
            Text(dateFormatter().string(from: selectedDate))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                // Get next day
                let calendar = Calendar.current
                let nextDay = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                
                // If this day is/has occured...
                if !isTomorrow {
                    // Update currentDate
                    selectedDate = nextDay
                    // Check if this new day has occured
                    isTomorrow = self.isTomorrow(currentDate: selectedDate)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(isTomorrow ? .gray : (model.grayscaleEnabled ? .primary : .red))
            })
            .disabled(isTomorrow)
            .accessibilityHidden(true)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
        .onAppear {
            self.isTomorrow = self.isTomorrow(currentDate: selectedDate)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a day")
        .accessibilityAdjustableAction({ direction in
            switch direction {
            case .increment:
                if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
                    if !isTomorrow {
                        selectedDate = newDate
                        isTomorrow = self.isTomorrow(currentDate: selectedDate)
                    } else {
                        break
                    }
                } else {
                    break
                }
            case .decrement:
                if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
                    selectedDate = newDate
                    isTomorrow = self.isTomorrow(currentDate: selectedDate)
                } else {
                    break
                }
            @unknown default:
                break
            }
        })
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        
        if !dynamicType.isAccessibilitySize {
            formatter.timeStyle = .none
            formatter.dateStyle = .long
        } else {
            formatter.dateFormat = "MMM. d, yyyy"
        }
        
        return formatter
    }
    
    func isTomorrow(currentDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // Get the next day and tomorrow date
        let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        
        // If they are the same...
        if dateFormatter.string(from: nextDay) == dateFormatter.string(from: tomorrow) {
            return true
        // If not
        } else {
            return false
        }
    }
}