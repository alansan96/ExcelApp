//
//  ExcelViewModel.swift
//  ExcelApp
//
//  Created by Alan Santoso on 26/01/25.
//


import Foundation

class ExcelViewModel {
    private(set) var data: [[ExcelCellModel]] = []

    func fetchData(completion: @escaping () -> Void) {
        data = (1...50).map { row in
            [ExcelCellModel(title: "Frozen \(row)")] +
            (1...5).map { ExcelCellModel(title: "Item \(row)-\($0)") }
        }
        completion()
    }
}
