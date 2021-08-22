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
                Text("出社率：XX%")

                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(usersData.userList){ user in
                        ZStack {
                            Rectangle().foregroundColor(user.color)
                                .aspectRatio(1,contentMode: .fill)
                                .border(Color.black)
                            VStack {
                                Text(user.name)
                                Text(user.status.rawValue)
                            }
                        }
                        .padding()
                    }
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
