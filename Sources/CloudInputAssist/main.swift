import Foundation
import SwiftUI
import AppKit
import Carbon

let wordsPublisher = WordsPublisher()
let fetcher = Fetcher(wordsPublisher: wordsPublisher)

// Create a keyboard observer.
if let keyboard = try? InputEventCenter() {
    
    keyboard.keyPressed = { key, modifiers in
        let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        let keyboardString = String(describing: keyboard)
        if keyboardString.contains("KB Layout: ABC") {
            fetcher.clear()
            return
        }
        
        switch key {
        case .a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z:
            fetcher.add(key.rawValue)
        case .space, .escape, ._1, ._2, ._3, ._4, ._5, ._6, ._7, ._8, ._9, ._0, .semiColon, .quote, .comma, .period, .slash:
            fetcher.clear()
        case .backspace:
            fetcher.backspace()
        case .command, .control, .option, .shift, .fn:
            break
        case .f1, .f2, .f3, .f4, .f5, .f6, .f7, .f8, .f9, .f10, .f11, .f12:
            break
        case .downArrow, .upArrow, .leftArrow, .rightArrow:
            break
        }
        
        fetcher.pressed(key, modifiers)
    }
    
    keyboard.keyReleased = { key in
        fetcher.released(key)
    }
}


class App {
    
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(activated(_:)),
                                                          name: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil)
        AppUI.main()
    }
    
    @objc func activated(_ notification: NSNotification) {
        fetcher.clear()
        return
        
        if let info = notification.userInfo,
           let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
           let name = app.localizedName
        {
            print(name)
        }
    }
}

let app = App()

RunLoop.main.run()

