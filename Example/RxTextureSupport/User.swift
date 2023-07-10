//
//  User.swift
//  RxTextureSupport_Example
//
//  Created by Hong Daly on 10/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Differentiator

struct User : Codable , Equatable  , IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        id
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var id : String = UUID().uuidString
    var name : String
    var email : String
}

enum UserSection {
    case friend(users : [User])
    case friendRequest(users : [User])
}

extension UserSection : AnimatableSectionModelType {
    
    var items: [User] {
        switch self {
        case .friend(let user) : return user
        case .friendRequest(let user) : return user
        }
    }
    
    init(original: UserSection, items: [User]) {
        switch original {
        case .friend(let data):
            self = .friend(users: data)
        case .friendRequest(let data):
            self = .friendRequest(users: data)
        }
    }
    
    var identity: String {
        switch self {
        case .friend(users: _) : return "Friend"
        case .friendRequest(users: _) : return "Friend Request"
        }
    }
    
    typealias Item = User
    typealias Identity = String
    
    
}


