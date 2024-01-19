//
//  UserData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

struct UserResponseData: Codable {
    let userId: Int
    let userName: String
    let userEmail: String?
    let userType: String
    let success: Bool
    let errorMsg: String?
}

struct LoginResponseData: Codable {
    let code: String
    let success: Bool
    let errorMsg: String?
}
