//
//  ProductTableViewCell.swift
//  FinalProjectTatia
//
//  Created by Tatia on 18.01.24.
//

import Foundation
import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func didTapCell(selectedItems: Int, productId: Int)
}

class ProductTableViewCell: UITableViewCell {
    var id: Int = 0
    var productImageView = UIImageView()
    var brandNameLabel: UILabel = UILabel()
    var quantityLabel = UILabel()
    var priceLabel = UILabel()
    var plusButton = UIButton()
    var selectedLabel = UILabel()
    var minusButton = UIButton()
    
    
    var selectedItems: Int = 0
    weak var delegate: ProductTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(productImageView)
        addSubview(brandNameLabel)
        addSubview(quantityLabel)
        addSubview(priceLabel)
        addSubview(plusButton)
        addSubview(selectedLabel)
        addSubview(minusButton)
        
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        brandNameLabel.frame = CGRect(x: 140, y: 20, width: 200, height: 40)
        productImageView.frame = CGRect(x: 10, y: layer.frame.height / 2, width: 115, height: 115)
        quantityLabel.frame = CGRect(x: 140, y: 50, width: 200, height: 40)
        priceLabel.frame = CGRect(x: 140, y: 80, width: 200, height: 40)
        plusButton.frame = CGRect(x: frame.width - 20, y: 100, width: 40, height: 40)
        selectedLabel.frame = CGRect(x: frame.width - 30, y: 100, width: 40, height: 40)
        minusButton.frame = CGRect(x: frame.width - 65, y: 100, width: 40, height: 40)
        
        selectedLabel.font = .systemFont(ofSize: 22, weight: .regular)
        selectedLabel.textColor = .systemBlue
        
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        minusButton.setTitleColor(.systemBlue, for: .normal)
        
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        plusButton.setTitleColor(.systemBlue, for: .normal)
        
        priceLabel.font = .systemFont(ofSize: 15, weight: .bold)
        quantityLabel.font = .systemFont(ofSize: 15, weight: .bold)
        brandNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        productImageView.layer.cornerRadius = 25
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .scaleToFill
        productImageView.layer.cornerRadius = 15
        
        layer.innerBorder()
        
      
//        layer.borderWidth = 1
       // layer.cornerRadius = 15
//        let borderColor: UIColor = .gray.withAlphaComponent(0.4)
//        layer.borderColor = borderColor.cgColor
//        
    }
    
    @objc func minusTapped(_ sender: Any) {
        print("Minus tapped")
        if selectedItems != 0 {
            selectedItems -= 1
        }
        selectedLabel.text = "\(selectedItems)"
        delegate?.didTapCell(selectedItems: selectedItems, productId: id)
    }
    
    
    @objc func plusTapped(_ sender: Any) {
        selectedItems += 1
        selectedLabel.text = "\(selectedItems)"
        delegate?.didTapCell(selectedItems: selectedItems, productId: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CALayer {


    func innerBorder(borderOffset: CGFloat = 140, borderColor: UIColor = UIColor.gray.withAlphaComponent(0.4), borderWidth: CGFloat = 1) {
        let innerBorder = CALayer()
        innerBorder.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width - 40, height: 140)
        innerBorder.borderColor = borderColor.cgColor
        innerBorder.borderWidth = borderWidth
        innerBorder.cornerRadius = 13
        innerBorder.name = "innerBorder"
        insertSublayer(innerBorder, at: 0)
    }
}
