//
//  BaiduFetcher.swift
//  
//
//  Created by 陈俊杰 on 2022/2/11.
//

import Foundation

class BaiduFetcher: OnlineFetcher {
    static func fetch(pinyin: String) async -> [String] {
        let request = URLRequest(url: URL(string: "http://olime.baidu.com/py?input=\(pinyin)&inputtype=py&bg=0&ed=20&result=hanzi&resultcoding=unicode&ch_en=0&clientinfo=web&version=2")!)
        
        do {
            let response = try await URLSession.shared.data(for: request)
            if let str = String(data: response.0, encoding: .utf8){
                let sourceRange = NSRange(
                    str.startIndex..<str.endIndex,
                    in: str
                )
                let pattern = #"\[\[\["(.*?)""#
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                if let result = regex.firstMatch(in: str, options: [], range: sourceRange) {
                    if result.numberOfRanges > 1 {
                        let sub = (str as NSString).substring(with: result.range(at: 1))
                        return [String(sub)]
                    }
                }
            } else {
                print("Failed to convert string.")
            }
        } catch _ {}
        
        return []
    }
}
