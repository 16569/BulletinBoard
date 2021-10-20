//
//  UserData.swift
//  BulletinBoard
//

import Foundation
import SwiftUI
import Firebase

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
        DestState.UNKNOWN: Color("color_back"),
        DestState.OWNSEAT: Color("color6"),
        DestState.HOLIDAY: Color("color2"),
        DestState.MEETING: Color("color11"),
        DestState.GOINGOUT: Color("color5"),
        DestState.LEAVING: Color.gray,
        DestState.TELEWORK: Color("color10")
    ]

    static let ALL_STATE = "全て"
}

/// ユーザーひとりのデータ
struct UserData: Identifiable {
    let id = UUID()
    let name: String
    var status: UserConst.DestState // TODO: string
    init(name: String, status: UserConst.DestState){
        self.name = name
        self.status = status
    }
}

class UsersData: ObservableObject {
    @Published var showUserList: [UserData] = []
    var searchedUserList: [UserData] = []
    
    // テストデータ作成用
    init(){
//        self.searchedUserList.append(UserData(name: "ユーザー１", status: UserConst.DestState.GOINGOUT))
//        self.searchedUserList.append(UserData(name: "ユーザー２", status: UserConst.DestState.HOLIDAY))
//        self.searchedUserList.append(UserData(name: "ユーザー３", status: UserConst.DestState.LEAVING))
//        self.searchedUserList.append(UserData(name: "ユーザー４", status: UserConst.DestState.MEETING))
//        self.searchedUserList.append(UserData(name: "ユーザー５", status: UserConst.DestState.OWNSEAT))
//        self.searchedUserList.append(UserData(name: "ユーザー６", status: UserConst.DestState.TELEWORK))
//        self.showUserList = self.searchedUserList
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        let db = Firestore.firestore()
        let collection = db.collection("user")
        collection.getDocuments { _snapshot, _error in
            if let error = _error {
                print(error)
                return
            }

            self.searchedUserList = []

            _snapshot!.documents.forEach { doc in
                let data = doc.data()
                print(doc.documentID)
                print(data)

                self.searchedUserList.append(
                    UserData(name: data["name"] as! String,
                        status: UserConst.DestState.init(rawValue: data["destination"] as! String) ?? UserConst.DestState.UNKNOWN))
            }

            self.showUserList = self.searchedUserList
        }
    }

    func searchUsersData(searchWord: String) {
        
//                    if searchWord == UserConst.ALL_STATE {
//                        self.showUserList = self.searchedUserList
//                    } else {
//                        self.showUserList = self.searchedUserList.filter { user in
//                            return user.status.rawValue == searchWord
//                        }
//                    }
        
        let db = Firestore.firestore()
        let collection = db.collection("user")
        collection.getDocuments { _snapshot, _error in
            if let error = _error {
                print(error)
                return
            }

            self.searchedUserList = []

            _snapshot!.documents.forEach { doc in
                let data = doc.data()
                print(doc.documentID)
                print(data)

                self.searchedUserList.append(
                    UserData(name: data["name"] as! String,
                        status: UserConst.DestState.init(rawValue: data["destination"] as! String) ?? UserConst.DestState.UNKNOWN))
            }

            if searchWord == UserConst.ALL_STATE {
                self.showUserList = self.searchedUserList
            } else {
                self.showUserList = self.searchedUserList.filter { user in
                    return user.status.rawValue == searchWord
                }
            }
        }
    }
    
    func updateUserData(empNo: String) {
        
        // TODO: 更新処理
        let db = Firestore.firestore()
        let collection = db.collection("user")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            snapshot!.documents.forEach { doc in
                let data = doc.data()
                print(doc.documentID)
                print(data)
                let target = data["emp_no"] as? String
                
                if empNo == target {
                    
                }
            }
            
        }
    }
}
