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

    static let DEST_COLORS: Dictionary<String, Color> = [
        DestState.UNKNOWN.rawValue: Color("color13"),
        DestState.OWNSEAT.rawValue: Color("color6"),
        DestState.HOLIDAY.rawValue: Color("color2"),
        DestState.MEETING.rawValue: Color("color11"),
        DestState.GOINGOUT.rawValue: Color("color5"),
        DestState.LEAVING.rawValue: Color.gray,
        DestState.TELEWORK.rawValue: Color("color10")
    ]

    static let ALL_STATE = "全て"
    
    static let dumyUser = UserData(empNo: "00000", name: "ID00000", status: DestState.LEAVING.rawValue, comment: "不可視のユーザー")
}

/// ユーザーひとりのデータ
struct UserData: Identifiable {
    let id = UUID().uuidString
    var empNo: String
    var name: String
    var status: String
    var comment: String
    var entryTimestamp: Timestamp
    init(empNo: String, name: String, status: String, comment: String){
        self.empNo = empNo
        self.name = name
        self.status = status
        self.comment = comment
        self.entryTimestamp = Timestamp.init()
    }
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
          guard label != nil else { return nil }
          return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
}

class UsersData: ObservableObject {
    
    @AppStorage("emp_no") var myEmpNo: String = ""
    
    @Published var showUserList: [UserData] = []
    var searchedUserList: [UserData] = []
    
    init(){
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

    }

    func searchUsersData(searchWord: String) {
                    
        let db = Firestore.firestore()
        let collection = db.collection("user")
        collection.getDocuments { snap, error in
            if let error = error {
                fatalError("\(error)")
            }

            self.searchedUserList = []

            snap!.documents.forEach { doc in
                let data = doc.data()
                if let user = self.parthUserData(empNo: doc.documentID, data: data) {
                    // 一覧に追加
                    self.searchedUserList.append(user)
                }
                
            }

            if searchWord == UserConst.ALL_STATE {
                self.showUserList = self.searchedUserList
            } else {
                self.showUserList = self.searchedUserList.filter { user in
                    return user.status == searchWord
                }
            }
            self.showUserList = self.showUserList.sorted { user1, user2 in
                user1.empNo > user2.empNo
            }
            
            var idx: Int = 0
            var tmp: UserData?
            for u in self.showUserList {
                if u.empNo == self.myEmpNo {
                    tmp = u
                    break
                }
                idx += 1
            }
            self.showUserList.remove(at: idx)
            if let ins = tmp {
                self.showUserList.insert(ins, at: 0)
            }
        }
        
    }
    
    func getUserData(empNo: String) -> Optional<UserData> {
 
        // NOTE: なんか同期出来てないっぽい
        
        let db = Firestore.firestore()
        let collection = db.collection("user")
        var result: UserData? = nil//UserConst.dumyUser
        let ref = collection.document(empNo)
        
        let semaphore = DispatchSemaphore(value: 0)
        ref.getDocument { (snap, error) in
            if let e = error {
                //fatalError("\(e)")
                semaphore.signal()
                print("\(e)")
                
                return
            }
            guard let data = snap?.data() else {
                semaphore.signal()
                return
            }
            result = self.parthUserData(empNo: empNo, data: data)!
            semaphore.signal()
        }
        
        switch semaphore.wait(timeout: .now() + 10.0) {
        case .success:
            print("got user")
            break
        case .timedOut:
            print("time out")
            break
        }
        
        return result
        
    }
    
    func updateUserData(user: UserData) {

        let db = Firestore.firestore()
        let collection = db.collection("user")
        
        let data: [String: Any] = user.asDictionary
        collection.document(user.empNo).setData(data, merge: true)
        
    }
    
    private func parthUserData(empNo: String, data: [String : Any]) -> Optional<UserData> {
        
        if let name = data["name"] {
            var user = UserData(
                empNo: empNo,
                name: name as! String,
                status: UserConst.DestState.UNKNOWN.rawValue,
                comment: ""
            )
            if let dest = data["status"] {
                user.status = dest as! String
            }
            if let comment = data["comment"] {
                user.comment = comment as! String
            }
            
            return user
        }
        return nil
        
    }
}
