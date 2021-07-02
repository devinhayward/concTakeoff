//
//  TakeoffListView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-24.
//

import SwiftUI



struct TakeoffListView: View {
    
    @EnvironmentObject private var model: ConcObjectModel

    var body: some View {
        
        TableView(concObjects: model.items)
        
    }
}

struct TakeoffListView_Previews: PreviewProvider {
    static var previews: some View {
        TakeoffListView()
            .environmentObject(previewModel)
    }
}
