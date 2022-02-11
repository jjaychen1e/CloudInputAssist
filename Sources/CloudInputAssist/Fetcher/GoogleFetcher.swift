//
//  File.swift
//  
//
//  Created by 陈俊杰 on 2022/2/11.
//

import Foundation

class GoogleFetcher: OnlineFetcher {
    static func fetch(pinyin: String) async -> [String] {
        let request = URLRequest(url: URL(string: "https://inputtools.google.com/request?text=\(pinyin)&itc=zh-t-i0-pinyin&num=11")!)
        
        do {
            let response = try await URLSession.shared.data(for: request)
            if let str = String(data: response.0, encoding: .utf8){
                let sourceRange = NSRange(
                    str.startIndex..<str.endIndex,
                    in: str
                )
                let pattern = #"\[\"SUCCESS\",\[\[\".*?\"\,\[(.*?)\].*"#
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                if let result = regex.firstMatch(in: str, options: [], range: sourceRange) {
                    if result.numberOfRanges > 1 {
                        let sub = (str as NSString).substring(with: result.range(at: 1))
                        return sub.replacingOccurrences(of: "\"", with: "").split(separator: ",").map { String($0)}
                    }
                }
            } else {
                print("Failed to convert string.")
            }
        } catch _ {}
        
        return []
    }
}
