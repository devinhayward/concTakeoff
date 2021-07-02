//
//  FormworkSumLineView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-26.
//

import SwiftUI

struct FormworkSumLineView: View {
    
    @State private var cObject = ConcreteObject()
    
    // Formatters
    private let numberFormat: NumberFormatter
    private let currencyFormat: NumberFormatter
    
    init(concObject: ConcreteObject) {
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        numberFormat.maximumFractionDigits = 2
        self.currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .currency
        self.cObject = ConcreteObject(description: concObject.description,
                                      objectType: concObject.objectType,
                                      concreteMix: concObject.concreteMix,
                                      buildingSection: concObject.buildingSection,
                                      rebarDensity: concObject.rebarDensity,
                                      count: concObject.count,
                                      area: concObject.measurements.area,
                                      length: concObject.measurements.length,
                                      width: concObject.measurements.width,
                                      height: concObject.measurements.height,
                                      perimeter: concObject.measurements.perimeter)
    }
    
    var body: some View {
        // One for Area Type and one for Length Type
        // Below is the Length Type
        VStack {
            HStack {
                Text("Takeoff Item: \(cObject.description)")
                Text("Takeoff Area: \(cObject.buildingSection.name)")
                Text("Takeoff Section: \(cObject.buildingSection.section)")
                HStack {
                    Text("Item1")
                    //Text("Length: ") + Text(numberFormat.string(from: NSNumber(value: cObject.measurements.length))!)
                }
                HStack {
                    Text("Item2")
                    //Text("Width: ") + Text(numberFormat.string(from: NSNumber(value: cObject.measurements.width))!)
                }
                HStack {
                    Text("Item3")
                    //Text("Height: ") + Text(numberFormat.string(from: NSNumber(value: cObject.measurements.height))!)
                }
            }
            HStack {
                HStack{
                    Text("Formwork: ") + Text(numberFormat.string(from: NSNumber(value: cObject.formwork.value))!)
                }
                HStack{
                    Text("Volume: ") + Text(numberFormat.string(from: NSNumber(value: cObject.volume.value))!)
                }
                HStack{
                    Text("Rebar: ") + Text(numberFormat.string(from: NSNumber(value: cObject.rebar.value))!)
                }
            }
        }
        // Below is the Area Type
        
    }
}

struct FormworkSumLineView_Previews: PreviewProvider {
    static var previews: some View {
        FormworkSumLineView(concObject: item1)
            .previewLayout(.sizeThatFits)
    }
}
