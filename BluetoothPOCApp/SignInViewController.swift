//
//  SignInViewController.swift
//  BluetoothPOCApp
//
//  Created by Mbah Fonong on 3/28/21.
//
import LocalAuthentication
import UIKit

enum State {
    case loggedIn
    case loggedOut
}

class SignInViewController: UIViewController {

    var state: State = .loggedOut
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.setTitle("Login", for: .normal)
            signInButton.addTarget(self, action: #selector(login), for: .touchUpInside)
            signInButton.layer.cornerRadius = 25
        }
    }
    
    @objc func login() {
        var context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "To log in to the app"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        let bluetoothVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BluetoothViewController")
                        bluetoothVC.modalPresentationStyle = .fullScreen
                        self?.present(bluetoothVC, animated: true, completion: nil)
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            print("Biometrics not set up")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
