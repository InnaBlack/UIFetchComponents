//
//  Text.swift
//  WebTextShare
//
//  Created by  inna on 18/02/2021.
//

import Foundation

protocol MySequence: Sequence {

    mutating func sortAbcDESC()
    mutating func sortAbcASC()
}

struct Text {
    var words: [Word]
}

extension Text: MySequence {
    func makeIterator() -> WordsIterator {
        WordsIterator(words: words)
    }
   
    mutating func sortAbcDESC() {
        words.sort(by: { $0.letters < $1.letters })
    }

    mutating func sortAbcASC() {
        words.sort(by: { $0.letters > $1.letters })
    }
    
    mutating func get_3_letter(){
        words =  Array(Array(Set(words))
            .filter({ $0.letters.count == 3 })
                        .sorted(by: { $0.countInText > $1.countInText })
                        .prefix(10))
    }
    
    mutating func get_5_letter() {
        words =  Array(Array(Set(words))
            .filter({ $0.letters.count == 5 })
                        .sorted(by: { $0.countInText > $1.countInText })
                        .prefix(10))
    }
    
}
