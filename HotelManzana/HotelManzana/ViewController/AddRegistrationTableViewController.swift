//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Calvin Cantin on 2018-12-21.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    
    @IBOutlet weak var doneRightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    
    @IBOutlet weak var numberOfChildrensLabel: UILabel!
    @IBOutlet weak var numerOfChildrensStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var roomTypePriceLabel: UILabel!
    @IBOutlet weak var wifiPriceLabel: UILabel!
    @IBOutlet weak var totalChargeLabel: UILabel!
    
    
    @IBOutlet weak var numberOfNightLabel: UILabel!
    
    var roomType:RoomType?
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var numberOfNight = 0
    var wifiPrice = 0
    var roomTypePrice = 0
    var previousRegistration: Registration?
    var registration: Registration?
    {
        
        
        guard let roomType = roomType else {return nil}
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildrens = Int(numberOfAdultsStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, email: email, checkInDate: checkInDate, checkOutDate: checkOutDate, adultNumber: numberOfAdults, childrenNumber: numberOfChildrens, roomChoice: roomType, wifiAcess: hasWifi)
        
    }
    var isCheckInDatePickerShown:Bool = false
    {
        didSet
        {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown:Bool = false
    {
        didSet
        {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.date = midnightToday
        updateDateViews()
        updateNumberOfGuest()
        updateRoomType()
        updateWifiSwitchPriceLabel()
        updateTotalPriceLabel()
        if self.registration == nil && previousRegistration == nil
        {
            doneRightBarButton.isEnabled = false
        }
        if let registration = previousRegistration
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            firstNameTextField.text = registration.firstName
            lastNameTextField.text = registration.lastName
            emailTextField.text = registration.email
            checkInDateLabel.text = dateFormatter.string(from: registration.checkInDate)
            checkOutDateLabel.text = dateFormatter.string(from: registration.checkOutDate)
            numberOfAdultsLabel.text = String(registration.adultNumber)
            numberOfChildrensLabel.text = String(registration.childrenNumber)
            wifiSwitch.isOn = registration.wifiAcess
            roomTypeLabel.text = registration.roomChoice.name
            roomType = registration.roomChoice
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func cancelButtontapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuest()
    }
    @IBAction func wifiSwitchValueChanged(_ sender: UISwitch) {
        updateWifiSwitchPriceLabel()
        updateTotalPriceLabel()
    }
    
    func updateDateViews()
    {
        numberOfNight = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        var chekInDate = checkInDatePicker.date
        while chekInDate.compare(checkOutDatePicker.date) == .orderedAscending
        {
            chekInDate = chekInDate.addingTimeInterval(86400)
            numberOfNight += 1
        }
        numberOfNightLabel.text = "\(numberOfNight)"
        updateTotalPriceLabel()
        updateWifiSwitchPriceLabel()
        updateRoomType()
    }
    func updateNumberOfGuest()
    {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrensLabel.text = "\(Int(numerOfChildrensStepper.value))"
    }
    func updateWifiSwitchPriceLabel()
    {
        if wifiSwitch.isOn
        {
            wifiPrice = numberOfNight * 10
            wifiPriceLabel.text = "Yes    $ \(wifiPrice)"
        }
        else
        {
            wifiPrice = 0
            wifiPriceLabel.text = "No    $ 0"
        }
        updateTotalPriceLabel()
    }
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    func updateTotalPriceLabel()
    {
        let totalPrice = roomTypePrice + wifiPrice
        
        totalChargeLabel.text = "$    \(String(totalPrice))"
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section,indexPath.row) {
        case (checkInDatePickerCellIndexPath.section,checkInDatePickerCellIndexPath.row):
            if isCheckInDatePickerShown
            {
                return 216.0
            }
            else
            {
                return 0.0
            }
        case (checkOutDatePickerCellIndexPath.section,checkOutDatePickerCellIndexPath.row):
            if isCheckOutDatePickerShown
            {
                return 216.0
            }
            else
            {
                return 0.0
            }
        default:
            return 44
        }
    }
    
    
    func updateRoomType()
    {
        if let roomType = roomType
        {
            roomTypePrice = Int(roomType.price) * numberOfNight
            roomTypeLabel.text = roomType.name
            doneRightBarButton.isEnabled = true
            roomTypePriceLabel.text = "\(roomType.shortName)    $ \(roomTypePrice)"
        }
        else
        {
            roomTypePrice = 0
            roomTypeLabel.text = "Not Set"
            doneRightBarButton.isEnabled = false
            roomTypePriceLabel.text = "Not Set    $ 0"
        }
        updateTotalPriceLabel()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row)
        {
        case (checkInDatePickerCellIndexPath.section,checkInDatePickerCellIndexPath.row - 1):
            if isCheckInDatePickerShown
            {
                isCheckInDatePickerShown = false
            }
            else if isCheckOutDatePickerShown
            {
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            }
            else
            {
                isCheckInDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row - 1):
            if isCheckOutDatePickerShown
            {
                isCheckOutDatePickerShown = false
            }
            else if isCheckInDatePickerShown
            {
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            }
            else
            {
                isCheckOutDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    // MARK: - Table view data source

   
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectRoomType"
        {
            let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.roomType = roomType
        }
    }
 

}
