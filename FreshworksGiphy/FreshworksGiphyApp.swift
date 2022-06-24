//
//  FreshworksGiphyApp.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

@main
struct FreshworksGiphyApp: App {
    
    let state = AppState()
    let dispatchView = DispatchView()
    
    var body: some Scene {
        WindowGroup {
            dispatchView.environmentObject(state)
        }
    }
}
