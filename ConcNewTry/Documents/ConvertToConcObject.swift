//
//  ConvertToConcObject.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-06-17.
//

import Foundation
import TabularData

// MARK: - Take the imported dataTable and convert it into and Array of ConcreteObjects
@available(iOS 15, *)
func ConvertToConcObject(dataFrame: DataFrame) -> [ConcreteObject] {
    
    var convertedDataFrame = dataFrame
    
    var outputConcObjects: [ConcreteObject] = []
    
    // capture Column 2 as a typed column
    let convertCol2 = dataFrame["objectType", String.self]
    
    // covert Column 2 to ConcreteObjectType
    let convertArray = convertCol2.map({ item -> ConcreteObjectType in
        switch item {
        case "spreadFooting":
            return ConcreteObjectType.spreadFooting
        case "stripFooting":
            return ConcreteObjectType.stripFooting
        case "shearWall":
            return ConcreteObjectType.shearWall
        case "foundationWall":
            return ConcreteObjectType.foundationWall
        case "beam":
            return ConcreteObjectType.beam
        case "column":
            return ConcreteObjectType.column
        case "gradeBeam":
            return ConcreteObjectType.gradeBeam
        case "pier":
            return ConcreteObjectType.pier
        default:
            return ConcreteObjectType.matFooting
        }
    })
    
    // replace the old column with the converted column in the dataframe
    convertedDataFrame.replaceColumn("objectType", with: Column(name: "objectType", contents: convertArray))
    
    // convert the data for the Concrete Allocation/Section
    // capture Name, Description and Section columns as a typed columns
    let nameCol = dataFrame["nameOfSection", String.self]
    let descriptCol = dataFrame["descriptionOfSection", String.self]
    let sectionCol = dataFrame["buildingSection", Int.self]
    
    // create a new column of Concrete Allocation type
    var concAllocationCol = Column<ConcreteAllocation>(name: "concAllocation", capacity: sectionCol.count)
    // loop through and populate the column variables
    for i in 0..<sectionCol.count {
        concAllocationCol[i]!.name = nameCol[i]!
        concAllocationCol[i]!.description = descriptCol[i]!
        concAllocationCol[i]!.section = sectionCol[i]!
    }
    
    // create a table of all the quantities
    // start with the count; easy. Capture the typed column.
    let countColInt = dataFrame["count", Double.self]
    let countCol = countColInt.map({ item -> Quantity in
        
        let temp = Quantity(value: item!, unit: Units.ea)
        return temp
    })
    // next is rebar density
    let rebarDensityString = dataFrame["rebarDensity", String.self]
    let rebarDensity = rebarDensityString.map({ item -> Quantity in
        let strengthIndex = item!.firstIndex(of: "k")
        let number = item![..<strengthIndex!]
        let double = Double(number)
        let unitString = item![strengthIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })
    // create a new column
    let rebarDensityColumn = Column(name: "rebarDensity", contents: rebarDensity)
    
    // next is area
    let areaString = dataFrame["area", String.self]
    let area = areaString.map({ item -> Quantity in
        let unitIndex = item!.firstIndex(of: "m")
        let number = item![..<unitIndex!]
        let double = Double(number)
        let unitString = item![unitIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })
    
    // next is length
    let lengthString = dataFrame["length", String.self]
    let length = lengthString.map({ item -> Quantity in
        let unitIndex = item!.firstIndex(of: "m")
        let number = item![..<unitIndex!]
        let double = Double(number)
        let unitString = item![unitIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })
    
    // next is width
    let widthString = dataFrame["width", String.self]
    let width = widthString.map({ item -> Quantity in
        let unitIndex = item!.firstIndex(of: "m")
        let number = item![..<unitIndex!]
        let double = Double(number)
        let unitString = item![unitIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })
    
    // next is height
    let heightString = dataFrame["height", String.self]
    let height = heightString.map({ item -> Quantity in
        let unitIndex = item!.firstIndex(of: "m")
        let number = item![..<unitIndex!]
        let double = Double(number)
        let unitString = item![unitIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })

    // last is perimiter
    let perimString = dataFrame["perimiter", String.self]
    let perimiter = perimString.map({ item -> Quantity in
        let unitIndex = item!.firstIndex(of: "m")
        let number = item![..<unitIndex!]
        let double = Double(number)
        let unitString = item![unitIndex!...]
        
        // need to convert to Units type
        let unit = Units(rawValue: String(unitString))
        
        return Quantity(value: double!, unit: unit!)
    })
    
    
    // loop through the rows and convert to a Concrete Object
    for idx in 0..<convertedDataFrame.rows.count {
        let cObj = ConcreteObject(
            description: convertedDataFrame["description", String.self][idx] ?? "error",
            objectType: convertedDataFrame["objectType", ConcreteObjectType.self][idx]!,
            concreteMix: ConcreteMixDesign(
                description: convertedDataFrame["concreteMix", String.self][idx] ?? "error",
                cost: convertedDataFrame["concCost", Double.self][idx]!),
            buildingSection: concAllocationCol[idx]!,
            rebarDensity: rebarDensityColumn[idx]!,
                                  count: countCol[idx],
                                  area: area[idx],
                                  length: length[idx],
                                  width: width[idx],
                                  height: height[idx],
                                  perimeter: perimiter[idx])
        
        outputConcObjects.append(cObj)
    }
    
    return outputConcObjects
}
