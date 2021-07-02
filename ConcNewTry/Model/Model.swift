//
//  Model.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-23.
//

import Foundation

enum Units: String, Codable {
    case ea = "each",
         lumpSum = "Lump Sum",
         m2 = "m2",
         ft2 = "ft2",
         m = "m",
         mm = "mm",
         ft = "ft",
         kgM3 = "kg/m3",
         m3 = "m3",
         tonnes = "tonnes"
}

enum ConcreteObjectType: String, CaseIterable, Identifiable, Codable {
    case spreadFooting = "Spread Footing",
         matFooting = "Mat Footing",
         stripFooting = "Strip Footing",
         gradeBeam = "Grade Beam",
         pier = "Pier",
         column = "Column",
         beam = "Beam",
         foundationWall = "Foundation Wall",
         shearWall = "Shear Wall"
    
    var id: String { self.rawValue }
}

struct Quantity: Codable {
    var value: Double
    var unit: Units
}

struct ConcreteMixDesign: Codable {
    var description: String = ""
    var cost: Double = 0.0
    //var unit: Units
}

struct ConcreteAllocation: Codable {
    var name: String = ""
    var description: String = ""
    var section: Int = 0
}

struct ObjectMeasurements: Codable {
    var area: Quantity = Quantity(value: 0, unit: Units.m2)
    var perimeter: Quantity = Quantity(value: 0, unit: Units.m2)
    var length: Quantity = Quantity(value: 0, unit: Units.mm)
    var width: Quantity = Quantity(value: 0, unit: Units.mm)
    var height: Quantity = Quantity(value: 0, unit: Units.mm)
}

struct ConcreteObject: Codable,Identifiable {
    
    var id = UUID()
    var description = ""
    var objectType = ConcreteObjectType.spreadFooting
    var concreteMix = ConcreteMixDesign(description: "25MPa", cost: 10.0)
    var buildingSection = ConcreteAllocation(name: "Garage", description: "area1", section: 1)
    var rebarDensity = Quantity(value: 220, unit: Units.kgM3)
    var count = Quantity(value: 5.0, unit: Units.ea)
    var measurements = ObjectMeasurements()
    var formwork = Quantity(value: 5.0, unit: Units.m2)
    var volume = Quantity(value: 5.0, unit: Units.m3)
    var rebar = Quantity(value: 5.0, unit: Units.tonnes)
    
    init() {
        
    }
    
    
    init(description: String, objectType: ConcreteObjectType, concreteMix: ConcreteMixDesign, buildingSection: ConcreteAllocation,
         rebarDensity: Quantity, count: Quantity = Quantity(value: 1, unit: Units.ea), area: Quantity = Quantity(value: 0, unit: Units.m2),
         length: Quantity, width: Quantity, height: Quantity, perimeter: Quantity) {
        
        // Assign the values
        self.description = description
        self.objectType = objectType
        self.concreteMix = concreteMix
        self.buildingSection = buildingSection
        self.rebarDensity = rebarDensity
        self.count = count
        self.measurements.area = area
        self.measurements.length = length
        self.measurements.width = width
        self.measurements.height = height
        self.measurements.perimeter = perimeter
        
        // Calculate the volume based on a Linear Type or an Area Type
        if area.value == 0 {
            self.volume = Quantity(value: (length.value * width.value * height.value/(1000.0 * 1000.0 * 1000.0)), unit: Units.m3)
        }else {
            self.volume = Quantity(value: (area.value * height.value), unit: Units.m3)
        }
        
        // Calculate the Formwork based on the Object Type
        if objectType == .spreadFooting {
            let perimiter = (length.value + width.value) * 2
            self.formwork = Quantity(value: perimiter * height.value/(1000.0 * 1000.0),
                                     unit: Units.m2)
            self.measurements.area = Quantity(value: length.value * width.value / (1000.0 * 1000.0),
                                              unit: Units.m2)
        }else if objectType == .matFooting {
            self.formwork = Quantity(value: perimiter.value * height.value, unit: Units.m2)
        }
        else if objectType == .foundationWall || objectType == .shearWall {
            let wallFormwork = length.value * height.value * 2
            self.formwork = Quantity(value: wallFormwork, unit: Units.m2)
        }else {
            self.formwork = Quantity(value: 0, unit: Units.m2)
        }
        
        // Calculate the Rebar
        self.rebar = Quantity(value: (self.volume.value * self.rebarDensity.value/1000.0), unit: Units.tonnes)
    }
}

// Test Data
let name = "F1"
let object = ConcreteObjectType.matFooting
let length = Quantity(value: 0, unit: Units.mm)
let width = Quantity(value: 0, unit: Units.mm)
let height = Quantity(value: 1, unit: Units.m)
let density = Quantity(value: 120, unit: Units.kgM3)
let mix = ConcreteMixDesign(description: "25Mpa", cost: 125)
let garage = ConcreteAllocation(description: "Garage", section: 1)
let area = Quantity(value: 1, unit: Units.m2)
let perimiter = Quantity(value: 1, unit: Units.m)


let item1 = ConcreteObject(description: name,
                          objectType: object,
                          concreteMix: mix,
                          buildingSection: garage,
                          rebarDensity: density,
                          area: area,
                          length: length,
                          width: width,
                          height: height,
                          perimeter: perimiter)

class ConcObjectModel: ObservableObject {
    @Published var items: [ConcreteObject] = []
    @Published var currentChosenObject = ConcreteObjectType.spreadFooting
    @Published var currentMeasurements = ObjectMeasurements()
    @Published var concreteMix = ConcreteMixDesign()
    @Published var concreteAllocation = ConcreteAllocation()
}

let previewModel = ConcObjectModel()
