//
//  WordsPublisher.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/10.
//

import Foundation

class WordsPublisher: ObservableObject {
    @Published var words: [String] = []
    @Published var validFirstWord: String? = nil
}
