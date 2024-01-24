//
//  ProductsViewController.swift
//  FinalProjectTatia
//
//  Created by Tatia on 17.01.24.
//

import Foundation
import UIKit

struct ProductViewData: Hashable {
    var category: String
    var products: [ProductsItemViewData]
}

struct UserViewData {
    var balance: Double = 0
    var products: [ProductsItemViewData] = []
}

struct ProductsItemViewData: Hashable {
    var id: Int
    var brand: String
    var title: String
    var category: String
    var stock: Int
    var price: Int
    let images: [String]
    var selectedItems: Int = 0
}

class ProductsViewController: UIViewController {
    var tableView = UITableView()
    var bottomView = UIView()
    var imageView = UIImageView()
    var moveToBinButton = UIButton()
    var resetButton = UIButton()
    var quantityLabel = UILabel()
    var priceLabel = UILabel()
    
    private let networking = Networking()
    var products: [ProductViewData] = []
    var userViewData: UserViewData = UserViewData()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        setUpBottomView()
        setUpImage()
        setUpTableView()
        fetchProducts()
        setUpMoveToBinButton()
        userViewData.balance = user?.balance ?? 0
        setUpResetButton()
        setUpBottomLabels()
    }
    
    @objc func resetData() {
        for product in userViewData.products {
            if let index = userViewData.products.firstIndex(where: {$0.id == product.id}) {
                userViewData.products[index].selectedItems = 0
            }
        }
        
        for category in products {
            for product in category.products {
                if let index = userViewData.products.firstIndex(where: {$0.id == product.id}) {
                    userViewData.products[index].selectedItems = 0
                }
            }
        }
        
        priceLabel.text = "$0"
        quantityLabel.text = "0x"
        tableView.reloadData()
    }
    
    private func fetchProducts() {
        Task {
            let result = await networking.fetch()
            await MainActor.run {
                switch result {
                case .success(let containerData):
                    self.products = convertToProductViewData(products: containerData.products)
                  // let aproducts = containerData.toViewData()
                    tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func convertToProductViewData(products: [Product]) -> [ProductViewData] {
        // Create a dictionary to group products by category
        var categoryProductsDict = [String: [Product]]()

        for product in products {
            if var categoryProducts = categoryProductsDict[product.category] {
                categoryProducts.append(product)
                categoryProductsDict[product.category] = categoryProducts
            } else {
                categoryProductsDict[product.category] = [product]
            }
        }

        // Create ProductViewData instances from the dictionary
        var productViewDataArray = [ProductViewData]()
        for (category, products) in categoryProductsDict {
            var productsViewDataArray: [ProductsItemViewData] = []
            for product in products {
                productsViewDataArray.append(ProductsItemViewData(id: product.id, brand: product.brand, title: product.title, category: product.category, stock: product.stock, price: product.price, images: product.images))
            }
            let productViewData = ProductViewData(category: category, products: productsViewDataArray)
            productViewDataArray.append(productViewData)
        }

        return productViewDataArray
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource, ProductTableViewCellDelegate {
    func didTapCell(selectedItems: Int, productId: Int) {
        var totalSelected = 0
        var totalPrice = 0
        for (index, value) in products.enumerated() {
            if let internalIndex = value.products.firstIndex(where: {$0.id == productId}) {
                var currentProduct = products[index].products[internalIndex]
                products[index].products[internalIndex].selectedItems = selectedItems
                
                if let userIndex = userViewData.products.firstIndex(where: {$0.id == currentProduct.id}) {
                    if selectedItems != 0 {
                        print("Sele: \(selectedItems)")
                        userViewData.products[userIndex].selectedItems = selectedItems
                    } else {
                        userViewData.products.removeAll(where: {$0.id == currentProduct.id})
                    }
                } else {
                    if selectedItems != 0 {
                        userViewData.products.append(products[index].products[internalIndex])
                    }
                }
            }
        }
      
        for product in userViewData.products {
            totalSelected += product.selectedItems
            totalPrice += product.selectedItems * product.price
        }
        quantityLabel.text = "\(totalSelected)x"
        priceLabel.text = "$\(totalPrice)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        products.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products[section].products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        let product = products[indexPath.section].products[indexPath.row]
        cell.id = product.id
        cell.brandNameLabel.text = product.brand
        cell.productImageView.imageFromServerURL(urlString: product.images.first ?? "", defaultImage: "placeholder_image")
        cell.quantityLabel.text = "stock: \(product.stock)"
        cell.priceLabel.text = "price: \(product.price)"
        cell.selectedLabel.text = "\(product.selectedItems)"
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = products[section]
        let sectionLabel = UILabel()
        sectionLabel.text = category.category
        sectionLabel.font = .systemFont(ofSize: 14, weight: .bold)
        return sectionLabel
    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the height of the cell plus the desired vertical spacing
        return 140 + 10 // Adjust the value of 10 based on your preference
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
}

extension ProductsViewController {
    func setUpBottomLabels() {
        view.addSubview(priceLabel)
        view.addSubview(quantityLabel)
        quantityLabel.text = "0x"
        quantityLabel.textColor = .white
        priceLabel.text = "$0"
        priceLabel.textColor = .white
        quantityLabel.font = .systemFont(ofSize: 15, weight: .bold)
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityLabel.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 20),
            quantityLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
        ])
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 2),
        ])
        
    }
    
    func setUpResetButton() {
        resetButton.setImage(UIImage(systemName: "trash"), for: .normal)
        resetButton.tintColor = .white
        view.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetData), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 30),
            resetButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setUpMoveToBinButton() {
        self.view.addSubview(moveToBinButton)
        
        moveToBinButton.setTitle("კალათაში გადასვლა >", for: .normal)
        moveToBinButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        moveToBinButton.titleLabel?.textColor = .white
        moveToBinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moveToBinButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            moveToBinButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            moveToBinButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setUpBottomView() {
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .systemBlue
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setUpTableView() {
     
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
       // tableView.rowHeight = 150

        
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
       // tableView.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
    //tableView.frame = view.bounds
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    
    func setUpImage() {
        
        let imageName = "logo_image"
        let image = UIImage(named: imageName)
        self.imageView.image = image
       // imageView.frame = CGRect(x: 0, y: 0, width: 220, height: 150)
        self.view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

}




extension UIImageView {
public func imageFromServerURL(urlString: String, defaultImage : String?) {
    if let di = defaultImage {
        self.image = UIImage(named: di)
    }

    URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

        if error != nil {
            print(error ?? "error")
            return
        }
        DispatchQueue.main.async(execute: { () -> Void in
            let image = UIImage(data: data!)
            self.image = image
        })

    }).resume()
  }
}
