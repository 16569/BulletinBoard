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
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(usersData.showUserList){ user in

                            ZStack {
                                Rectangle()
                                    .cornerRadius(20)
                                    .foregroundColor(user.color)
                                    .aspectRatio(1,contentMode: .fill)
                                VStack {
                                    Text(user.name)
                                        .foregroundColor(Color("color_def"))
                                    Text(user.status.rawValue)
                                        .foregroundColor(Color("color_def"))
                                }
                            }
                            .padding(.all, 5)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))

                    Spacer()
                }
            }
        }
    }
}

struct DestinationList_Previews: PreviewProvider {
    static var previews: some View {
        DestinationList()
    }
}
