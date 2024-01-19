//
//  UserProfile.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

struct UserProfile {
    let userId: Int
    let userName: String
    let userEmail: String?
    let userType: UserType
    
    init(data: UserResponseData) {
        self.userId = data.userId
        self.userName = data.userName
        self.userEmail = data.userEmail
        self.userType = UserType(name: "client")
    }
}


enum UserType {
    case client
    case admin
    
    init(name: String) {
        switch name {
        case "client":
            self = .client
        case "admin":
            self = .admin
        default:
            self = .client
        }
    }
}
