//
//  ResultView.swift
//  HorseRace
//
//  Created by 김예훈 on 2022/08/27.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var mode: Mode
    @Binding var resultInfo: [Int]
    typealias RankingInfo = (horseNum: Int, second: Float)
    
    init(mode: Binding<Mode>, resultInfo: Binding<[Int]>) {
        self._mode = mode
        self._resultInfo = resultInfo
        if resultInfo.count == 2 || resultInfo.count == 4 {
            self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading),
                                        count: 2)
        } else {
            self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading),
                                        count: 3)
        }
        var info: [RankingInfo] = []
        for (i, value) in resultInfo.wrappedValue.enumerated() {
            info.append(RankingInfo(horseNum: i, second: Float(value) / 60.0))
        }
        
        self.rankingInfo = info.sorted { $0.second < $1.second }
    }
    
    private let rankingInfo: [RankingInfo]
    private var rows: [GridItem]
    
    private var isTwoColumns: Bool {
        !(rankingInfo.count == 2 || rankingInfo.count == 3)
    }
    
    private func isUnderLineDisabled(_ num: Int) -> Bool {
        let num = num + 1
        if rankingInfo.count < 4 {
            return num == rankingInfo.count
        } else if rankingInfo.count == 4 {
            return num == 2 || num == 4
        } else if rankingInfo.count == 5 {
            return num == 3 || num == 5
        } else {
            return num == 3 || num == 6
        }
    }
    
    private func isDashboardDisabled(_ num: Int) -> Bool {
        let num = num + 1
        if rankingInfo.count < 4 {
            return num == 1
        } else if rankingInfo.count == 4 {
            return num == 1 || num == 3
        } else {
            return num == 1 || num == 4
        }
    }
    
    private func numString(_ num: Int) -> String {
        if num == 1 {
            return "one"
        } else if num == 2 {
            return "two"
        } else if num == 3 {
            return "three"
        } else if num == 4 {
            return "four"
        } else if num == 5 {
            return "five"
        } else if num == 6 {
            return "six"
        } else {
            return "one"
        }
    }
    
    @State private var gridWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(hex: "EBDCCC")
            
            VStack(spacing: 12) {
                Text("RANKING")
                    .font(.title2.bold())
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        ForEach(isTwoColumns ? 0..<2 : 0..<1, id: \.self) { _ in
                            HStack(spacing: 0) {
                                Text("등수")
                                    .font(.footnote.bold())
                                    .frame(maxWidth: 50)
                                
                                Text("경주마")
                                    .font(.footnote.bold())
                                    .frame(maxWidth: .infinity)
                                
                                Text("걸린시간")
                                    .font(.footnote.bold())
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: gridWidth)
                            
                        }
                    }
                    
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(rankingInfo.indices, id: \.self) { i in
                            HStack(spacing: 20) {
                                Circle()
                                    .fill(Color.white)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Text("\(i+1)")
                                            .font(.footnote.bold())
                                    )
                                
                                HStack {
                                    Image("horseRed1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("\(rankingInfo[i].horseNum+1)번마")
                                            .foregroundColor(Color(hex: "481B15"))
                                        
                                        Text("Number \(numString(rankingInfo[i].horseNum+1))")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "9E7B76"))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(getTimeLiteral(rankingInfo[i].second))
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "481B15"))
                                }
                                .frame(width: 300)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                )
                            }
                            .frame(maxWidth: gridWidth)
                        }
                    }
                    .frame(maxWidth: gridWidth)
                    .frame(maxHeight: .infinity)
                }
                
                Button {
                    withAnimation(.spring()) {
                        mode = .GameStart
                    }
                } label: {
                    Text("다시하기")
                        .font(.body.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(hex: "481B15"))
                        )
                }
                .buttonStyle(.plain)
                
            }
            .frame(maxWidth: 580)
            .background(
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(Color(hex: "EBDCCC"))
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self){ size in
                        gridWidth = size.width
                    }
                
            )
            .padding(.vertical, 38)
        }
        .ignoresSafeArea()
    }
    
    private func getTimeLiteral(_ second: Float) -> String {
        let value = second + 10
        let second = Int(value)
        let millisecond = value - Float(second)
        return String(second) + "s " + String(format: "%.2f", millisecond).dropFirst(2) + "ms"
    }
    
    private func cell(ranking: Int, num: Int, second: Int) -> some View {
        HStack {
            
        }
    }
}

//struct ResultView_Previews: PreviewProvider {
//
//    private static var info = [108, 120, 50]
//
//    static var previews: some View {
//        ResultView(resultInfo: info)
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//            .previewInterfaceOrientation(.landscapeLeft)
//
//        ResultView(resultInfo: info)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
