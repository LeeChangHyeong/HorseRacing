//
//  GameStartView.swift
//  HorseRace
//
//  Created by Hong jeongmin on 2022/08/23.
//

import SwiftUI

struct GameStartView: View {
    @Binding var mode: Mode
    @Binding var horseCount: Int
    
    var body: some View {
        ZStack {
            Image("startBgImg")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .scaledToFill().clipped()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        if horseCount > 2 {
                            horseCount -= 1
                        }
                    } label: {
                        Circle()
                            .foregroundColor(Color("startBtnColor"))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "minus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.top, 25)
                    
                    Text("\(horseCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .padding([.leading, .trailing], 10)
                        .padding(.top, 25)
                    
                    Button {
                        if horseCount < 6 {
                            horseCount += 1
                        }
                    } label: {
                        Circle()
                            .foregroundColor(Color("startBtnColor"))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.top, 25)
                }
                .padding()
                
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(1...horseCount, id:\.self) { num in
                        // 말 이미지로 수정하기
                        Image("horse\(num)").resizable()
                            .frame(maxHeight: 200, alignment: .center)
                            .scaledToFit()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Text("자신의 말을 기억해 주세요!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color("startBtnColor"))
                
                Button {
                    mode = .FirstGame
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 92, height: 37, alignment: .center)
                        .foregroundColor(Color("startBtnColor"))
                        .overlay(
                            Text("시작하기")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .heavy))
                        )
                        .padding()
                }
            }
        }
    }
}
