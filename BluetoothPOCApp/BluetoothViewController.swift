//
//  BluetoothViewController.swift
//  BluetoothPOCApp
//
//  Created by Mbah Fonong on 3/25/21.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
    
    let cbCentralManager = CBCentralManager()
    var transferCharacteristic: CBMutableCharacteristic?
    var peripheral: CBPeripheral?
    var peripheralArray: [CBPeripheral] = [CBPeripheral]()
    
    @IBOutlet weak var peripheralLabel: UILabel!
    
    @IBOutlet weak var peripheralTableView: UITableView!
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cbCentralManager.delegate = self
        self.peripheralTableView.dataSource = self
        self.peripheralTableView.delegate = self
    }
}
    
extension BluetoothViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            self.peripheralLabel.text = "Scanning..."
        } else {
            let alertController = UIAlertController(title: "Turn On Bluetooth In Settings", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !self.peripheralArray.contains(peripheral), let _ = peripheral.name {
            print("Peripheral: \(peripheral) found")
            self.peripheralArray.append(peripheral)
            self.peripheralTableView.reloadData()
            print("Signal strength: \(RSSI)")
            if RSSI.intValue >= -50 {
                self.peripheral = peripheral
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral")
        peripheral.discoverServices(nil)
    }
}

extension BluetoothViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripheralArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = self.peripheralArray[indexPath.row].name
        return cell ?? UITableViewCell()
    }
}

extension BluetoothViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cbCentralManager.connect(self.peripheralArray[indexPath.row], options: nil)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        print(self.peripheralArray[indexPath.row].state)
        self.cbCentralManager.stopScan()
        self.peripheralLabel.text = "Available Bluetooth Devices"
    }
}
