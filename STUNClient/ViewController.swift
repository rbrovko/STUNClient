//
//  ViewController.swift
//  STUNClient
//
//  Created by Artem Goncharov on 19/03/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stunLog: UITextView!
    //lazy var stunClient: STUNClient = STUNClient(delegate: self)
    var secondTime: Bool = false
    var client: StunClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stunLog.text = "-----==FIRST TIME==-----\n"
//        do {
//            try self.stunClient.getNATParams(stunAddress: "64.233.163.127", localPort: 14135, stunPort: 19302)
//        } catch STUNError.CantBindToLocalPort(let port) {
//            self.error(errorText: "Cant Bind To Local Port \(port)")
//        } catch STUNError.CantRunUdpSocket {
//            self.error(errorText: "Cant Run UDP Socket")
//        } catch {
//            self.error(errorText: "Unexpeted error \(error)")
//        }
        //stun.l.google.com
        client = StunClient(stunIpAddress: "64.233.163.127", stunPort: 19302, localPort: 14135)
        let successCallback: (String, Int) -> () = { [weak self] (myAddress: String, myPort: Int) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.stunLog.text = self.stunLog.text + "\n" + "COMPLETED, my address: " + myAddress + " my port: " + String(myPort)
            }
        }
        let errorCallback: (STUNError) -> () = { [weak self] error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.stunLog.text = self.stunLog.text + "\n" + "ERROR: " + error.localizedDescription
                }
            }
        let verboseCallback: (String) -> () = { [weak self] logText in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.stunLog.text = self.stunLog.text + "\n" + logText
                }
            }
        
        
        client
            .whoAmI()
            .ifWhoAmISuccessful(successCallback)
            .ifError(errorCallback)
            .verbose(verboseCallback)
            .start()
    }
}


//MARK: STUNClientDelegate
extension ViewController: STUNClientDelegate {
    func verbose(_ logText: String) {
        DispatchQueue.main.async {
            self.stunLog.text = self.stunLog.text + "\n" + logText
        }
    }
    
    func error(errorText: String) {
        DispatchQueue.main.async {
            self.stunLog.text = self.stunLog.text + "\n" + "ERROR: " + errorText
        }
    }
    
    func completed(nat: NATParams) {
        if secondTime {
            return
        }
        secondTime = true
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
//           // self.stunLog.text = "COMPLETED: " + "\n" + nat.description + "\n"
//            self.stunLog.text = self.stunLog.text + "\n" + "-----==SECOND TIME==-----\n"
//            do {
//                try self.stunClient.getNATParams(stunAddress: "64.233.163.127", localPort: 14135, stunPort: 19302)
//            } catch STUNError.CantBindToLocalPort(let port) {
//                self.error(errorText: "Cant Bind To Local Port \(port)")
//            } catch STUNError.CantRunUdpSocket {
//                self.error(errorText: "Cant Run UDP Socket")
//            } catch {
//                self.error(errorText: "Unexpeted error \(error)")
//            }
//        })
    }
}
