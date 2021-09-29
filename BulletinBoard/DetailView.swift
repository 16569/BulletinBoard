//
//  DetailView.swift
//  BulletinBoard
//

import SwiftUI

struct DetailView: View {
    
    @Binding var isPresent: Bool
    @State var empNo: String

    var body: some View {
        
        // TODO: 詳細画面のポップ　レイアウト
        Button(action: {
            withAnimation {
                isPresent = false
            }
        }, label: {
            Text("Close")
        })
    }
}
