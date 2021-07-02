//
//  ObjectDetailsView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-24.
//

import SwiftUI

struct ObjectDetailsView: View {
    
    @EnvironmentObject private var model: ConcObjectModel
    
    // State Variables For OBJECT DETAILS
    @State private var sectionDescription = ""
    @State private var sectionNumber: Int = 0
    @State private var objectName = ""
    @State private var concreteMix = ""
    @State private var concreteCost: Double = 0.0
    
    // State Variables For BUTTONS
    @State private var isActive = false
    
    // Formatters
    private let numberFormat: NumberFormatter
    private let currencyFormat: NumberFormatter
    
    init() {
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        self.currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .currency
    }
    
    var body: some View {
        // MARK: - CONCRETE OBJECT DETAILS
        VStack {
            HStack  {
                Text("Concrete Object Details").font(.title)
                Spacer()
            }.padding()
            Form {
                HStack {
                    Picker("Select Concrete Object", selection: $model.currentChosenObject) {
                        ForEach(ConcreteObjectType.allCases) { object in
                            Text(object.rawValue).tag(object)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
                HStack {
                    Text("Concrete Object Selection:").bold()
                    Text(model.currentChosenObject.rawValue)
                }
                // Concrete Object Name, Section Name and Section Number
                HStack {
                    Text("Object Name:").bold()
                    TextField("Enter the name of the Object",
                              text: $objectName,
                              onCommit: {
                                model.concreteAllocation.name = objectName
                              })
                    Text("Project Section:").bold()
                    TextField("Enter the Section Description",
                              text: $sectionDescription,
                              onCommit: {
                                model.concreteAllocation.description = sectionDescription
                              })
                    Text("Section Number:").bold()
                    TextField("Enter the Section Number",
                              value: $sectionNumber,
                              formatter: numberFormat,
                              onCommit: {
                                model.concreteAllocation.section = sectionNumber
                              })
                }
                // Concrete Mix and Cost
                HStack {
                    Text("Concrete Mix:").bold()
                    TextField("Enter the Concrete Mix Type",
                              text: $concreteMix,
                              onCommit: {
                                model.concreteMix.description = concreteMix
                              })
                    Text("Concrete Cost:").bold()
                    TextField("Enter the Unit Cost of the Mix",
                              value: $concreteCost,
                              formatter: currencyFormat,
                              onCommit: {
                                model.concreteMix.cost = concreteCost
                              })
                }
            }.onDisappear() {
                clearExistingText()
            }
        }
        
        // MARK: - BUTTON VIEW
        VStack {
            HStack {
                Button("Add Object To Takeoff") {
                    makeNewObject()
                }.padding(.trailing, 50)
                ImportDataView()
                    .padding(.trailing, 50)
                NavigationLink(destination: TakeoffListView(),
                               isActive: $isActive) {
                    Text("Go To Takeoff List")
                }
            }
        }.padding()
    }
    
    func makeNewObject() {
        let name = model.concreteAllocation.name
        let object = model.currentChosenObject
        let length = model.currentMeasurements.length
        let width = model.currentMeasurements.width
        let height = model.currentMeasurements.height
        let density = Quantity(value: 120, unit: Units.kgM3)
        let mix = ConcreteMixDesign(description: "25Mpa", cost: 125)
        let section = model.concreteAllocation
        let area = model.currentMeasurements.area
        let perimiter = model.currentMeasurements.perimeter


        let newItem = ConcreteObject(description: name,
                                  objectType: object,
                                  concreteMix: mix,
                                  buildingSection: section,
                                  rebarDensity: density,
                                  area: area,
                                  length: length,
                                  width: width,
                                  height: height,
                                  perimeter: perimiter)
        
        model.items.append(newItem)
        DataCore.newConcObjectToDatabase(object: newItem)
    }
    
    func clearExistingText() {
        sectionNumber = 0
        sectionDescription = ""
        objectName = ""
        concreteMix = ""
        concreteCost = 0.0
        // reset the measurements
        model.currentMeasurements.width.value = 0.0
        model.currentMeasurements.height.value = 0.0
        model.currentMeasurements.length.value = 0.0
    }
    
}

struct ObjectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetailsView()
            .environmentObject(previewModel)
    }
}
