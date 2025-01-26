//
//  ExcelTableViewCell.swift
//  ExcelApp
//
//  Created by Alan Santoso on 26/01/25.
//


import UIKit

protocol ExcelTableViewCellDelegate: AnyObject {
    func didScrollHorizontally(scrollView: UIScrollView)
}

class ExcelTableViewCell: UITableViewCell, UIScrollViewDelegate {
    static let identifier = "ExcelTableViewCell"
    
    weak var delegate: ExcelTableViewCellDelegate?

    let frozenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.numberOfLines = 1
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(frozenLabel)
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)

        frozenLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            frozenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frozenLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            frozenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            frozenLabel.widthAnchor.constraint(equalToConstant: 100),

            scrollView.leadingAnchor.constraint(equalTo: frozenLabel.trailingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func configure(with row: [ExcelCellModel], scrollOffset: CGFloat) {
        frozenLabel.text = row.first?.title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        row.dropFirst().forEach { cellModel in
            let label = UILabel()
            label.text = cellModel.title
            label.textAlignment = .center
            label.backgroundColor = .white
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.widthAnchor.constraint(equalToConstant: 120).isActive = true
            stackView.addArrangedSubview(label)
        }
        
        scrollView.contentSize = CGSize(width: 5 * 130, height: contentView.frame.height)
        scrollView.setContentOffset(CGPoint(x: scrollOffset, y: 0), animated: false)
    }
    
    // Synchronize horizontal scrolling across all cells
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollHorizontally(scrollView: scrollView)
    }
}
