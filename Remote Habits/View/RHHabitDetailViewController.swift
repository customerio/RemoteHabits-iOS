//
//  HabitDetailViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import UIKit

class RHHabitDetailViewController: RHBaseViewController {

    // MARK: - --OUTLETS--
    @IBOutlet weak var habitDetailTableView: RHCustomisedTableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var habitLogo: UIImageView!
    
    // MARK: - --VARIABLES--
    let headerViewMaxHeight : CGFloat = 180
    let headerViewMinHeight : CGFloat = 98
    var habitDetailData : Habits? = nil

    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeader()
        configureNavigationBar(title: habitDetailData?.title ?? "Remote Habits", hideBack: false, showLogo : false)
        addDefaultBackground()
        setupHabitDetailTableView()
        
    }
    

    // MARK: - --FUNCTIONS--
    func setupHabitDetailTableView() {
        habitDetailTableView.dataSource = self
        habitDetailTableView.delegate = self
        
        habitDetailTableView.register(UINib(nibName: RHConstants.kHabitReminderTableViewCell, bundle: nil), forCellReuseIdentifier: RHConstants.kHabitReminderTableViewCell)
        habitDetailTableView.register(UINib(nibName: RHConstants.kHabitDetailToggleTableViewCell, bundle: nil), forCellReuseIdentifier: RHConstants.kHabitDetailToggleTableViewCell)
        habitDetailTableView.register(UINib(nibName: RHConstants.kHabitAddInfoTableViewCell, bundle: nil), forCellReuseIdentifier: RHConstants.kHabitAddInfoTableViewCell)
        
        habitDetailTableView.setAutomaticRowHeight(height: .height100)
        habitDetailTableView.setContentOffset(.zero , animated: false )

    }
    
    
    func setUpHeader() {
        reminderLabel.text = "Set reminder to \(habitDetailData?.title ?? "good remote habits")"
        if let logo = habitDetailData?.icon {
            habitLogo.image = UIImage(named: logo)
        }
    }
    
    func updateHabits(with selectedHabit : SelectedHabitData) {
        habitsDataManager.updateHabit(withData: selectedHabit)
        NotificationCenter.default.post(name: Notification.Name(RHConstants.kHabitsUpdatedIdentifier), object: nil)
    }
    
        /*
    // MARK: - --NAVIGATION--

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - --UITABLEVIEWDATASOURCE--
extension RHHabitDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RHConstants.kHabitDetailToggleTableViewCell, for: indexPath) as? HabitDetailToggleTableViewCell else {
                return UITableViewCell()
            }
            cell.actionHandler = self
            cell.habitData = habitDetailData
            cell.fillHabitsData()
            return cell
        }
        else if indexPath.row == 1 || indexPath.row == 4{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RHConstants.kHabitReminderTableViewCell, for: indexPath) as? HabitReminderTableViewCell else {
                return UITableViewCell()
            }
            cell.actionHandler = self
            cell.habitData = habitDetailData
            cell.fillHabitDetailData()
            return cell
        }
        else if indexPath.row == 2 || indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RHConstants.kHabitAddInfoTableViewCell, for: indexPath) as? HabitAddInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.descriptionLabel.text = habitDetailData?.habitDescription ?? ""
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - --UITABLEVIEWDELEGATE--
extension RHHabitDetailViewController : UITableViewDelegate {
   
}

// MARK: - --UISCROLLVIEWDELEGATE--
extension RHHabitDetailViewController : UIScrollViewDelegate {
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let y: CGFloat = scrollView.contentOffset.y
    guard let headerViewHeightConstraint = headerHeightConstraint else {return}
    let newHeaderViewHeight: CGFloat =
              headerViewHeightConstraint.constant - y
    if newHeaderViewHeight > headerViewMaxHeight {
       headerViewHeightConstraint.constant = headerViewMaxHeight
    } else if newHeaderViewHeight <= headerViewMinHeight {
       headerViewHeightConstraint.constant = headerViewMinHeight
    } else {
       headerViewHeightConstraint.constant = newHeaderViewHeight
       scrollView.contentOffset.y = 0 // block scroll view
    }
  }
}


extension RHHabitDetailViewController : RHDashboardDetailActionHandler {
    func toggleHabit(toValue isEnabled: Bool) {
        
        let activity = isEnabled ? RHConstants.kHabitEnabled : RHConstants.kHabitDisabled
        let selectedHabit = SelectedHabitData(title: habitDetailData?.title, frequency: Int(habitDetailData?.frequency ?? 0), startTime: habitDetailData?.startTime?.formatDateToString(inFormat: .time12Hour), endTime: habitDetailData?.endTime?.formatDateToString(inFormat: .time12Hour), id: Int(habitDetailData?.id ?? 0), isEnabled: isEnabled)
        updateHabit(forActivity: activity, selectedHabit: selectedHabit, andSource: .habitdetail)
    }
}


extension RHHabitDetailViewController : RHDashboardDetailTimeHandler {
    func updateTime(with selectedHabit: SelectedHabitData) {
        updateHabit(forActivity: nil, selectedHabit: selectedHabit, andSource: .habitdetail)
    }
}
