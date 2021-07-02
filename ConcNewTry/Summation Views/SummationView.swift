//
//  SummationView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-26.
//

import SwiftUI

struct SummationView: View {
    
    @EnvironmentObject private var model: ConcObjectModel
    @State private var selection = Summation.formwork
    
    // Formatters
    private let numberFormat: NumberFormatter
    private let currencyFormat: NumberFormatter
    
    init() {
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        numberFormat.maximumFractionDigits = 2
        self.currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .currency
    }
    
    var body: some View {
        // Set the State for the Summation Style for the View
        VStack {
            HStack {
                Picker("Select Summation Style", selection: $selection) {
                    ForEach(Summation.allCases) { object in
                        Text(object.rawValue).tag(object)
                    }
                }.pickerStyle(MenuPickerStyle())
                Spacer()
            }
            // Display the current chosen style
            HStack {
                Text("Current View Style:").bold()
                Text(selection.rawValue)
                Spacer()
            }
            // Define the Summation Views below
//            VStack{
//                // Define the Summation view for Formwork
//                if selection == Summation.formwork {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
//                        Text("Placeholder")
//                        Text("Placeholder")
//                    })
//
//                }
//            }
        }.padding()
    }
}

struct SummationView_Previews: PreviewProvider {
    static var previews: some View {
        SummationView()
            .environmentObject(previewModel)
    }
}

enum Summation: String, CaseIterable, Identifiable {
    case formwork = "Formwork Area",
         volume = "Concrete Volume",
         rebar = "Rebar Weight"
    
    var id: String { self.rawValue }
}
