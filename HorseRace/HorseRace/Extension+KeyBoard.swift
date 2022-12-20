//
//  Extension+KeyBoard.swift
//  HorseRace
//
//  Created by 이창형 on 2022/12/20.
//

import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
