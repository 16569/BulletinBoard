//
//  UserData.swift
//  BulletinBoard
//

import Foundation
import SwiftUI

struct UserConst {
    enum DestState: String, CaseIterable {
        case UNKNOWN = "未指定"
        case OWNSEAT = "自席"
        case HOLIDAY = "休暇"
        case MEETING = "会議中"
        case GOINGOUT = "外出中"
        case LEAVING = "退勤"
        case TELEWORK = "テレワーク"
    }

    static let DEST_COLORS: Dictionary<DestState, Color> = [
        DestState.UNKNOWN: Color("color_def"),
        DestState.OWNSEAT: Color("color6"),
        DestState.HOLIDAY: Color("color2"),
        DestState.MEETING: Color("color11"),
        DestState.GOINGOUT: Color("color5"),
        DestState.LEAVING: Color.gray,
        DestState.TELEWORK: Color("color10")
    ]

    static let ALL_STATE = "全て"
}

struct UserData: Identifiable {
    let id = UUID()
    let name: String
    var status: UserConst.DestState
    var color: Color = Color.white
    init(name: String, status: UserConst.DestState){
        self.name = name
        self.status = status
        self.color = UserConst.DEST_COLORS[self.status] ?? Color("color_def")
    }
}

class UsersData: ObservableObject {
    @Published var showUserList: [UserData] = []
    var searchedUserList: [UserData] = []
    
    // テストデータ作成用
    init(){
        self.searchedUserList.append(UserData(name: "ユーザー１", status: UserConst.DestState.GOINGOUT))
        self.searchedUserList.append(UserData(name: "ユーザー２", status: UserConst.DestState.HOLIDAY))
        self.searchedUserList.append(UserData(name: "ユーザー３", status: UserConst.DestState.LEAVING))
        self.searchedUserList.append(UserData(name: "ユーザー４", status: UserConst.DestState.MEETING))
        self.searchedUserList.append(UserData(name: "ユーザー５", status: UserConst.DestState.OWNSEAT))
        self.searchedUserList.append(UserData(name: "ユーザー６", status: UserConst.DestState.TELEWORK))
        
        self.showUserList = self.searchedUserList
    }

    func searchUsersData(searchWord: String) {
        
        // TODO: 取得処理
        
        if searchWord == UserConst.ALL_STATE {
            self.showUserList = self.searchedUserList
        } else {
            self.showUserList = self.searchedUserList.filter { user in
                return user.status.rawValue == searchWord
            }
        }
    }
}
