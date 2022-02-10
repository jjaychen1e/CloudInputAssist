//
//  GoogleInputFetcher.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/8.
//

import Foundation
import Carbon.HIToolbox
import AppKit

public class GoogleInputOnlineFetcher {
    
    private var wordsPublisher: WordsPublisher
    
    init(wordsPublisher: WordsPublisher) {
        self.wordsPublisher = wordsPublisher
    }
    
    private var fetchTask: Task<Void, Never>? = nil
    private var clearTask: Task<Void, Never>? = nil
    
    private var pressedKey: Set<Key> = []
    
    private var words: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.wordsPublisher.words = self.words
            }
        }
    }
    
    private var validFirstWord: String? = nil {
        didSet {
            DispatchQueue.main.async {
                self.wordsPublisher.validFirstWord = self.validFirstWord
            }
        }
    }
    
    private(set) var buffer = "" {
        didSet {
            clearTask?.cancel()
            clearTask = nil
            clearTask = Task {
                do {
                    try await Task.sleep(nanoseconds: 5_000_000_000) // 5 Seconds
                    
                    clear()
                } catch _ {}
            }
            
            if buffer != "" {
                fetchTask?.cancel()
                fetchTask = nil
                fetchTask = Task {
                    let request = URLRequest(url: URL(string: "https://inputtools.google.com/request?text=\(buffer)&itc=zh-t-i0-pinyin-x0-shuangpin-flypy&num=11")!)
                    
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
                                    words = sub.replacingOccurrences(of: "\"", with: "").split(separator: ",").map { String($0)}
                                    if let firstWord = words.first {
                                        if firstWord.allSatisfy({ !$0.isASCII }) {
                                            validFirstWord = firstWord
                                        } else {
                                            validFirstWord = nil
                                        }
                                    } else {
                                        validFirstWord = nil
                                    }
                                    print(words)
                                }
                            }
                        } else {
                            print("Failed to convert string.")
                        }
                    } catch _ {}
                }
            }
        }
    }
    
    public func add(_ new: String) {
        buffer.append(contentsOf: new)
    }
    
    public func backspace() {
        let _ = buffer.popLast()
    }
    
    public func clear() {
        buffer = ""
        words = []
        validFirstWord = nil
    }
    
    public func flush() {
        if buffer != "", let validFirstWord = validFirstWord {
            HistoryManager.record(py: buffer, word: validFirstWord)
        }
        
        func keyEvents(forPressAndReleaseVirtualKey virtualKey: Int) -> [CGEvent] {
            let eventSource = CGEventSource(stateID: .hidSystemState)
            return [
                CGEvent(keyboardEventSource: eventSource, virtualKey: CGKeyCode(virtualKey), keyDown: true)!,
                CGEvent(keyboardEventSource: eventSource, virtualKey: CGKeyCode(virtualKey), keyDown: false)!,
            ]
        }
        
        if let firstCandidateWord = words.first {
            print(firstCandidateWord)
            let tapLocation = CGEventTapLocation.cghidEventTap
            
            let escapeEvents = keyEvents(forPressAndReleaseVirtualKey: kVK_Escape)
            escapeEvents.forEach {
                $0.post(tap: tapLocation)
            }
            
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(firstCandidateWord, forType: .string)
            
            let pasteEvents = keyEvents(forPressAndReleaseVirtualKey: kVK_ANSI_V)
            pasteEvents.forEach {
                $0.flags = .maskCommand
                $0.post(tap: tapLocation)
            }
        }
    }
    
    public func pressed(_ key: Key, _ modifiers: [Key]) {
        pressedKey.insert(key)
        print(pressedKey)
        
        let commandCombineClearKeyShortcuts: [Key] = [
            .a,
            .v
        ]
        
        if commandCombineClearKeyShortcuts.contains(key) && modifiers == [Key.command] {
            print("Command + \(key)!")
            clear()
        }
        
        // Flush Key Shortcut
        if key == .f12 {
            print("f12!")
            flush()
        }
    }
    
    public func released(_ key: Key) {
        pressedKey.remove(key)
    }
}
