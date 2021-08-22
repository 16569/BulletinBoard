//
//  UserData.swift
//  BulletinBoard
//
//  Created by 藤浦　道 on 2021/08/22.
//

import Foundation
import SwiftUI


enum Status: String {
    case UNKNOWN = "不明"
    case OWNSEAT = "自席"
    case HOLIDAY = "休暇"
    case MEETING = "会議中"
    case GOINGOUT = "外出中"
    case LEAVING = "退勤"
    case TELEWORK = "テレワーク"
}

let STATUS_COLORS: Dictionary<Status, Color> = [
    Status.UNKNOWN: Color.white,
    Status.OWNSEAT: Color.green,
    Status.HOLIDAY: Color.orange,
    Status.MEETING: Color.blue,
    Status.GOINGOUT: Color.pink,
    Status.LEAVING: Color.gray,
    Status.TELEWORK: Color.purple
]

struct UserData: Identifiable {
    let id = UUID()
    let name: String
    var status: Status
    var color: Color = Color.white
    init(name: String, status: Status){
        self.name = name
        self.status = status
        self.color = STATUS_COLORS[self.status] ?? Color.white
    }
}

class UsersData: ObservableObject {
    @Published var userList: [UserData] = []
    
    // テストデータ作成用
    init(){
        self.userList.append(UserData(name: "ユーザー１", status: Status.GOINGOUT))
        self.userList.append(UserData(name: "ユーザー２", status: Status.HOLIDAY))
        self.userList.append(UserData(name: "ユーザー３", status: Status.LEAVING))
        self.userList.append(UserData(name: "ユーザー４", status: Status.MEETING))
        self.userList.append(UserData(name: "ユーザー５", status: Status.OWNSEAT))
    }
    
    func getUsersData() {

    }
}
