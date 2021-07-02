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
        List {
            ForEach(model.items.indices, id: \.self) { idx in
                ConcreteRecordView(item: model.items[idx])
            }.onDelete { idx in
                for id in idx {
                    let removed = model.items.remove(at: id)
                    // need to delete in the dataCore here also
                    DataCore.removeConcObjectsFromDatabase(object: removed)
                }
                
            }
        }.onAppear {
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
