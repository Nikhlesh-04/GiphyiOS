//
//  ListType.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import SwiftUI

enum ListType:Int, CaseIterable {
    case grid
    case list
    
    var name:String {
        switch self {
        case .grid:
            return "Grid"
        case .list:
            return "List"
        }
    }
    
    var columns: [[GridItem]] {
        switch self {
        case .grid:
            return [
                [GridItem](repeating: GridItem(.flexible(), spacing: 10), count: 3),
                [GridItem](repeating: GridItem(.flexible(), spacing: 10), count: 2),
             ]
        case .list:
            return [
                [GridItem](repeating: GridItem(.flexible(), spacing: 10), count: 1),
             ]
        }
    }
}
