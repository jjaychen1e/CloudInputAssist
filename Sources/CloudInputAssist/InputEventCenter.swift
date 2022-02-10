//
//  InputEventCenter.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/8.
//

import Foundation
import AppKit

func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let center = Unmanaged<InputEventCenter>.fromOpaque(refcon!).takeUnretainedValue();
    
    if type == .keyDown, let key = Key(code: event.getIntegerValueField(.keyboardEventKeycode)) {
        if event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
            if let nsEvent = NSEvent(cgEvent: event) {
                var modifierKeys: [Key] = []
                if nsEvent.modifierFlags.contains(.command) {
                    modifierKeys.append(.command)
                }
                if nsEvent.modifierFlags.contains(.option) {
                    modifierKeys.append(.option)
                }
                if nsEvent.modifierFlags.contains(.control) {
                    modifierKeys.append(.control)
                }
                if nsEvent.modifierFlags.contains(.shift) {
                    modifierKeys.append(.shift)
                }
                if nsEvent.modifierFlags.contains(.function) {
                    modifierKeys.append(.fn)
                }
                center.keyPressed?(key, modifierKeys)
            } else {
                center.keyPressed?(key, [])
            }
        } else {
            center.keyRepeated?(key)
        }
    } else if type == .keyUp, let key = Key(code: event.getIntegerValueField(.keyboardEventKeycode)) {
        center.keyReleased?(key)
    }
    
    return Unmanaged.passRetained(event)
}

public typealias KeyEventHandler = (Key) -> Void
public typealias KeyEventWithModifierHandler = (Key, [Key]) -> Void

public class InputEventCenter {
    public var keyPressed:  KeyEventWithModifierHandler?
    public var keyReleased: KeyEventHandler?
    public var keyRepeated: KeyEventHandler?
    
    public var couldNotRead: ((_ reason: String) -> Void)?
    
    let queue = DispatchQueue(label: "Input device event loop")
    
    public init(    ) throws {
        queue.async {
            let center = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque());
            let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
            guard let eventTap = CGEvent.tapCreate(tap: .cghidEventTap,
                                                   place: .headInsertEventTap,
                                                   options: .defaultTap,
                                                   eventsOfInterest: CGEventMask(eventMask),
                                                   callback: eventCallback,
                                                   userInfo: center) else {
                print("failed to create event tap")
                exit(1)
            }
            
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            CFRunLoopRun()
        }
    }
}
