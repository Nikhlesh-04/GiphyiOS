//
//  BorderButtonStyle.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

struct BorderButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .cornerRadius(50.0)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 50)
                        .stroke(.blue, lineWidth: 2))
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}
