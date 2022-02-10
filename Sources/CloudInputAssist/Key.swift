//
//  Key.swift
//  SwiftConsolePlayground
//
//  Created by 陈俊杰 on 2022/2/8.
//

import Foundation
import Carbon.HIToolbox

typealias KeyCode = Int64

public enum Key: String {
    case
    f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12,
    downArrow, upArrow, leftArrow, rightArrow,
    space, escape, backspace,
    command, control, option, shift, fn,
    semiColon, quote, comma, period, slash,
    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z,
    _1, _2, _3, _4, _5, _6, _7, _8, _9, _0
    
    init?(code: KeyCode) {
        if let key = keyMap[code] {
            self = key
        } else {
            return nil
        }
    }
}

let keyMap: [KeyCode: Key] = [
    KeyCode(kVK_F1):  .f1,
    KeyCode(kVK_F2):  .f2,
    KeyCode(kVK_F3):  .f3,
    KeyCode(kVK_F4):  .f4,
    KeyCode(kVK_F5):  .f5,
    KeyCode(kVK_F6):  .f6,
    KeyCode(kVK_F7):  .f7,
    KeyCode(kVK_F8):  .f8,
    KeyCode(kVK_F9):  .f9,
    KeyCode(kVK_F10): .f10,
    KeyCode(kVK_F11): .f11,
    KeyCode(kVK_F12): .f12,
    
    KeyCode(kVK_DownArrow): .downArrow,
    KeyCode(kVK_UpArrow): .upArrow,
    KeyCode(kVK_LeftArrow): .leftArrow,
    KeyCode(kVK_RightArrow): .rightArrow,
    
    KeyCode(kVK_Space): .space,
    KeyCode(kVK_Escape): .escape,
    KeyCode(kVK_Delete): .backspace,
    
    KeyCode(kVK_Command): .command,
    KeyCode(kVK_Control): .control,
    KeyCode(kVK_Option): .option,
    KeyCode(kVK_Shift): .shift,
    KeyCode(kVK_Function): .fn,
    
    KeyCode(kVK_ANSI_Semicolon): .semiColon,
    KeyCode(kVK_ANSI_Quote): .quote,
    KeyCode(kVK_ANSI_Comma): .comma,
    KeyCode(kVK_ANSI_Period): .period,
    KeyCode(kVK_ANSI_Slash): .slash,
    
    KeyCode(kVK_ANSI_A):  .a,
    KeyCode(kVK_ANSI_B):  .b,
    KeyCode(kVK_ANSI_C):  .c,
    KeyCode(kVK_ANSI_D):  .d,
    KeyCode(kVK_ANSI_E):  .e,
    KeyCode(kVK_ANSI_F):  .f,
    KeyCode(kVK_ANSI_G):  .g,
    KeyCode(kVK_ANSI_H):  .h,
    KeyCode(kVK_ANSI_I):  .i,
    KeyCode(kVK_ANSI_J):  .j,
    KeyCode(kVK_ANSI_K):  .k,
    KeyCode(kVK_ANSI_L):  .l,
    KeyCode(kVK_ANSI_M):  .m,
    KeyCode(kVK_ANSI_N):  .n,
    KeyCode(kVK_ANSI_O):  .o,
    KeyCode(kVK_ANSI_P):  .p,
    KeyCode(kVK_ANSI_Q):  .q,
    KeyCode(kVK_ANSI_R):  .r,
    KeyCode(kVK_ANSI_S):  .s,
    KeyCode(kVK_ANSI_T):  .t,
    KeyCode(kVK_ANSI_U):  .u,
    KeyCode(kVK_ANSI_V):  .v,
    KeyCode(kVK_ANSI_W):  .w,
    KeyCode(kVK_ANSI_X):  .x,
    KeyCode(kVK_ANSI_Y):  .y,
    KeyCode(kVK_ANSI_Z):  .z,
    
    KeyCode(kVK_ANSI_1):  ._1,
    KeyCode(kVK_ANSI_2):  ._2,
    KeyCode(kVK_ANSI_3):  ._3,
    KeyCode(kVK_ANSI_4):  ._4,
    KeyCode(kVK_ANSI_5):  ._5,
    KeyCode(kVK_ANSI_6):  ._6,
    KeyCode(kVK_ANSI_7):  ._7,
    KeyCode(kVK_ANSI_8):  ._8,
    KeyCode(kVK_ANSI_9):  ._9,
    KeyCode(kVK_ANSI_0):  ._0,
]
