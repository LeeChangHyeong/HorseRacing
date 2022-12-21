//
//  ResultView.swift
//  HorseRace
//
//  Created by 김예훈 on 2022/08/27.
//

import SwiftUI
import SpriteKit

struct ResultView: View {
    let restartButtonSound = SoundSetting(forResouce: "startButtonSound", withExtension: "wav")
    
    @Binding var mode: Mode
    @Binding var resultInfo: [Int]
    @Binding var horseNames: [String]
    
    typealias RankingInfo = (horseNum: Int, second: Float)
    @State private var capsuleWidth: CGFloat = .zero
    @State private var circleWidth: CGFloat = .zero
    
    init(mode: Binding<Mode>, resultInfo: Binding<[Int]>, horseNames: Binding<[String]>) {
        self._mode = mode
        self._resultInfo = resultInfo
        self._horseNames = horseNames
        if resultInfo.count == 2 || resultInfo.count == 4 {
            self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading),
                                        count: 2)
        } else if resultInfo.count == 3 || resultInfo.count == 5 || resultInfo.count == 6 {
            self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading),
                                        count: 3)
        } else {
            self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading),
                                        count: 4)
        }
        var info: [RankingInfo] = []
        for (i, value) in resultInfo.wrappedValue.enumerated() {
            info.append(RankingInfo(horseNum: i, second: Float(value) / 60.0))
        }
        
        self.rankingInfo = info.sorted { $0.second < $1.second }
    }
    
    private let rankingInfo: [RankingInfo]
    private var rows: [GridItem]
    
    private var columnCount: Int {
        (rankingInfo.count < 4) ? 1 : 2
    }
    
    private func isUnderLineDisabled(_ num: Int) -> Bool {
        let num = num + 1
        if rankingInfo.count < 4 {
            return num == rankingInfo.count
        } else if rankingInfo.count == 4 {
            return num == 2 || num == 4
        } else if rankingInfo.count == 5 {
            return num == 3 || num == 5
        } else if rankingInfo.count == 6 {
            return num == 3 || num == 6
        } else if rankingInfo.count == 7 {
            return num == 4 || num == 7
        } else {
            return num == 4 || num == 8
        }
    }
    
    private func isDashboardDisabled(_ num: Int) -> Bool {
        let num = num + 1
        if rankingInfo.count < 4 {
            return num == 1
        } else if rankingInfo.count == 4 {
            return num == 1 || num == 3
        } else if rankingInfo.count == 5 || rankingInfo.count == 6 {
            return num == 1 || num == 4
        } else {
            return num == 1 || num == 5
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
        } else if num == 7 {
            return "seven"
        } else {
            return "eight"
        }
    }
    
    @State private var gridWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(hex: "EBDCCC")
                .ignoresSafeArea()
            
            // spriteKit view
            SpriteView(scene: EndParticlesScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)), options: [.allowsTransparency])
            
            VStack(spacing: 12) {
                Image("Ranking")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 148)
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        ForEach(0..<columnCount, id: \.self) { _ in
                            HStack(spacing: 15) {
                                Text("등수")
                                    .foregroundColor(.black)
                                    .font(.footnote.bold())
                                    .frame(width: circleWidth)
                                
                                HStack {
                                    Text("경주마")
                                        .foregroundColor(.black)
                                        .font(.footnote.bold())
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("걸린시간")
                                        .foregroundColor(.black)
                                        .font(.footnote.bold())
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(width: capsuleWidth)
                            }
                        }
                    }
                    
                    RankingGridView(num: rankingInfo.count, rankingInfo: rankingInfo) { (ranking, num, second) in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(Color.white)
                                .frame(maxHeight: 65)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Text("\(ranking+1)")
                                        .foregroundColor(.black)
                                        .font(.title2.bold())
                                )
                                .modifier(SizeModifier())
                                .onPreferenceChange(SizePreferenceKey.self) { size in
                                    circleWidth = size.width
                                }
                            
                            HStack(spacing: 0) {
                                Image("horse\(num+1)\(rankingInfo.count < 4 ? "byOne" : "byTwo")")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    Text(horseNames[num] == "" ? "\(num + 1)번마" : "\(horseNames[num])")
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .foregroundColor(Color(hex: "481B15"))
                                    
                                    Spacer()
                                    
                                    Text(getTimeLiteral(second))
                                        .font(.subheadline)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(Color(hex: "481B15"))
                                        .padding(.trailing, 30)
                                        .frame(width: 100)
                                    
                                }
                            }
                            .frame(minWidth: 180, maxWidth: 280, maxHeight: 65)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .modifier(SizeModifier())
                                    .onPreferenceChange(SizePreferenceKey.self) { size in
                                        capsuleWidth = size.width
                                    }
                            )
                        }
                    }
                }
                
                Button {
                    withAnimation(.spring()) {
                        restartButtonSound.playSound()
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
            .padding(.horizontal, 60)
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
    
    struct RankingGridView<ItemView: View>: View {
        
        var num: Int
        var rankingInfo: [RankingInfo]
        let content: (Int, Int, Float) -> ItemView
        
        init(num: Int, rankingInfo: [RankingInfo], @ViewBuilder content: @escaping (Int, Int, Float) -> ItemView) {
            self.num = num
            self.content = content
            self.rankingInfo = rankingInfo
        }
        
        var body: some View {
            if num == 2 {
                VStack(spacing: 15) {
                    ForEach(0..<num, id: \.self) { i in
                        content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                    }
                }
            } else if num == 3 {
                VStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { i in
                        content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                    }
                }
            } else if num == 4 {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 15) {
                        ForEach(0..<2, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                    VStack(spacing: 15) {
                        ForEach(2..<4, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                }
                .padding([.bottom, .vertical], 16)
            } else if num == 5 {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(3..<5, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                        content(0, rankingInfo[0].horseNum, rankingInfo[0].second)
                            .opacity(0)
                    }
                }
            } else if num == 6 {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(3..<6, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                }
            } else if num == 7 {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(4..<7, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                        content(0, rankingInfo[0].horseNum, rankingInfo[0].second)
                            .opacity(0)
                    }
                }
            } else if num == 8 {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(4..<8, id: \.self) { i in
                            content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                        }
                    }
                }
            }
        }
    }
}

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
