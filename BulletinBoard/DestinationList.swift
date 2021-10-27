//
//  DestinationList.swift
//  BulletinBoard
//

import SwiftUI

/// 行先一覧画面
struct DestinationList: View {

    @ObservedObject var usersData = UsersData()
    
    @State var searchWord = UserConst.ALL_STATE
    @State var searchWordArray : [String] = []
    @State var showDetail = false

    init(){
        var initWords: [String] = []
        initWords.append(UserConst.ALL_STATE)
        for destState in UserConst.DestState.allCases {
            initWords.append(destState.rawValue)
        }
        _searchWordArray = State(initialValue: initWords)
        
    }
    
    var body: some View {

        ZStack{
            Color("color_back")
              .edgesIgnoringSafeArea(.all)

            VStack{

                Text("行先一覧")
                Menu{
                    ForEach(searchWordArray, id: \.self){ index in
                        Button(action: {
                            self.searchWord = index
                            
                            // 絞り込み
                            usersData.searchUsersData(searchWord: index)
                            
                        }){
                            Text(index)
                        }
                       }
                   } label: {
                    Text(self.searchWord)
                   }

                ScrollView {

                    LazyVGrid(columns: Array(repeating: GridItem(), count: Int(UIScreen.main.bounds.width) / 160)) {
                        ForEach(usersData.showUserList){ user in

                            ZStack {
                                
                                Rectangle()
                                    .cornerRadius(20)
                                    .foregroundColor(UserConst.DEST_COLORS[user.status] ?? Color("color_back"))
                                    .aspectRatio(1,contentMode: .fill)
                                    .onTapGesture {
                                        self.showDetail = true
                                    }
                                
                                // TODO: イメージ画像をステータスごとに入れる
                                Image(systemName: "person.icloud")
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(1,contentMode: .fit)
                                    .foregroundColor(.white)
    
                                VStack {
                                    Text(user.name)
                                        .foregroundColor(Color("color_def"))
                                        .font(.title2)
                                    Text(user.status.rawValue)
                                        .foregroundColor(Color("color_def"))
                                        .font(.title2)
                                }
                                
                            }
                            .padding(.all, 5)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))

                    Spacer()
                    
                }
            }
            .modifier(BlurModifierSimple(showOverlay: $showDetail))
            if self.showDetail {
                DetailView(isPresent: $showDetail, empNo: "23908", stateArray: searchWordArray)  // NOTE: 社員番号は適当
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct DestinationList_Previews: PreviewProvider {
    static var previews: some View {
        DestinationList()
    }
}

/// 背景ぼかし用
struct BlurModifierSimple: ViewModifier {
    @Binding var showOverlay: Bool
    @State var blurRadius: CGFloat = 10
    
    func body(content: Content) -> some View {
        Group {
            content
                .blur(radius: showOverlay ? blurRadius : 0)
                .animation(.easeInOut)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
