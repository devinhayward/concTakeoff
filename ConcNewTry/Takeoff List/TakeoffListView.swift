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
        
        
        
        .onAppear {
            model.items.removeAll()
            model.items = DataCore.fetchConcObjects()
        }
    }
}

struct TakeoffListView_Previews: PreviewProvider {
    static var previews: some View {
        TakeoffListView()
            .environmentObject(previewModel)
    }
}
