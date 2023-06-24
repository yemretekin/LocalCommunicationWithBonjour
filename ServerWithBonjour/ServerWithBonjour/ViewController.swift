//
//  ViewController.swift
//  ServerWithBonjour
//
//  Created by Emre Tekin on 8.06.2023.
//

import UIKit
import Network

class ViewController: UIViewController {
    let serverID = "benimAdimEmre"
    let serviceType = "_myService._tcp"
    
    var listener: NWListener?
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startListening()
    }
    
    func startListening() {
        //        let tcpOptions = NWProtocolTCP.Options()
        //        tcpOptions.enableKeepalive = true
        //        tcpOptions.keepaliveIdle = 2
        //
        //        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        //        parameters.includePeerToPeer = true
        //        listener = try! NWListener(using: parameters)
        //
        //        listener!.service = NWListener.Service(name: "benimAdimEmre", type: "_myService._tcp")
        
        let listener = try? NWListener(using: .tcp, on: .any)
        
        listener?.stateUpdateHandler = { [weak self] newState in
            switch newState {
            case .ready:
                print("Server started listening")
            case .failed(let error):
                print("Server failed with error: \(error)")
            default:
                break
                }
                
                listener?.start(queue: .main)
            }
        }
        
        func readMessage(connection: NWConnection) {
            connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { content, contentContext, isComplete, error in
                guard error == nil, let content = content else {return}
                
                if let messageString = String(data: content, encoding: .utf8) {
                    print("Received message:", messageString)
                    DispatchQueue.main.async {
                        self.textLabel.text = messageString
                    }
                }
            }
        }
        
        //    func receiveData(on connection: NWConnection) {
        //        connection.receiveMessage { [weak self] data, context, _, error in
        //            print(data)
        //            if let data = data, let message = String(data: data, encoding: .utf8) {
        //                print("Received message from client: \(message)")
        //                //self?.textLabel.text(with: message)
        //            }
        //
        //            if let error = error {
        //                print("Receiving data failed with error: \(error)")
        //            }
        //
        //            connection.cancel()
        //        }
        //    }
        
        
    }


