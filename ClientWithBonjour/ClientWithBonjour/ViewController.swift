//
//  ViewController.swift
//  ClientWithBonjour
//
//  Created by Emre Tekin on 8.06.2023.
//

import UIKit
import Network

class ViewController: UIViewController {
    let serverID = "benimAdimEmre"
    let serviceType = "_myService._tcp"
    
    var connection: NWConnection?
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        
        
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
    }
    
    func connectToServer() {
        let endpoint = NWEndpoint.service(name: serverID, type: serviceType, domain: "local",interface: nil)
        connection = NWConnection(to: endpoint, using: .tcp)
        
        connection?.stateUpdateHandler = { [weak self] newState in
            switch newState {
            case .ready:
                print("Connected to server")
                self?.sendDataToServer()
            case .failed(let error):
                print("Connection failed with error: \(error)")
            default:
                break
            }
        }
        
        connection?.start(queue: .main)
    }
    
    func sendDataToServer() {
        guard let message = textField.text else {
            return
        }
        
        let data = message.data(using: .utf8)
        
        connection?.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Sending data failed with error: \(error)")
            } else {
                print("Data sent to server")
            }
            self.connection?.cancel()
        })
    }
    
    @IBAction func connectButtonTapped(_ sender: UIButton) {
        connectToServer()
    }
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendDataToServer()
    }
}
