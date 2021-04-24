//
//  Array+Equatable.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func remove(firstIndexOf element: Element) {
        guard self.contains(element) else { return }
        let index = self.firstIndex(of: element)!
        self.remove(at: index)
    }
    
    func index(of element: Element) -> Int? {
        var res: Int?
        for (index, _element) in self.enumerated() {
            if element == _element {
                res = index
                break
            }
        }
        return res
    }
    
}
