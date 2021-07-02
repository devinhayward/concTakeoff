//
//  TableView.swift
//  ConcNewTry
//
//  Created by Devin Hayward on 2021-07-02.
//

import SwiftUI

struct TableView: View {
    
    @State private var cObjectTableData: [ConcreteObject] = []
    
    // Formatters
    private let numberFormat: NumberFormatter
    private let currencyFormat: NumberFormatter
    
    init(concObjects: [ConcreteObject]) {
        // Initialze and setup the Number Formatter for this view
        self.numberFormat = NumberFormatter()
        numberFormat.numberStyle = .none
        numberFormat.maximumFractionDigits = 2
        self.currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .currency
    }
    
    var body: some View {
        Table(cObjectTableData) {
            TableColumn("Rebar Density", value: \.rebarDensity.value) { object in
                Text(numberFormat.string(from: NSNumber(object.rebarDensity.value)))
            }
            TableColumn("Formwork", value: \.formwork.value) { object in
                Text(numberFormat.string(from: NSNumber(object.formwork.value)))
            }
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(concObjects: [item1])
            .previewLayout(.sizeThatFits)
    }
}
