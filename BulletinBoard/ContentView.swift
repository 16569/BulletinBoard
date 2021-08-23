//
//  ContentView.swift
//  BulletinBoard
//
//  Created by 藤浦　道 on 2021/08/22.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var usersData = UsersData()
    
    var body: some View {
        ZStack{
            Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 0.9, opacity: 1.0)
              .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("行先一覧")
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(usersData.userList){ user in
                            
                            ZStack {
                                Rectangle()
                                    .cornerRadius(20)
                                    .foregroundColor(user.color)
                                    .aspectRatio(1,contentMode: .fill)
                                VStack {
                                    Text(user.name)
                                        .foregroundColor(.white)
                                    Text(user.status.rawValue)
                                        .foregroundColor(.white)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
