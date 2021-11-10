//
//  EditarContactoViewController.swift
//  Contactos
//
//  Created by mac16 on 08/11/21.
//

import UIKit
import CoreData

class EditarContactoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactos = [Contacto]()
    
    var Indice2: Int?
    var recibirNombre: String?
    var recibirTelefono: String?
    var recibirDireccion: String?
    var recibirImagen: Data?

    @IBOutlet weak var nombreContactoTF: UITextField!
    @IBOutlet weak var TelefonoContactoTF: UITextField!
    @IBOutlet weak var direccionContactoTF: UITextField!
    @IBOutlet weak var ImagenPerfil: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarCoreData()

        nombreContactoTF.text = recibirNombre
        TelefonoContactoTF.text = recibirTelefono
        direccionContactoTF.text = recibirDireccion
        
        if let img = recibirImagen {
            ImagenPerfil.image = UIImage(data: img)
        }
        
        let gesturaRecognized = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gesturaRecognized.numberOfTapsRequired = 1
        gesturaRecognized.numberOfTouchesRequired = 1
        ImagenPerfil.addGestureRecognizer(gesturaRecognized)
        ImagenPerfil.isUserInteractionEnabled = true
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        print("cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else {return}
        ImagenPerfil.image = userPickedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func agregarContacto(_ sender: UIButton) {
        print("Guardar")
        do{
            if let ind = Indice2{
                
            
            
            contactos[ind].setValue(nombreContactoTF.text, forKey: "nombre")
            contactos[ind].setValue(Int64(TelefonoContactoTF.text!), forKey: "telefono")
            contactos[ind].setValue(direccionContactoTF.text, forKey: "direccion")
            contactos[ind].setValue(ImagenPerfil.image?.pngData(), forKey: "imagen")
            }
            try self.contexto.save()
             print("Guardadadou")
        }catch{
            print("No se pudo guardar \(error.localizedDescription)")
        }
        
        nombreContactoTF.text = ""
        TelefonoContactoTF.text = ""
        direccionContactoTF.text = ""
        navigationController?.popViewController(animated: true)
        
    }
    
    func cargarCoreData(){
        let fetchRequest: NSFetchRequest <Contacto> = Contacto.fetchRequest()
        
        do{
            contactos = try contexto.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Error al cargar informacion de la bd \(error.localizedDescription)")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelarBtn(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    

}
