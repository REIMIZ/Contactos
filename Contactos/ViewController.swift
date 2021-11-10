//
//  ViewController.swift
//  Contactos
//
//  Created by mac16 on 08/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    var Indice : Int?
    var nombreEdit: String?
    var telEdit: String?
    var dirEdit: String?
    var imgedit: Data?

    @IBOutlet weak var tablaContactos: UITableView!
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactos = [Contacto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarInfoCoreData()
        
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "Celda")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will Appear")
        tablaContactos.reloadData()
    }


    @IBAction func agregarContactoBtn(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(
            title: "Nuevo Contacto", message: "Agregar", preferredStyle: .alert)
       
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
           
            
            guard let nombreAlert = alerta.textFields?[0].text else {return}
            guard let telefonoAlert = alerta.textFields?[1].text else {return}
            guard let direccionAlert = alerta.textFields?[2].text else {return}
            
            let imagenTemporal = UIImageView(image: #imageLiteral(resourceName: "hutao"))
            
            let nuevoContacto = Contacto(context: self.contexto)
            
            nuevoContacto.nombre = nombreAlert
            nuevoContacto.telefono = Int64(telefonoAlert) ?? 0
            nuevoContacto.direccion = direccionAlert
            nuevoContacto.imagen = imagenTemporal.image?.pngData()
            
            self.contactos.append(nuevoContacto)
            
            self.guardarContacto()
            
            self.tablaContactos.reloadData()
            
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(accionAceptar)
        alerta.addAction(accionCancelar)
        
        alerta.addTextField { nombreAlertaTF in
            nombreAlertaTF.placeholder = "Ingresa tu nombre"
        }
        
        alerta.addTextField { telefonoAlertaTF in
            telefonoAlertaTF.placeholder = "Ingresa tu telefono"
            telefonoAlertaTF.keyboardType = .numberPad
        }
        
        alerta.addTextField { direccionAlertaTf in
            direccionAlertaTf.placeholder = "ingresa tu direccion"
        }
        
        present(alerta, animated: true)
    }
    
    func guardarContacto(){
        do{
            try contexto.save()
            print("Contacto Guardado en la BD")
            
            
        }catch let error as NSError{
            print("Error al guradar en la BD \(error.localizedDescription)")
        }
    }
    
    func cargarInfoCoreData(){
        let fetchRequest: NSFetchRequest <Contacto> = Contacto.fetchRequest()
        
        do{
            contactos = try contexto.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Error al cargar informacion de la bd \(error.localizedDescription)")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            contexto.delete(contactos[indexPath.row])
            contactos.remove(at: indexPath.row)
            guardarContacto()
        }
        
        tablaContactos.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! ContactoTableViewCell

        
        celda.nombreContactoLabel.text = contactos[indexPath.row].nombre
        celda.telefonoContactoLabel.text = String(contactos[indexPath.row].telefono)
        celda.direccionContactoLabel.text = contactos[indexPath.row].direccion
        
        if let img = contactos[indexPath.row].imagen {
            celda.imagenContacto.image = UIImage(data: img)
        }
        
        
        return celda
    }
    
    //Detectar cuando el usuario seleccioma un elemento
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(contactos[indexPath.row].nombre)
        
        Indice = indexPath.row
        nombreEdit = contactos[indexPath.row].nombre
        telEdit = String(contactos[indexPath.row].telefono)
        dirEdit = contactos[indexPath.row].direccion
        imgedit = contactos[indexPath.row].imagen
        
        
        performSegue(withIdentifier: "editarContacto", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let objEditarC = segue.destination as! EditarContactoViewController
            objEditarC.Indice2 = Indice
            objEditarC.recibirNombre = nombreEdit
            objEditarC.recibirTelefono = telEdit
            objEditarC.recibirDireccion = dirEdit
            objEditarC.recibirImagen = imgedit
            
        }
    }
    
}



