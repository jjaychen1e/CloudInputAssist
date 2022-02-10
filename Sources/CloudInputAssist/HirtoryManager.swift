//
//  HistoryManager.swift
//  
//
//  Created by 陈俊杰 on 2022/2/10.
//

import Foundation

class HistoryManager {
    static private let historyRecordsPath = FileManager.default.currentDirectoryPath + "/history.txt"
    
    static func record(py: String, word: String) {
        let recordString = "\(py)\t\(word)\n"
        let data = recordString.data(using: .utf8)!
        if let fileHandle = FileHandle(forWritingAtPath: historyRecordsPath) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        } else {
            try! data.write(to: URL(fileURLWithPath: historyRecordsPath), options: .atomic)
        }
    }
}
