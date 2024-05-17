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
    
    // Теперь свойство модифицируемо — оно будет хранить добавленные цвета.
    private var colors = [UIColor]()
    
    // Объявляем приватное свойство в классе SupplementaryCollection
    private let params: GeometricParams
    private var collectionView: UICollectionView!
    
    // Добавляем в конструктор параметр params
    init(using params: GeometricParams) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Указываем, какой Layout хотим использовать:
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // Создаем коллекцию с размером, равным размеру представления контроллера
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        // Создадим стандартную кнопку с экшеном.
        let addButton = UIButton(type: .roundedRect, primaryAction: UIAction(title: "Add color", handler: { [weak self] _ in
            // Массив доступных цветов
            let availableColors: [UIColor] = [.black, .blue, .brown, .cyan, .green, .orange, .red, .purple, .yellow]
            // Произвольно выберем два цвета из массива
            let selectedColors = (0..<2).map { _ in availableColors[Int.random(in: 0..<availableColors.count)] }
            // Добавим выбранные цвета в коллекцию
            self?.add(colors: selectedColors)
        }))
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // метод для обновления свойств и анимации перерисовки коллекции
    func add(colors values: [UIColor]) {
        guard !values.isEmpty else { return }
        
        let count = colors.count
        colors += values
        
        collectionView.performBatchUpdates {
            let indexes = (count..<colors.count).map { IndexPath(row: $0, section: 0) }
            collectionView.insertItems(at: indexes)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SupplementaryCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SupplementaryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 2/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    // метод для удаления ячеек при тапе на них
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Удаляем из массива элемент с индексом
//        colors.remove(at: indexPath.row)
//            
//        collectionView.performBatchUpdates {
//            collectionView.deleteItems(at: [indexPath])
//        }
        
        // Сохраняем выбранный цвет.
        let color = colors[indexPath.row]
        // Создаём массив, записываем туда индексы массива, в которых содержится такой же цвет.
        var indexes: [Int] = []
        
        // Нам нужно получить индексы элементов, поэтому пройдёмся по индексированному списку.
        colors.enumerated().forEach { index, element in
            if element == color { indexes.append(index) }
        }
        
        // Удалим из массива colors все элементы под индексами, начиная с последнего.
        // В противном случае, при удалении с начала массива индексы будут смещаться и указывать на некорректные значения.
        indexes.reversed().forEach { colors.remove(at: $0) }
        
        // Выполним анимированное удаление из коллекции.
        collectionView.performBatchUpdates {
            let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
            collectionView.deleteItems(at: indexPaths)
        }
    }
}

