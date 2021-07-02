//
//  ImportDataView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-05-17.
//

import SwiftUI
import TabularData
import ImportCSV

//@available(iOS 15, *)
struct ImportDataView: View {
    
    @State private var csvDoc = csvDocument()
    @State private var buttonPresented = false
    
    var body: some View {
        Button("Import Data") {
            // simply triggers the file import which then populates the Document with the CSV Text from the file
            buttonPresented = true
        }.fileImporter(isPresented: $buttonPresented, allowedContentTypes: [.exampleCSV]) { docResult in
            
            var object = ImportCSV()
            var dataFrame: DataFrame
            
            do {
                object.url = try docResult.get()
            }catch {
                fatalError("Error importing the file")
            }
            
            dataFrame = object.dataImport()
            
            // Convert to Concrete Objects and save to the Database
            for item in ConvertToConcObject(dataFrame: dataFrame) {
                
                DataCore.newConcObjectToDatabase(object: item)
            }
        }
    }
    
    func importCSVData(_ result: Result<URL, Error>) -> String {
        
        var importDataURL: URL
        var docData: Data
        
        do {
            importDataURL = try result.get()
            docData = try Data.init(contentsOf: importDataURL)
        }catch {
            fatalError("Error inmporting the file")
        }
        
        guard let text = String(data: docData, encoding: .utf8)
        else {fatalError("Did not get the data from the file")}
        
        return text
    }
}

struct ImportDataView_Previews: PreviewProvider {
    
    static var previews: some View {
        if #available(iOS 15, *) {
            ImportDataView()
        } else {
            // Fallback on earlier versions
        }
    }
}

let testCsvDoc = csvDocument(text: """
    name,day,variable,sex
    Devin,Monday,csv,Male
    """)
