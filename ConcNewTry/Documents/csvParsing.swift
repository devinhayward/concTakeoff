//
//  csvParsing.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-05-20.
//

import Foundation
import TabularData

// MARK: - Parse all of the imported concrete data
func parseCSVData(csvData: String) -> [ConcreteObject] {
    
    var outputConcObjects: [ConcreteObject] = []
    
    // Begin by splitting on the line returns and remove the first line Header
    let lines = csvData.split(separator: "\n")
    let lines2 = lines.dropFirst(1)
    
    // Split the remaining items by the seperator
    for line in lines2 {
    
        let currentItems = line.split(separator: ";").map{ String($0) }
        
        // Convert all the values into the required objects
        let d = currentItems[0]
        let cObject: ConcreteObjectType = {
            
            let item = currentItems[1]
            if item == "spreadFooting" {
                return ConcreteObjectType.spreadFooting
            }else if item == "stripFooting" {
                return ConcreteObjectType.stripFooting
            }else if item == "shearWall" {
                return ConcreteObjectType.shearWall
            }else if item == "foundationWall" {
                return ConcreteObjectType.foundationWall
            }else if item == "beam" {
                return ConcreteObjectType.beam
            }else if item == "column" {
                return ConcreteObjectType.column
            }else if item == "gradeBeam" {
                return ConcreteObjectType.gradeBeam
            }else if item == "pier" {
                return ConcreteObjectType.pier
            }else {
                return ConcreteObjectType.matFooting
            }
        }()
        
        // Prep all the values from the data for the new Conc Object
        let cMix = ConcreteMixDesign(description: currentItems[2], cost: Double(currentItems[3])!)
        let bS = ConcreteAllocation(name: "Garage", description: "Garage", section: Int(currentItems[4])!)
        let rbarDensity = Quantity(value: Double(currentItems[5])!, unit: Units.kgM3)
        let count = Quantity(value: Double(currentItems[6])!, unit: Units.ea)
        let area = Quantity(value: Double(currentItems[7])!, unit: Units.m2)
        let length = Quantity(value: Double(currentItems[8])!, unit: Units.mm)
        let width = Quantity(value: Double(currentItems[9])!, unit: Units.mm)
        let height = Quantity(value: Double(currentItems[10])!, unit: Units.mm)
        let perimiter = Quantity(value: Double(currentItems[11])!, unit: Units.m)
            
        // create a new Object and populate with the line data
        let object = ConcreteObject(description: d,
                                    objectType: cObject,
                                    concreteMix: cMix,
                                    buildingSection: bS,
                                    rebarDensity: rbarDensity,
                                    count: count,
                                    area: area,
                                    length: length,
                                    width: width,
                                    height: height,
                                    perimeter: perimiter)
        
        // add the new object to the array
        outputConcObjects.append(object)
    }

    return outputConcObjects
}
