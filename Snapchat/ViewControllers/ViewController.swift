//
//  ViewController.swift
//  Snapchat
//
//  Created by Guilherme Magnabosco on 25/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let autenticacao = Auth.auth()
        
        /*do {
            try autenticacao.signOut()
        } catch  {
            print("erro")
        }
         */
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            if let usuarioLogado = usuario {
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

}

