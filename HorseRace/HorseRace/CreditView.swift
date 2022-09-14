//
//  CreditView.swift
//  HorseRace
//
//  Created by 김예훈 on 2022/09/14.
//

import SwiftUI

struct CreditView: View {
    
    @Environment(\.dismiss) var dismiss
    let member = ["Cali", "Changbro", "Chikong", "Evan", "Nia"]
    let memberKo = ["칼리", "창브로", "치콩", "에반", "니아"]
    let memberRole = ["Developer", "Developer", "Developer", "Developer", "Designer"]
    
    var body: some View {
        ZStack {
            Color(hex: "EBDCCC")
                .ignoresSafeArea()
            
            VStack(spacing: 36) {
                HStack(alignment: .top) {
                    Spacer()
                    VStack(spacing: 12) {
                        Image("MeetOurTeam")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        Text("내가사마를 만든 팀원들을 소개합니다!")
                    }
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(Color("startBtnColor"))
                    }

                }
                
                HStack(spacing: 20) {
                    ForEach(0..<5) { i in
                        VStack(alignment: .trailing, spacing: 5) {
                            VStack(alignment: .trailing, spacing: 5) {
                                Text(memberRole[i])
                                    .font(.subheadline.bold())
                                    .foregroundColor(Color(hex: "D3B498"))
                                Text(memberKo[i])
                                    .font(.system(size: 24,weight: .heavy))
                                    .foregroundColor(Color(hex: "481B15"))
                            }
                            .padding([.top, .trailing], 15)
                            Image("Horse\(member[i])")
                                .resizable()
                                .scaledToFit()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.white)
                        )
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        CreditView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
