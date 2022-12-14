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
    @Binding var horseNames: [String]
    
    let startButtonSound = SoundSetting(forResouce: "startButtonSound", withExtension: "wav")
    let changeButtonSound = SoundSetting(forResouce: "changeSound", withExtension: "wav")
    let negativeSound = SoundSetting(forResouce: "negativeSound", withExtension: "wav")
    
    @State private var showCreditView = false
    
    var body: some View {
        ZStack {
            Image("startBgImg")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .scaledToFill().clipped()
            
            VStack {
                HStack {
                    Button {
                        showCreditView = true
                    } label: {
                        Image("InformationMark")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .fullScreenCover(isPresented: $showCreditView) {
                        CreditView()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        if horseCount > 2 {
                            changeButtonSound.playSound()
                            horseCount -= 1
                        } else {
                            negativeSound.playSound()
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
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(Color("startBtnColor"))
                        .padding([.leading, .trailing], 10)
                        .padding(.top, 25)
                    
                    Button {
                        if horseCount < 8 {
                            changeButtonSound.playSound()
                            horseCount += 1
                        } else {
                            negativeSound.playSound()
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
                
                Text("?????? ????????? ???????????? ?????? ????????? ????????? ??? ????????????!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color("startBtnColor"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(1...horseCount, id:\.self) { num in
                        VStack {
                            Image("horse\(num)").resizable()
                                .frame(maxHeight: 200, alignment: .center)
                                .scaledToFit()
                            
                            TextField("", text: $horseNames[num - 1])
                                .placeholder(when: horseNames[num - 1].isEmpty) {
                                    Text("\(num)??????")
                                        .foregroundColor(.white)
                                }
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Text("????????? ?????? ????????? ?????????!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color("startBtnColor"))
                
                Button {
                    startButtonSound.playSound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            mode = .FirstGame
                        }
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 92, height: 37, alignment: .center)
                        .foregroundColor(Color("startBtnColor"))
                        .overlay(
                            Text("????????????")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .heavy))
                        )
                        .padding()
                }
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
