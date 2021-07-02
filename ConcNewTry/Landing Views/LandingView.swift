//
//  LandingView.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-04-24.
//

import SwiftUI


struct LandingView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                ObjectDetailsView().environmentObject(previewModel)
                Spacer(minLength: 50)
                ObjectMeasurementsView()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct landingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
            .environmentObject(previewModel)
    }
}
