//
//  IntakeSingleDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/10/21.
//

import SwiftUI

struct IntakeSingleDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var color: Color
    var drinkType: DrinkType
    var selectedTimePeriod: Constants.TimePeriod
    var selectedDay: Date
    var selectedWeek: [Date]
        
    @ScaledMetric(relativeTo: .body) var symbolSize = 35
    
    var body: some View {
        
        HStack {
            
            // Rectangle Card
            Image("custom.drink.fill")
                .resizable()
                .scaledToFit()
                .frame(width: symbolSize, height: symbolSize)
                .foregroundColor(model.grayscaleEnabled ? .primary : color)
                .accessibilityHidden(true)
            
            HStack {
                if !dynamicType.isAccessibilitySize {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType.name)
                            .font(.title)
                            .bold()
                        
                        // Consumed Amount & Percent
                        let amount = selectedTimePeriod == .daily ? model.getTypeAmountByDay(type: drinkType, date: selectedDay) : model.getTypeAmountByWeek(type: drinkType, week: selectedWeek)
                        
                        let percent = selectedTimePeriod == .daily ? model.getTypePercentByDay(type: drinkType, date: selectedDay) : model.getTypePercentByWeek(type: drinkType, week: selectedWeek)
                        
                        HStack {
                            Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                                .font(.title2)
                                .accessibilityLabel("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getAccessibilityUnitLabel())")
                            
                            Text("\(percent*100, specifier: "%.2f")%")
                                .font(.title2)
                                .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))")
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType.name)
                            .font(.title)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        
                        // Consumed Amount & Percent
                        let amount = selectedTimePeriod == .daily ? model.getTypeAmountByDay(type: drinkType, date: selectedDay) : model.getTypeAmountByWeek(type: drinkType, week: selectedWeek)
                        
                        let percent = selectedTimePeriod == .daily ? model.getTypePercentByDay(type: drinkType, date: selectedDay) : model.getTypePercentByWeek(type: drinkType, week: selectedWeek)
                        
                       Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                            .font(dynamicType == .accessibility4 || dynamicType == .accessibility5 ? .caption2 : .title2)
                            .accessibilityLabel("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getAccessibilityUnitLabel()) of \(drinkType.name)")

                        Text("\(percent*100, specifier: "%.2f")%")
                            .font(dynamicType == .accessibility4 || dynamicType == .accessibility5 ? .caption2 : .title2)
                            .accessibilityLabel("\(percent*100, specifier: "%.2f")% \(drinkType.name)")
                    }
                }
                
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct IntakeSingleDrinkBreakup_Previews: PreviewProvider {
    static var previews: some View {
        IntakeSingleDrinkBreakup(color: Color(.systemCyan), drinkType: DrinkModel().drinkData.drinkTypes.first!, selectedTimePeriod: .daily, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environmentObject(DrinkModel())
    }
}
