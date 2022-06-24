//
//  ColourStyle.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import SwiftUI

public class ColourStyle {
    
    static let shared = ColourStyle()
    var colorScheme:ColorScheme = .light
    
    private init() {}
    
   // private var currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    
    var gold                    = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)

    var systemBackground        = Color(.systemGray6)
    
    var label: Color {
        get { colorScheme == .dark ? Color.white : Color.black}
    }
    
    func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
        if userInterfaceStyle == .light {
            return .light
        }else if userInterfaceStyle == .dark {
            return .dark
        }
        return .light}
    
    
    
    var yellowBackgorudLinearGradient:LinearGradient {
        get {
            if colorScheme == .dark  {
                return LinearGradient(gradient: Gradient(colors: [.cyan, .red, .white]), startPoint: .topTrailing, endPoint: .bottom)
            } else {
                return LinearGradient(gradient: Gradient(colors: [.yellow, .red, .white]), startPoint: .topTrailing, endPoint: .bottom)
            }
        }
    }
    
    func dynamicColor(light: Color, dark: Color) -> Color {
        switch colorScheme {
        case .dark:
            return dark
        default:
            return light
        }
    }
}


