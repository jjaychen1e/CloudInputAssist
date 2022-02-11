//
//  GoogleInputFetcher.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/8.
//

import Foundation
import Carbon.HIToolbox
import AppKit

protocol OnlineFetcher {
    static func fetch(pinyin: String) async -> [String]
}

public class Fetcher {
    
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
            
            if buffer != "", buffer.count % 2 == 0 {
                fetchTask?.cancel()
                fetchTask = nil
                
                var transformedBuffer = ""
                let bufferArray = Array<Character>(buffer)
                var special = false
                for i in 0..<bufferArray.count {
                    if i % 2 == 0 {
                        if let initial = XiaoheLayout.shared.initials[bufferArray[i]] {
                            transformedBuffer.append(initial)
                        } else {
                            special = true
                        }
                    } else {
                        if special {
                            if let specialCombination = XiaoheLayout.shared.specials["\(bufferArray[i - 1])\(bufferArray[i])"] {
                                transformedBuffer.append(specialCombination)
                                special = false
                            } else {
                                // Error pinyin
                                return
                            }
                        } else {
                            if let finals = XiaoheLayout.shared.finals[bufferArray[i]] {
                                if finals.count == 1 {
                                    transformedBuffer.append(finals[0].value)
                                } else {
                                    let validFinals = finals.filter { $0.validInitials!.contains(bufferArray[i - 1])}
                                    if validFinals.count == 1 {
                                        transformedBuffer.append(validFinals[0].value)
                                    } else {
                                        // Error pinyin
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                
                let _transformedBuffer = transformedBuffer
                fetchTask = Task {
//                    words = await GoogleFetcher.fetch(pinyin: _transformedBuffer)
                    words = await BaiduFetcher.fetch(pinyin: _transformedBuffer)
                    
                    if let firstWord = words.first {
                        if firstWord.allSatisfy({ !$0.isASCII }) {
                            validFirstWord = firstWord
                        } else {
                            validFirstWord = nil
                        }
                    } else {
                        validFirstWord = nil
                    }
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
        
        func keyEvents(forPressAndReleaseVirtualKey virtualKey: Int) -> [CGEvent] {
            let eventSource = CGEventSource(stateID: .hidSystemState)
            return [
                CGEvent(keyboardEventSource: eventSource, virtualKey: CGKeyCode(virtualKey), keyDown: true)!,
                CGEvent(keyboardEventSource: eventSource, virtualKey: CGKeyCode(virtualKey), keyDown: false)!,
            ]
        }
        
        if buffer != "", let validFirstWord = validFirstWord {
            let py = buffer
            DispatchQueue.global().async {
                HistoryManager.record(py: py, word: validFirstWord)
            }
            
            if let firstCandidateWord = words.first {
                print(firstCandidateWord)
                
                let tapLocation = CGEventTapLocation.cghidEventTap
                
                let escapeEvents = keyEvents(forPressAndReleaseVirtualKey: kVK_CapsLock)
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
            
            clear()
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
