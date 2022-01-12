import UIKit

class HabitDetailViewController: BaseViewController {
    static func newInstance() -> HabitDetailViewController {
        UIStoryboard.getViewController(identifier: Constants.kHabitDetailViewController)
    }

    // MARK: - --OUTLETS--

    @IBOutlet var habitDetailTableView: CustomisedTableView!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var reminderLabel: UILabel!
    @IBOutlet var habitLogo: UIImageView!

    // MARK: - --VARIABLES--

    let headerViewMaxHeight: CGFloat = 180
    let headerViewMinHeight: CGFloat = 98
    var habitDetailData: Habits?

    // MARK: - --LIFECYCLE METHODS--

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeader()
        configureNavigationBar(title: habitDetailData?.title ?? "Remote Habits", hideBack: false, showLogo: false)
        addDefaultBackground()
        setupHabitDetailTableView()
    }

    // MARK: - --FUNCTIONS--

    func setupHabitDetailTableView() {
        habitDetailTableView.dataSource = self
        habitDetailTableView.delegate = self

        habitDetailTableView.register(UINib(nibName: Constants.kHabitReminderTableViewCell, bundle: nil),
                                      forCellReuseIdentifier: Constants.kHabitReminderTableViewCell)
        habitDetailTableView.register(UINib(nibName: Constants.kHabitDetailToggleTableViewCell, bundle: nil),
                                      forCellReuseIdentifier: Constants.kHabitDetailToggleTableViewCell)
        habitDetailTableView.register(UINib(nibName: Constants.kHabitAddInfoTableViewCell, bundle: nil),
                                      forCellReuseIdentifier: Constants.kHabitAddInfoTableViewCell)

        habitDetailTableView.setAutomaticRowHeight(height: .height100)
        habitDetailTableView.setContentOffset(.zero, animated: false)
    }

    func setUpHeader() {
        reminderLabel.text = "Set reminder to \(habitDetailData?.title ?? "good remote habits")"
        reminderLabel.textColor = Color.LabelLightGray
        if let logo = habitDetailData?.icon {
            habitLogo.image = UIImage(named: logo)
        }
    }
}

// MARK: - --UITABLEVIEWDATASOURCE--

extension HabitDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kHabitDetailToggleTableViewCell,
                                                           for: indexPath) as? HabitDetailToggleTableViewCell
            else {
                return UITableViewCell()
            }
            cell.actionHandler = self
            cell.habitData = habitDetailData
            cell.fillHabitsData()
            return cell
        } else if indexPath.row == 1 || indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kHabitReminderTableViewCell,
                                                           for: indexPath) as? HabitReminderTableViewCell
            else {
                return UITableViewCell()
            }
            cell.actionHandler = self
            cell.habitData = habitDetailData
            cell.fillHabitDetailData()
            return cell
        } else if indexPath.row == 2 || indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kHabitAddInfoTableViewCell,
                                                           for: indexPath) as? HabitAddInfoTableViewCell
            else {
                return UITableViewCell()
            }
            cell.descriptionLabel.text = habitDetailData?.habitDescription ?? ""
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - --UITABLEVIEWDELEGATE--

extension HabitDetailViewController: UITableViewDelegate {}

// MARK: - --UISCROLLVIEWDELEGATE--

extension HabitDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY: CGFloat = scrollView.contentOffset.y
        guard let headerViewHeightConstraint = headerHeightConstraint else { return }
        let newHeaderViewHeight: CGFloat =
            headerViewHeightConstraint.constant - offsetY
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

extension HabitDetailViewController: DashboardDetailActionHandler {
    func toggleHabit(toValue isEnabled: Bool) {
        let activity = isEnabled ? Constants.kHabitEnabled : Constants.kHabitDisabled
        let selectedHabit = SelectedHabitData(title: habitDetailData?.title,
                                              frequency: Int(habitDetailData?.frequency ?? 0),
                                              startTime: habitDetailData?.startTime?
                                                  .formatDateToString(inFormat: .time12Hour),
                                              endTime: habitDetailData?.endTime?
                                                  .formatDateToString(inFormat: .time12Hour),
                                              id: Int(habitDetailData?.id ?? 0),
                                              isEnabled: isEnabled)
        updateHabit(forActivity: activity, selectedHabit: selectedHabit, andSource: .habitdetail)
    }
}

extension HabitDetailViewController: DashboardDetailTimeHandler {
    func updateTime(with selectedHabit: SelectedHabitData) {
        updateHabit(forActivity: nil, selectedHabit: selectedHabit, andSource: .habitdetail)
    }
}
