//
//  Xiaohe.swift
//  
//
//  Created by 陈俊杰 on 2022/2/11.
//

import Foundation

struct Final {
    let value: String
    let validInitials: [Character]?
    
    init(_ value: String, _ validInitials: [Character]? = nil) {
        self.value = value
        self.validInitials = validInitials
    }
}

protocol ShuangPinLayout {
    var initials: [Character : String] { get }
    var finals: [Character : [Final]] { get }
    var specials: [String : String] { get }
}

struct XiaoheLayout: ShuangPinLayout {
    static let shared = XiaoheLayout()
    
    let initials: [Character : String] = [
        "b": "b",
        "c": "c",
        "d": "d",
        "f": "f",
        "g": "g",
        "h": "h",
        "i": "ch",
        "j": "j",
        "k": "k",
        "l": "l",
        "m": "m",
        "n": "n",
        "p": "p",
        "q": "q",
        "r": "r",
        "s": "s",
        "t": "t",
        "u": "sh",
        "v": "zh",
        "w": "w",
        "x": "x",
        "y": "y",
        "z": "z"
    ]
    
    let finals: [Character : [Final]] = [
        "a" : [Final("a")],
        "b" : [Final("in")],
        "c" : [Final("ao")],
        "d" : [Final("ai")],
        "e" : [Final("e")],
        "f" : [Final("en")],
        "g" : [Final("eng")],
        "h" : [Final("ang")],
        "i" : [Final("i")],
        "j" : [Final("an")],
        "k" : [Final("uai", ["u", "i", "g", "h", "k"]),
               Final("ing", ["q", "t", "y", "p", "d", "j", "l", "x", "b", "n", "m"])],
        "l" : [Final("uang", ["u", "i", "g", "h", "k", "v"]),
               Final("iang", ["q", "j", "l", "x", "n"])],
        "m" : [Final("ian")],
        "n" : [Final("iao")],
        "o" : [Final("uo", ["r", "t", "u", "i", "s", "d", "g", "h", "k", "l"]),
               Final("o", ["w", "p", "b", "m"])],
        "p" : [Final("ie")],
        "q" : [Final("iu")],
        "r" : [Final("uan")],
        "s" : [Final("ong", ["r", "t", "y", "i", "s", "d", "g", "h", "k", "l", "z", "c", "v", "n"]), Final("iong", ["q", "x"])],
        "t" : [Final("ue")],
        "u" : [Final("u")],
        "v" : [Final("ui", ["r", "t", "u", "i", "s", "d", "g", "h", "k", "z", "c", "v"]),
               Final("v", ["l"])],
        "w" : [Final("ei")],
        "x" : [Final("ua", ["u", "k", "v"]),
               Final("ia", ["q", "d", "x"])],
        "y" : [Final("un")],
        "z" : [Final("ou")],
    ]
    
    let specials: [String : String] = [
        "aa": "a",
        "ah": "ang",
        "ai": "ai",
        "an": "an",
        "ao": "ao",
        "ee": "e",
        "eg": "eng",
        "ei": "ei",
        "en": "en",
        "er": "er",
        "oo": "o",
        "ou": "ou"
    ]
}
