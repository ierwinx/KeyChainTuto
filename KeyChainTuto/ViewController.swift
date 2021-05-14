import UIKit
import KeychainAccess
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var resultado: UILabel!
    
    private let keychain = Keychain(service: "com.bancoazteca.KeyChainTuto")
    private let keychainWeb = Keychain(server: "https://github.com", protocolType: .https)
    
    // para los biometricos
    private var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //biometricos
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        guardarLlavesWeb()
    }
    
    @IBAction func guardarAction(_ sender: Any) {
        keychain["miUltraLlaveSecreta"] = "esta es el texto guardado"
        resultado.text = "Informacion Guardada"
    }
    
    @IBAction func recuperarAction(_ sender: Any) {
        context.localizedCancelTitle = "Cancelar"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Login en tu cuenta de KeChainTuto"
            
            
            
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async {  [unowned self] in
                        self.resultado.text = self.keychain["miUltraLlaveSecreta"]
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
            
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
        
    }
    
    @IBAction func eliminarAction(_ sender: Any) {
        do {
            try keychain.remove("miUltraLlaveSecreta")
            resultado.text = "Informacion eliminada"
            
            keychainWeb["username"] = nil
1234
            
            
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func guardarLlavesWeb() -> Void {
        if keychainWeb["username"] != nil {
            context.localizedCancelTitle = "Cancelar"
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Login en tu cuenta de KeChainTuto"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                    
                    if success {
                        DispatchQueue.main.async {  [unowned self] in
                            let usuario = self.keychainWeb["username"]
                            let password = self.keychainWeb["password"]
                            self.resultado.text = "\(usuario!) \(password!)"
                        }
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                    }
                }
                
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
            }

        } else {
            keychainWeb["username"] = "erwin"
            keychainWeb["password"] = "01234567"
        }
    }
    
}

