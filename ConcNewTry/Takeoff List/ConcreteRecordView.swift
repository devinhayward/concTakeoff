//
//  ConcreteRecordView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-23.
//

import SwiftUI

struct ConcreteRecordView: View {
    
    let item: ConcreteObject
    
    // Formatters
    private let numberFormat: NumberFormatter
    
    init(item: ConcreteObject) {
        
        self.item = item
        
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        numberFormat.maximumFractionDigits = 2
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Description: \(item.description) ")
                Text("Type: \(item.objectType.rawValue)")
            }.font(.bold(.title2)())
            HStack {
                Text("Mix Design: \(item.concreteMix.description) ")
                Text("Section: \(item.buildingSection.description)")
            }.font(.bold(.title2)())
            HStack {
                Text("Length: ") + Text(NSNumber(value: item.measurements.length.value), formatter: numberFormat) +
                    Text(item.measurements.length.unit.rawValue)
                Text("Width: ") + Text(NSNumber(value: item.measurements.width.value), formatter: numberFormat) +
                    Text(item.measurements.width.unit.rawValue)
                Text("Height: ") + Text(NSNumber(value: item.measurements.height.value), formatter: numberFormat) +
                    Text(item.measurements.height.unit.rawValue)
            }
            HStack {
                Text("Area: ") + Text(NSNumber(value: item.measurements.area.value), formatter: numberFormat) +
                    Text(item.measurements.area.unit.rawValue)
                Text("Count: ") + Text(NSNumber(value: item.count.value), formatter: numberFormat) +
                    Text(item.count.unit.rawValue)
            }
            HStack {
                Text("Formwork: ") + Text(NSNumber(value: item.formwork.value), formatter: numberFormat) +
                    Text(item.formwork.unit.rawValue)
                Text("Volume: ") + Text(NSNumber(value: item.volume.value), formatter: numberFormat) +
                    Text(item.volume.unit.rawValue)
                Text("Rebar: ") + Text(NSNumber(value: item.rebar.value), formatter: numberFormat) +
                    Text(item.rebar.unit.rawValue)
            }.font(.bold(.title3)())
        }
    }
}

struct concreteRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ConcreteRecordView(item: item1)
    }
}
