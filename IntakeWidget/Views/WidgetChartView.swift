//
//  WidgetChartView.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 4/4/22.
//

import SwiftUI

struct WidgetChartView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var entry: SimpleEntry
    var type: DrinkType
    var maxVal: Double
    var shape: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            let day = Day(date: entry.date)
            let week = Week(date: entry.date)
            
            let dataItems = model.getDataItemsForDay(day: day, type: type)
            
            let typeAmount = entry.timePeriod == .daily ? model.getTypeAmountByDay(type: type, day: day) : model.getTypeAmountByWeek(type: type, week: week)
            
            HStack {
            
                if (differentiateWithoutColor) {
                    Image(systemName: shape)
                        .symbolVariant(.fill)
                        .font(.caption.weight(.bold))
                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                        .accessibilityHidden(true)
                        .padding(.leading, 10)
                }
                
                Text(type.name)
                    .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, differentiateWithoutColor ? -2 : 10)
                    .accessibilityHidden(true)
            }
            
            TrendsDetailChartView(
                timePeriod: .daily,
                type: type,
                dataItems: dataItems,
                amount: typeAmount,
                maxValue: maxVal,
                verticalAxisText: model.verticalAxisText(dataItems: dataItems, timePeriod: .daily),
                horizontalAxisText: model.horizontalAxisText(type: type, dates: Date.now),
                chartAccessibilityLabel: model.getChartAccessibilityLabel(type: type, dates: Date.now),
                chartSpacerWidth: model.chartSpacerMaxWidth(timePeriod: .daily, isWidget: true),
                isWidget: true,
                isYear: false,
                halfYearOffset: .constant(0),
                monthOffset: .constant(0),
                touchLocation: .constant(-1))
            
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type.name) Intake Graph")

        
    }
}
