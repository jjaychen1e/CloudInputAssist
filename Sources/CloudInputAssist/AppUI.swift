//
//  AppUI.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/10.
//

import SwiftUI

struct AppUI: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            MainWindow()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
