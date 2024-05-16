//
//  ViewController.swift
//  FlowLayoutTrsting
//
//  Created by Pavel Nikipelov on 16.05.2024.
//

import UIKit

// Основной класс, в котором мы будем выполнять эксперименты;
// он же является `UICollectionViewDataSource`, поставщиком данных для коллекции:
final class SupplementaryCollectionViewController: UIViewController {
    
    private let colors: [UIColor] = [
        .black, .blue, .brown,
        .cyan, .green, .orange,
        .red, .purple, .yellow
    ]
    
    // Объявляем приватное свойство в классе SupplementaryCollection
    private let params: GeometricParams
    private let count: Int
    private var collectionView: UICollectionView!
    
    // Добавляем в конструктор параметр params
    init(count: Int, using params: GeometricParams) {
        self.count = count
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Размеры для коллекции:
        let size = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 600, height: 600))
        
        // Указываем, какой Layout хотим использовать:
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Создаем коллекцию с размером, равным размеру представления контроллера
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Добавляем autoresizing mask
        
        // используем size для установки определенного размера нашей коллекции
        // collectionView = UICollectionView(frame: size, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.center = view.center // Центрируем коллекцию на экране
    }
}

// MARK: - UICollectionViewDataSource
extension SupplementaryCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SupplementaryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // метод для настройки размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        let height: CGFloat = indexPath.row % 6 < 2 ? 2 / 3 : 1 / 3
        return CGSize(width: cellWidth,
                      height: cellWidth * height)
    }
    
    // метод для настройки отступов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: params.leftInset,
                            bottom: 10,
                            right: params.rightInset)
    }
    
    // метод для параметров вертикального отступа между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // метод для параметров горизонтального отступа между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
}
