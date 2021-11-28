//
//  DetailView.swift
//  BulletinBoard
//

import SwiftUI

/// 詳細画面
struct DetailView: View {
    
    @Binding var isPresent: Bool
    
    @State var user: UserData
    @State var isMine: Bool
    
    @State var empNo: String
    @State var name: String
    @State var comment: String
    
    @State var state: String
    @State var stateArray : [String] = []

    init(isPresent: Binding<Bool>, user: UserData, isMine: Bool){
        self._isPresent = isPresent
        self._user = State(initialValue: user)
        self._isMine = State(initialValue: isMine)
        
        var initWords: [String] = []
        initWords.append(UserConst.ALL_STATE)
        for destState in UserConst.DestState.allCases {
            initWords.append(destState.rawValue)
        }
        self._stateArray = State(initialValue: initWords)
        
        self._name = State(initialValue: user.name)
        self._empNo = State(initialValue: user.empNo)
        self._comment = State(initialValue: user.comment)
        self._state = State(initialValue: user.status)
    }
    
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
                    .disabled(!self.isMine)
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
                    .background(UserConst.DEST_COLORS[self.state])
                    .border(Color("color_def"))
                    .disabled(!self.isMine)
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
                    .disabled(!self.isMine)
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
                            if self.isMine {
                                let usersData = UsersData()
                                self.user.status = self.state
                                self.user.comment = self.comment
                                self.user.name = self.name
                                usersData.updateUserData(user: self.user)
                            }
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
