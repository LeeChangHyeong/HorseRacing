//
//  GameStartView.swift
//  HorseRace
//
//  Created by Hong jeongmin on 2022/08/23.
//

import SwiftUI

struct GameStartView: View {
    @State private var numberOfParticipant: Int = 2
    var columns = [
            GridItem(.adaptive(minimum: 80))
        ]

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Logo")
                
                Spacer()
                
                Button {
                    if numberOfParticipant > 2 {
                        numberOfParticipant -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                }
                
                Text("\(numberOfParticipant)")
                    .font(.system(size: 20, weight: .semibold))
                
                Button {
                    if numberOfParticipant < 6 {
                        numberOfParticipant += 1
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding()
            Spacer()
            
            // 말 이미지 동적 늘어나기, 줄어들기
            LazyHGrid(rows: columns) {
                ForEach(0..<numberOfParticipant, id:\.self) { _ in
                    // 말 이미지로 수정하기
                    Circle()
                }
            }
            
            Text("자신의 말을 기억해 주세요!")
                .font(.system(size: 20, weight: .semibold))
            
            Button {
                // 뷰 전환
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 80, height: 33, alignment: .center)
                    .foregroundColor(Color(.systemGray6))
                    .overlay(
                        Text("시작하기")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    )
                    .padding()
            }
        }
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
