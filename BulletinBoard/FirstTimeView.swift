//
//  FirstTimeView.swift
//  BulletinBoard
//

import SwiftUI

enum ViewState{
    case Greeting
    case Setting
    case Status
    case Next
}

struct FirstTimeView: View {
    
    @State var viewState: ViewState = ViewState.Greeting
    
    @State var user: UserData?
    
    var body: some View {
        
        switch self.viewState {
        case .Greeting:
            GreetingView(viewState: $viewState)
        case .Setting:
            UserSettingView(viewState: $viewState, user: $user)
        case .Status:
            StatusView(viewState: $viewState, user: $user)
        case .Next:
            // （多分ここには入らない）
            DestinationList()
        }
        
    }
    
}

struct FirstTimeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeView()
    }
}

struct GreetingView: View {
    
    @Binding var viewState: ViewState
    
    @State var opacity: Double = 0
    
    var body: some View {
        
        ZStack{
            
            Color("color_back")
            Text("行先掲示板へようこそ！")
                .font(.title)
                .foregroundColor(Color("color_def"))
                .opacity(self.opacity)
                .onAppear {
                    withAnimation(.linear(duration: 1.5)) {
                        self.opacity = 1.0
                    }
                }
                .onDisappear {
                    self.opacity = 0.0
                }
            
        }
        .onTapGesture {
            viewState = ViewState.Setting
        }
    }
}

struct UserSettingView: View {
    
    @Binding var viewState: ViewState
    
    @AppStorage("emp_no") var myEmpNo: String = ""
    @AppStorage("name") var myName: String = ""
    
    @State var empNo: String = ""
    @State var name: String = ""

    @State var opacity: Double = 0
    
    @Binding var user: UserData?
    
    var isDisable: Bool {
        empNo.isEmpty || name.isEmpty
    }
    
    var body: some View {
        
        VStack{
            
            Text("社員番号と名前を入力してください。")
                .padding()
            
            HStack {
                Image(systemName: "creditcard")
                    .foregroundColor(.secondary)
                TextField("社員番号", text: $empNo,
                          onEditingChanged: { isBegin in
                            if isBegin {
                                
                            } else {
                                
                            }
                          },
                          onCommit: {
                            
                          }
                )
                .frame(width: UIScreen.main.bounds.width / 3, height: 38, alignment: .center)
                .frame(minWidth: 160)
            }
            .padding(5)
            .background(Color("color12"))
            .cornerRadius(24)
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
                .frame(width: UIScreen.main.bounds.width / 3, height: 38, alignment: .center)
                .frame(minWidth: 160)
            }
            .padding(5)
            .background(Color("color12"))
            .cornerRadius(24)
            //.padding()
            
            Text("決定")
                .frame(width: UIScreen.main.bounds.width / 3, height: 48, alignment: .center)
                .frame(minWidth: 160)
                .foregroundColor(Color("color_def"))
                .background(Color("color11"))
                .opacity(isDisable ? 0.25 : 1)
                .cornerRadius(24)
                .onDisappear(){
                    
                }
                .onTapGesture {
                    viewState = ViewState.Status
                    
                    // DBインサート
                    let usersData = UsersData()
                    self.user = UserData(empNo: empNo, name: name, status: UserConst.DestState.UNKNOWN.rawValue, comment: "")
                    usersData.updateUserData(user: self.user!)
                    
                    // 静的ストレージ保存
                    myName = name
                    myEmpNo = empNo
                }
                .disabled(isDisable)
                .padding()
            
        }
        .opacity(self.opacity)
        .onAppear {
            withAnimation(.linear(duration: 1.5)) {
                self.opacity = 1.0
            }
        }
        .onDisappear {
            withAnimation(.linear(duration: 1.5)) {
                self.opacity = 0.0
            }
        }
    }
    
}

struct StatusView : View {
    
    @AppStorage("first_time") var firstTime: Bool = true
    @Binding var viewState: ViewState
    
    @AppStorage("emp_no") var myEmpNo: String = ""
    
    @State var opacity: Double = 0
    
    @State var state = UserConst.DestState.UNKNOWN.rawValue
    @State var stateArray : [String] = []
    @State var showAlert = false
    
    @Binding var user: UserData?

    init(viewState: Binding<ViewState>, user: Binding<UserData?>){
        var initWords: [String] = []
        for destState in UserConst.DestState.allCases {
            initWords.append(destState.rawValue)
        }
        _stateArray = State(initialValue: initWords)
        _viewState = viewState
        _user = user
    }
    
    var body: some View {
        
        VStack{
            
            Text("現在の行先を選択しましょう。")
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
                    .frame(width: UIScreen.main.bounds.width / 2, height: 48, alignment: .center)
                    .frame(minWidth: 200)
                    .foregroundColor(Color("color_def"))
               }
            .frame(width: UIScreen.main.bounds.width / 2, height: 48, alignment: .center)
            .frame(minWidth: 200)
            .background(UserConst.DEST_COLORS[self.state] ?? Color("color_back"))
            .border(Color("color_def"))
            
            Text("行先一覧へ")
                .frame(width: UIScreen.main.bounds.width / 3, height: 48, alignment: .center)
                .frame(minWidth: 160)
                .foregroundColor(Color("color_def"))
                .background(Color("color11"))
                .opacity(self.state == UserConst.DestState.UNKNOWN.rawValue ? 0.25 : 1)
                .cornerRadius(24)
                .onTapGesture {
                    // DB更新
                    do {
                        let usersData = UsersData()
                        //let user = usersData.getUserData(empNo: myEmpNo)
                       
                        self.user!.status = self.state
                        usersData.updateUserData(user: self.user!)
                        viewState = ViewState.Next
                        firstTime = false
                    } catch {
                        showAlert = true
                    }
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("例外エラー"), message: Text("予期せぬエラーです。ネットワークの設定をご確認ください。"), dismissButton: .default(Text("OK")))
                }
                .disabled(self.state == UserConst.DestState.UNKNOWN.rawValue)
                .padding()
            
        }
        .opacity(self.opacity)
        .onAppear {
            withAnimation(.linear(duration: 1.5)) {
                self.opacity = 1.0
            }
        }
        .onDisappear {
            self.opacity = 0.0
        }
    }
    
}
