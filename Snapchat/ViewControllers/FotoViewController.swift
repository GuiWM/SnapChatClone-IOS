//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Guilherme Magnabosco on 26/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descicao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    @IBAction func proximoPasso(_ sender: Any) {
        
        self.botaoProximo.isEnabled = false // desbailitar botacao
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        let imagemFile =  imagens.child("\(self.idImagem).jpg")
        
        //Recuperar imagen
        if let imagemSelecionada = imagem.image {
            
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.1) {
                
                
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    
                if erro == nil {
                        
                    print("Sucesso ao fazer o upload do arquivo.")
                    imagemFile.downloadURL { (url, error) in
                        
                        let urlImagem = url?.absoluteString
                        self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: urlImagem)

                        
                    }
                    
                    
                    self.botaoProximo.isEnabled = true
                    self.botaoProximo.setTitle("Próximo", for: .normal)
                        
                } else {
                        
                    print("Erro ao fazer o upload do arquivo. \(erro?.localizedDescription)")
                    
                    let alerta = Alerta(titulo: "Upload falhou.", mensagem: "Erro ao salvar o arquivo. Tente novamente.")
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                }
                    
            }
            
            }
        }
        
    } // Fim metodo proximo passo
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selecionarUsuarioSegue" {
            
            let usuarioViewController = segue .destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.descicao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
            
        }
        
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
    
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        
        self.imagem.image = imagemRecuperada
        
        //habilitar botao proximo
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        // desabilita o botao proximo
        self.botaoProximo.isEnabled = false
        self.botaoProximo.backgroundColor = UIColor.gray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
