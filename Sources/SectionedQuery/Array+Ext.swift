//
//  File.swift
//  
//
//  Created by Thomas Magis-Agosta on 9/27/23.
//

import Foundation

internal extension Array where Iterator.Element: Hashable {
    
    func uniqued() -> [Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
    
}
