import Foundation
import UIKit
import SwiftUI
import DFetcher


enum typeOfSuffix: Int {
    case GCD_Items
    case ASC
    case DESC
    case _3h
    case _5h
    case feed
}


 public class TableViewFetchUI: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var text: Text = Text(words: [Word]())
    var tableView: UITableView
    var gcdIndicatorSegmet = true
    var segment: UISegmentedControl
    
    required init?(coder aDecoder: NSCoder) {
        
        self.tableView = .init()
        self.segment = UISegmentedControl(items: ["CGD_Items","ASC","DESC","3", "5"])

        super.init(coder: aDecoder)
    }
    
    init(tableView: UITableView, segment: UISegmentedControl) {
        self.tableView = tableView
        self.segment = segment

        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
       
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        // make segmentConrol
        segment.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .allEvents)
       
        let viewMain: UIStackView = .init()
        viewMain.axis = .vertical
        viewMain.addArrangedSubview(segment)
        viewMain.addArrangedSubview(tableView)
       
        self.view = viewMain
        ShedulerGCD.shared.schedule(with: "operationASC") { [weak self] in
            self?.gcdIndicatorSegmet = false
            self?.segment.selectedSegmentIndex = 1
            self?.text.sortAbcASC()
            self?.tableView.reloadData()
            print("ASC")
        }
        ShedulerGCD.shared.schedule(with: "operationDESC") { [weak self] in
            self?.gcdIndicatorSegmet = false
            self?.segment.selectedSegmentIndex = 2
            self?.text.sortAbcDESC()
            self?.tableView.reloadData()
            print("DESC")
        }
        ShedulerGCD.shared.schedule(with: "operationget_3_letter") { [weak self] in
            self?.gcdIndicatorSegmet = false
            self?.text.get_3_letter()
            self?.segment.selectedSegmentIndex = 3
            self?.tableView.reloadData()
            print("get_3_letter")
        }
        ShedulerGCD.shared.schedule(with: "operationget_5h") { [weak self] in
            self?.gcdIndicatorSegmet = false
            self?.segment.selectedSegmentIndex = 4
            self?.text.get_5_letter()
            self?.tableView.reloadData()
            print("_5h")
        }
            
        
    }
    
    // number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gcdIndicatorSegmet {
            return ShedulerGCD.shared.items.keys.count
        } else {
            return self.text.words.count
        }
    }


    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?)!
       
        if gcdIndicatorSegmet {
            cell.textLabel?.text = ShedulerGCD.shared.items.keys
                .map({ds -> String in
                      return String(ds)
                    })[indexPath.row]
        } else {
            cell.textLabel?.text = self.text.words[indexPath.row].letters + (self.text.words[indexPath.row].countInText > 0 ? " " +  String(self.text.words[indexPath.row].countInText) : "")
        }
        // set the text from the data model
        

        return cell
    }

    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operationName = ShedulerGCD.shared.items.keys
            .map({ds -> String in
                  return String(ds)
                })[indexPath.row]
        ShedulerGCD.shared.startAction(with: operationName)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        
        guard let selectedSuffixType = typeOfSuffix(rawValue: sender.selectedSegmentIndex) else {
            fatalError("error")
        }
        switch selectedSuffixType {
        case .ASC, .DESC, ._3h, ._5h:
            gcdIndicatorSegmet = false
        case .GCD_Items:
            gcdIndicatorSegmet = true
            print("GCD_Items")
        case .feed:
            print("feed")
        }
        self.tableView.reloadData()
    }
}

public final class TableViewFetch: UIViewControllerRepresentable {

    var data: String
   
   
    public init(data: String) {
        self.data = data
    }

    public func makeUIViewController(context: Context) -> TableViewFetchUI {

        let splitText = data.split(separator: " ")
        let text = Text(words: splitText.map { word -> Word in
            let countedSet = NSCountedSet(array: splitText)
            return Word(letters: String(word), countInText: countedSet.count(for: word))
        })
        
        let tableViewController: TableViewFetchUI = .init(tableView: .init(),  segment: UISegmentedControl(items: ["CGD_Items","ASC","DESC","3", "5"]))
        tableViewController.text = text
        
        return tableViewController
    }
    
    public func updateUIViewController(_ uiViewController: TableViewFetchUI, context: Context) {
     //   TableViewFetchUI(data: data)
    }
    
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(control: self)
    }
    
    public class Coordinator: NSObject {
        
        var control: TableViewFetch
        
        init(control: TableViewFetch) {
            self.control = control
        }
    }
    
    struct TableViewFetch_Previews: PreviewProvider {
      
        @available(iOS 13.0, *)
        static var previews: some View {
            Group {
                TableViewFetch(data: "dsfsdf")
            }
        }
    }
}

