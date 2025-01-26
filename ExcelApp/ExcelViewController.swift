//
//  ViewController.swift
//  ExcelApp
//
//  Created by Alan Santoso on 26/01/25.
//

import UIKit

class ExcelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExcelTableViewCellDelegate {
    
    private let viewModel = ExcelViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExcelTableViewCell.self, forCellReuseIdentifier: ExcelTableViewCell.identifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var horizontalOffset: CGFloat = 0  // Tracks horizontal scroll position
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func loadData() {
        viewModel.fetchData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExcelTableViewCell.identifier, for: indexPath) as? ExcelTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.data[indexPath.row], scrollOffset: horizontalOffset)
        cell.delegate = self  // Assign delegate to synchronize scrolling
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - ExcelTableViewCellDelegate
    
    func didScrollHorizontally(scrollView: UIScrollView) {
        horizontalOffset = scrollView.contentOffset.x
        
        // Delay updating to avoid access conflicts
        DispatchQueue.main.async {
            self.syncAllCells()
        }
    }
    
    private func syncAllCells() {
        guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in indexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? ExcelTableViewCell {
                cell.scrollView.setContentOffset(CGPoint(x: horizontalOffset, y: 0), animated: false)
            }
        }
    }
}
