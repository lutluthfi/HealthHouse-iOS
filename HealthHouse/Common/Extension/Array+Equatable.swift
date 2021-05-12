//
//  Array+Equatable.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func appendOnlyNew(_ newElement: Element) {
        guard !self.contains(newElement) else { return }
        self.append(newElement)
    }
    
    mutating func appendOnlyNew(contentsOf newElements: [Element]) {
        for newElement in newElements {
            self.appendOnlyNew(newElement)
        }
    }
    
    mutating func insert(_ newElement: Element, afterFirstIndexOf element: Element) {
        guard self.contains(element) else { return }
        let index = self.firstIndex(of: element)!
        self.insert(newElement, at: index + 1)
    }
    
    mutating func insert(_ newElement: Element, beforeFirstIndexOf element: Element) {
        guard self.contains(element) else { return }
        let index = self.firstIndex(of: element)!
        self.insert(newElement, at: index)
    }
    
    mutating func insertOnlyNew(contentsOf newElements: [Element], at index: Int) {
        let _newElements = newElements.filter({ !self.contains($0) })
        self.insert(contentsOf: _newElements, at: index)
    }
    
    mutating func remove(firstIndexOf element: Element) {
        guard self.contains(element) else { return }
        let index = self.firstIndex(of: element)!
        self.remove(at: index)
    }
    
    func index(of element: Element) -> Int? {
        var ans: Int?
        for (index, _element) in self.enumerated() {
            if element == _element {
                ans = index
                break
            }
        }
        return ans
    }
    
}
