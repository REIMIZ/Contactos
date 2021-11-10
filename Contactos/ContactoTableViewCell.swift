//
//  ContactoTableViewCell.swift
//  Contactos
//
//  Created by mac16 on 09/11/21.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagenContacto: UIImageView!
    @IBOutlet weak var nombreContactoLabel: UILabel!
    @IBOutlet weak var telefonoContactoLabel: UILabel!
    @IBOutlet weak var direccionContactoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
