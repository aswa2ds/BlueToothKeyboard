//
//  ViewController.swift
//  BlueToothKeyboard
//
//  Created by 王志邦 on 2018/12/1.
//  Copyright © 2018 EdwardMartin. All rights reserved.
//

import UIKit
import CoreBluetooth

//设置UUID
private let Service_UUID: String = "FDD8F013-52A5-432D-AB0E-2C342C7975B2"
private let Characteristics_UUID: String = "FDD8F013-52A5-432D-AB0E-2C342C7975B2"

class ViewController: UIViewController, UITextFieldDelegate {
    
    //外设管理对象
    var peripheralManager:CBPeripheralManager?
    var characteristics:CBMutableCharacteristic?
    
    //Mark: Variable
    @IBOutlet weak var inputTextField: UITextField!
    var myText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 初始化委托
        inputTextField.delegate = self
        
        // 初始化peripheral，在init中会调用peripheralManagerDidUpdateState
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: .main)
        
    }
    
    // 回车后，关闭键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 结束编辑后，将文本存入myText中
    func textFieldDidEndEditing(_ textField: UITextField) {
        myText = textField.text
    }

    
}

extension ViewController: CBPeripheralManagerDelegate{
    
    // 当peripheral.state的值为poweredOn时，才能进行advertising
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("可用")
            
            // 配置peripheralManager的服务
            setupUUID()
            
            // 进行Advertising
            self.peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: Service_UUID)]])
        default:
            print("不可用")
        }
    }
    
    private func setupUUID(){
        let serviceUUID = CBUUID.init(string: Service_UUID)
        let charicteristicsUUID = CBUUID.init(string: Characteristics_UUID)
        let myService = CBMutableService.init(type: serviceUUID, primary: true)
        let myCharacteristics = CBMutableCharacteristic.init(type: charicteristicsUUID, properties: [.read, .write, .notify], value: nil, permissions: [.readable, .writeable])
        myService.characteristics = [myCharacteristics]
        self.peripheralManager!.add(myService)
        self.characteristics = myCharacteristics
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error == nil{
            print("\(#function)addService successfully")
        }
        else{
            print("\(#function)addService failed: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error == nil{
            print("\(#function)startAdvertising successfully")
        }
        else{
            print("\(#function)startAdvertising failed: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("\(#function)receiveReadRequest")
        request.value = self.inputTextField.text?.data(using: .utf8)
        peripheral.respond(to: request, withResult: .success)
    }
    
    /** 订阅成功回调 */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("\(#function) subscribe successfully")
    }
    
    /** 取消订阅回调 */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("\(#function) unsubscribe successfully")
    }
}
