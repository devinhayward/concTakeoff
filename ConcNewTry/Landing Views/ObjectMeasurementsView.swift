//
//  ObjectMeasurementsView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-24.
//

import SwiftUI

struct ObjectMeasurementsView: View {
    
    @EnvironmentObject private var model: ConcObjectModel
    
    // State Variables For Data Input Option 1
    @State private var area: Double = 0.0
    @State private var perimiter: Double = 0.0
    
    // State Variables For Data Input Option 2
    @State private var length: Double = 0.0
    @State private var width: Double = 0.0
    @State private var height: Double = 0.0
    
    // Formatters
    let numberFormat: NumberFormatter
    
    init() {
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        numberFormat.minimumFractionDigits = 2
    }
    
    var body: some View {
        VStack {
            HStack  {
                Text("Concrete Object Measurements").font(.title)
                Spacer()
            }.padding()
            if model.currentChosenObject == ConcreteObjectType.matFooting {
                // Area and Permiter format
                Form {
                    HStack {
                        Text("Area (m2):").bold()
                        TextField("Enter Area in sq metres",
                                  value: $area,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.area = Quantity(value: area, unit: Units.m2)
                                  })
                    }
                    HStack {
                        Text("Perimiter (m):").bold()
                        TextField("Enter Perimiter in metres",
                                  value: $perimiter,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.perimeter = Quantity(value: perimiter, unit: Units.m)
                                  })
                    }
                    HStack {
                        Text("Height (m):").bold()
                        TextField("Enter Height in metres",
                                  value: $height,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.height = Quantity(value: height, unit: Units.m)
                                  })
                    }
                }
            }else {
                // Length, Width and Height format
                Form {
                    HStack {
                        Text("Length (mm):").bold()
                        TextField("Enter Length in mm",
                                  value: $length,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.length = Quantity(value: length, unit: Units.mm)
                                  })
                    }
                    HStack {
                        Text("Width (mm):").bold()
                        TextField("Enter Width in mm",
                                  value: $width,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.width = Quantity(value: width, unit: Units.mm)
                                  })
                    }
                    HStack {
                        Text("Height (mm):").bold()
                        TextField("Enter Height in mm",
                                  value: $height,
                                  formatter: numberFormat,
                                  onCommit: {
                                    model.currentMeasurements.height = Quantity(value: height, unit: Units.mm)
                                  })
                    }
                }
            }
        }
        .onDisappear() {
            area = 0.0
            perimiter = 0.0
            length = 0.0
            width = 0.0
            height = 0.0
        }
    }
}

struct ObjectMeasurementsView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectMeasurementsView()
            .environmentObject(previewModel)
    }
}
