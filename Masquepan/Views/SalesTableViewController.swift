import UIKit

class SalesTableViewController: UITableViewController {

    @IBOutlet weak var controller: UISegmentedControl!
    
    @IBOutlet weak var tableviewsales: UITableView!
    
    var state : String = "fecha"
    
    var ticketSortedByDateDesc = [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeViews(_ sender: Any) {
        switch controller.selectedSegmentIndex {
        case 0:
            print("Fecha")
            state = "fecha"
            ticketSortedByDateDesc = myTickets.tickets.sorted(by: {$0.id > $1.id})
            tableviewsales.reloadData()
        case 1:
            print("Vendedor")
            state = "vendedor"
            ticketSortedByDateDesc = ticketSortedByDateDesc.sorted(by: {$0.idmember < $1.idmember})
            tableviewsales.reloadData()
        case 2:
            print("Familia")
        default:
            break;
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTickets.tickets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewsales.dequeueReusableCell(withIdentifier: "SalesTableViewCell", for: indexPath) as! SalesTableViewCell
        let ticketid = ticketSortedByDateDesc[indexPath.item].id
        cell.idticketlabel.text = ticketid
        cell.dateticketlabel.text = ticketSortedByDateDesc[indexPath.item].date
        cell.memberticketlabel.text = myMembers.members[Int(ticketSortedByDateDesc[indexPath.item].idmember)! - 1].login
        return cell
    }
 
    override func viewWillAppear(_ animated: Bool) {
        
        if (state == "fecha") {
            ticketSortedByDateDesc = myTickets.tickets.sorted(by: {$0.id > $1.id})
        } else if (state == "vendedor"){
            ticketSortedByDateDesc = ticketSortedByDateDesc.sorted(by: {$0.idmember < $1.idmember})
        }
        tableviewsales.reloadData()
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
