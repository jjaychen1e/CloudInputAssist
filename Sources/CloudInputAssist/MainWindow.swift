//
//  MainWindow.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/10.
//

import SwiftUI

struct MainWindow: View {
    @ObservedObject private var wordsModel = wordsPublisher
    @State private var window: NSWindow? = nil
    
    var body: some View {
        Group {
            VStack {
                Text(wordsModel.validFirstWord ?? "Typing to predict.")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                
                Spacer()
                
                Text("Hit F6 to choose.")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .overlay {
                if (wordsModel.validFirstWord == nil) {
                    Text("")
                        .onAppear {
                            window?.orderOut(nil)
                        }
                } else {
                    Text("")
                        .onAppear {
                            window?.orderBack(nil)
                        }
                }
            }
        }
//        .padding(.bottom, 28)
        .padding(.bottom, 8)
        .padding(.horizontal, 4)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let window = NSApp.windows.first {
                    window.level = .statusBar
                    window.hasShadow = false
                    window.standardWindowButton(.closeButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                    window.setFrameOrigin(.zero)
                    window.invalidateShadow()
                    self.window = window
                }
            }
        }
        .frame(width: 140, height: 50)
        .frame(maxWidth: 140, maxHeight: 50)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
