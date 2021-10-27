//
//  DetailView.swift
//  BulletinBoard
//

import SwiftUI

/// 詳細画面
struct DetailView: View {
    
    @Binding var isPresent: Bool
    
    @State var empNo: String
    @State var name: String = ""
    @State var comment: String = ""
    
    @State var state = UserConst.ALL_STATE
    @State var stateArray : [String] = []

    var body: some View {
        ZStack {
            Rectangle()
                // 完全に透明にすると裏画面を操作できてしまう
                .opacity(0.1)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .topLeading)

            VStack(alignment: .leading , spacing:0){
                
                // 名前エリア
                VStack(alignment: .leading , spacing:0){
                    Text("名前")
                    .font(.title)
                    .padding()
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                        TextField("名前", text: $name,
                                  onEditingChanged: { isBegin in
                                    if isBegin {
                                        
                                    } else {
                                        
                                    }
                                  },
                                  onCommit: {
                                    
                                  }
                        )
                    }
                    .padding()
                    .background(Color("color12"))
                    .cornerRadius(24)
                    .font(.title2)
                    .frame(width: UIScreen.main.bounds.width / 1.3, height: 48, alignment: .leading)
                }
                
                // 行先エリア
                VStack(alignment: .leading , spacing:0){
                    Text("行先")
                    .font(.title)
                    .padding()
                    
                    Menu{
                        ForEach(stateArray, id: \.self){ index in
                            Button(action: {
                                self.state = index
                            }){
                                Text(index)
                            }
                           }
                       } label: {
                        Text("✔️ " + self.state)
                            .foregroundColor(Color("color_def"))
                       }
                    .font(.title2)
                    .frame(width: UIScreen.main.bounds.width / 1.3, height: 48, alignment: .leading)
                    .background(UserConst.DEST_COLORS[UserConst.DestState.init(rawValue: self.state) ??
                                                      UserConst.DestState.UNKNOWN] ?? Color("color_back"))
                    .border(Color("color_def"))
                }
                
                // コメントエリア
                VStack(alignment: .leading , spacing:0){
                    Text("コメント")
                    .font(.title)
                    .padding()
                    
                    TextEditor(text: $comment)
                    .padding()
                    .border(Color("color_def"))
                    .font(.title2)
                    .frame(width: UIScreen.main.bounds.width / 1.3, height: 150, alignment: .center)
                }
                
                Text("完了")
                    .frame(width: UIScreen.main.bounds.width / 1.3, height: 48, alignment: .center)
                    .frame(minWidth: 160)
                    .foregroundColor(Color("color_def"))
                    .background(Color("color11"))
                    .cornerRadius(24)
                    .onDisappear(){
                    }
                    .onTapGesture {
                        withAnimation {
                            isPresent = false
                        }
                    }
                    .padding()
            
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 60 , height: UIScreen.main.bounds.height - 80)
            .background(Color("color_back"))
            .cornerRadius(40)
        }

    }
}
