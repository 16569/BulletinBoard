//
//  ContentView.swift
//  BulletinBoard
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("first_time") var firstTime: Bool = true
    @AppStorage("emp_no") var myEnpNo: String = ""

    var body: some View {
        
        // TODO: 状態に応じて画面分岐
        if firstTime {
            FirstTimeView()
        } else {
            DestinationList()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
