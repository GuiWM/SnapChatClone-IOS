//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Guilherme Magnabosco on 29/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesSnapViewController: UIViewController {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detalhes.text = "Carregando..."
        
        let url = URL(string: snap.urlImagem)
        self.imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            
            if erro == nil {
                
                self.detalhes.text = self.snap.descricao
                
                //Inicializar timer
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                
                    //decrementar o timer
                    self.tempo = self.tempo - 1
                    
                    //exibir timer
                    self.contador.text = String(self.tempo)
                    
                    //caso o timer execute ate o 0
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            //Remove nos do Database
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            //Remove imagem do Storage
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            
            imagens.child("\(snap.idImagem).jpg").delete { (erro) in
                
                if erro == nil {
                    print("Sucesso ao excluir a imagem.")
                } else {
                    print("Erro ao excluir a imagem. \(erro?.localizedDescription)")
                }
                
            }
            
            
        }
        
    }
    

}
