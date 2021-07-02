//
//  ConcNewTryApp.swift
//  ConcNewTry
//
//  Created by Devin Hayward on 2021-07-01.
//

import SwiftUI

@main
struct ConcNewTryApp: App {
    
    @StateObject private var obsAppObject = ConcObjectModel()
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environmentObject(obsAppObject)
        }
    }
}
