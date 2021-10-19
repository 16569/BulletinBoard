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
    
    var body: some View {
        
        switch self.viewState {
        case .Greeting:
            GreetingView(viewState: $viewState)
        case .Setting:
            UserSettingView(viewState: $viewState)
        case .Status:
            StatusView(viewState: $viewState)
        case .Next:
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
    
    @AppStorage("first_time") var firstTime: Bool = true
    @AppStorage("emp_no") var myEmpNo: String = ""
    @AppStorage("name") var myName: String = ""
    
    @State var empNo: String = ""
    @State var name: String = ""
    
    @State var opacity: Double = 0
    
    var isDisable: Bool {
        empNo.isEmpty || name.isEmpty
    }
    
    var body: some View {
        
        VStack{
            
            Text("社員番号と名前を入力してください。この設定は後から変更出来ます。")
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
                    firstTime = false
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
            self.opacity = 0.0
        }
    }
    
}

struct StatusView : View {
    
    @Binding var viewState: ViewState
    
    @State var name: String = ""
    @State var opacity: Double = 0
    
    @State var state = UserConst.DestState.UNKNOWN.rawValue
    @State var stateArray : [String] = []

    init(viewState: Binding<ViewState>){
        var initWords: [String] = []
        for destState in UserConst.DestState.allCases {
            initWords.append(destState.rawValue)
        }
        _stateArray = State(initialValue: initWords)
        _viewState = viewState
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
            //.foregroundColor(Color("color_def"))
            .background(UserConst.DEST_COLORS[UserConst.DestState.init(rawValue: self.state) ?? UserConst.DestState.UNKNOWN] ?? Color("color_back"))
            .border(Color("color_def"))
            
            Text("行先一覧へ")
                .frame(width: UIScreen.main.bounds.width / 3, height: 48, alignment: .center)
                .frame(minWidth: 160)
                .foregroundColor(Color("color_def"))
                .background(Color("color11"))
                .cornerRadius(24)
                .onTapGesture {
                    viewState = ViewState.Next
                }
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
