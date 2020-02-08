//
//  Usuario.swift
//  Snapchat
//
//  Created by Guilherme Magnabosco on 28/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import Foundation

class Usuario {
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String) {
        self.email = email
        self.nome = nome
        self.uid = uid
    }
    
}
