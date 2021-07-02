//
//  csvDocument.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-05-17.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Extension for UTType to define our CSV type
extension UTType {
    
    static var exampleCSV: UTType {
        
        guard let file = UTType(filenameExtension: ".csv", conformingTo: .delimitedText) else {
            return UTType(exportedAs: "public.delimited-values-text")
        }
        
        return file
    }
}

// MARK: - Define a Document to allow for the importing and exporting of Takeoffs into CSV format
struct csvDocument: FileDocument {
    var text: String

    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.exampleCSV] }
    static var writableContentTypes: [UTType] { [.exampleCSV]}

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        let file = FileWrapper(regularFileWithContents: data)
        
        return file
    }
}



