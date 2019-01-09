//
//  ViewController.swift
//  RemoteControl
//
//  Created by smallchen on 2019/1/3.
//  Copyright © 2019 cn.em. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: VARIABLES
    var clientSocket: GCDAsyncSocket!
    var hostIp: String!
    var connection: Bool = false
    var text:String?
    let port:UInt16 = 7777
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var hostTextField: UITextField!
    //MARK: ACTIONS
    /*
     连接时 hostTextField非空， 否则不进行连接
     连接后，连接按键变为断开连接按键
     */
    @IBAction func tapNumButton(_ sender: UIButton) {
        let data = sender.currentTitle?.data(using: .utf8)
        write(data!)
    }
    @IBAction func tabConnectButton(_ sender: UIButton) {
        if connectButton.currentTitle == "CONNECT!"{
            if hostTextField.text == ""{
                print("host is empty")
                return
            }
            hostIp = hostTextField.text
            hostTextField.resignFirstResponder()
            print("host: \(hostIp!), port: \(port)")
            if connect(to: hostIp, on: port){
                connectButton.setTitle("DISCONNECT!", for: .normal)
            }
        }else {
            if disconnect(){
                connectButton.setTitle("CONNECT!", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostTextField.delegate = self
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
}

extension ViewController:UITextFieldDelegate{
    //MARK:DELEGATES
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            print("host is empty")
            return
        }
        hostIp = textField.text
        print("host: \(hostIp!), port: \(port)")
    }
    /*
     点击键盘return时，执行connect按钮的功能，不执行disconnect按钮的功能
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            print("host is empty")
            return false
        }
        textField.resignFirstResponder()
        if connectButton.currentTitle == "CONNECT!"{
            hostIp = textField.text
            resignFirstResponder()
            print("host: \(hostIp!), port: \(port)")
            if connect(to: hostIp, on: port){
                connectButton.setTitle("DISCONNECT!", for: .normal)
            }
        }
        return true
    }
}

extension ViewController:GCDAsyncSocketDelegate{
    /*
     通过套接字进行连接，成功时返回true，否则输出失败连接，并返回false
     */
    func connect(to host:String, on port:UInt16) -> Bool{
        do{
            try clientSocket.connect(toHost: host, onPort: port, withTimeout: -1)
        }
        catch{
            print("fail to connect to \(host):\(port)")
            return false
        }
        connection = true
        print("connected!")
        return true
    }
    /*
     断开套接字的连接
     */
    func disconnect() -> Bool{
        clientSocket.disconnect()
        connection = false
        return true
    }
    /*
     向服务器发送文字,并重新连接来发送文字
     */
    func write(_ data: Data){
        if connection{
            clientSocket.write(data, withTimeout: -1, tag: 0)
            clientSocket.readData(withTimeout: -1, tag: 0)
            reconnect(to: clientSocket.connectedHost!, on: clientSocket.connectedPort)
        }
    }
    /*
     重新连接
     */
    func reconnect(to host:String, on port:UInt16){
        clientSocket.disconnect()
        connection = false
        do{
            try clientSocket.connect(toHost: host, onPort: port, withTimeout: -1)
            connection = true
        }
        catch{
            print("连接中断")
        }
    }
    //MARD: DELEGATES
}
