//
//  File.swift
//  WebTextShare
//
//  Created by  inna on 18/02/2021.
//

import Foundation

protocol MyIteratorProtocol: IteratorProtocol {
    associatedtype Element
    mutating func next() -> Self.Element?
}


struct Word: Hashable {
    let letters: String
    let countInText: Int
}

struct WordsIterator: MyIteratorProtocol {
        
    private var words: [Word]
    
    init(words: [Word]) {
        self.words = words
    }
    
    mutating func next() -> Word? {
       return self.next()
    }
}
