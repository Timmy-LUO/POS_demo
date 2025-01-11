//
//  DailyBellePickerViewController..swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/17.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import RxGesture

public protocol PickerViewControllerDelegate: AnyObject {
    func pickerViewController<T>(_ vc: PickerViewController<T>, selectedIndex: Int, selectedItem: T)
    func noSelection<T>(_ vc: PickerViewController<T>)
}

public final class PickerViewController<T: PickerViewModel>: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var titleString: String!
    private var isLeft = false
    private var showSearch = false
    private var tmpList: [T]!
    private var itemList: [T]!
    private var sizeList: [CGFloat]!
    public weak var baseView: UIView!
    
    public weak var delegate: PickerViewControllerDelegate?
    public let contentRelay = PublishRelay<T>()
    
    private var isGenerated: Bool = false
    
    public init(title: String, isLeft: Bool, showSearch: Bool = false) {
        self.titleString = title
        self.isLeft = isLeft
        self.showSearch = showSearch
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseView.resignFirstResponder()
    }
    
    public func setData(list: [T]) {
        tmpList = list
        itemList = list
        pickerView.reloadAllComponents()
    }
    
    public func filter(_ text: String) {
        if text.isEmpty {
            itemList = tmpList
        } else {
            if tmpList?.isEmpty == false {
                if !text.isEmpty {
                    itemList = tmpList.filter { $0._title.contains(text) }
                } else {
                    itemList = tmpList
                }
            }
        }
        pickerView.reloadAllComponents()
    }
    
    public func move() {
        if isGenerated {
            if let base = baseView.superview?.convert(baseView.frame.origin, to: nil) {
                let offSet: CGFloat
                if isLeft {
                    offSet = -325 - 16 - 2
                } else {
                    offSet = baseView.frame.width + 16 + 2
                }
                let position = CGPoint(
                    x: (base.x + offSet),
                    y: (base.y + (baseView.frame.height / 2))
                )
                bgView.snp.updateConstraints { make in
                    make.centerY.equalTo(position.y)
                }
                triangleView.snp.updateConstraints { make in
                    make.centerY.equalTo(position.y)
                }
            }
        }
    }
    
    public func show() {
        if itemList?.isEmpty == false {
            Utils.topMostViewController()?.present(self, animated: true)
        }
    }
    
    public func select(id: String) {
        if let index = itemList.firstIndex(where: { $0._id == id }) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
            contentRelay.accept(itemList[index])
            delegate?.pickerViewController(self, selectedIndex: index, selectedItem: itemList[index])
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        itemList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        if let view = view {
            label = view as! UILabel
        } else {
            label = UILabel()
            label.snp.remakeConstraints { make in
                make.width.equalTo(pickerView.frame.width - 16)
            }
            label.font = .systemFont(ofSize: 22)
            label.textAlignment = .center
            label.autoFontSize()
        }
        label.text = itemList[row]._title
        return label
    }
    
    @objc
    private func onSelected() {
        let index = pickerView.selectedRow(inComponent: 0)
        let item = itemList[index]
        delegate?.pickerViewController(self, selectedIndex: index, selectedItem: item)
        contentRelay.accept(item)
        dismiss(animated: true)
    }
    
    private func setupUI() {
        bgView.clipsToBounds = false
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 14
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowRadius = 10
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let path = UIBezierPath()
        if isLeft {
            path.move(to: CGPoint(x: 16, y: 13))
            path.addLine(to: CGPoint(x: 0, y: 26))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 16, y: 13))
        } else {
            path.move(to: CGPoint(x: 16, y: 0))
            path.addLine(to: CGPoint(x: 16, y: 26))
            path.addLine(to: CGPoint(x: 0, y: 13))
            path.addLine(to: CGPoint(x: 16, y: 0))
        }
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.shadowOpacity = 0.3
        shape.shadowRadius = 4
        shape.shadowOffset = CGSize(width: 0, height: 0)
        triangleView.layer.addSublayer(shape)
        triangleView.clipsToBounds = false
        coverView.backgroundColor = .white
        
        label.setPink22(text: titleString)
        searchTextField.placeholder = "搜尋"
        
        button.setTitle("確認", for: .normal)
        button.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        view.backgroundColor = .clear
        view.rx
            .tapGesture { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            }
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    self.delegate?.noSelection(self)
                }
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        bgView.rx
            .tapGesture { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            }
            .when(.recognized)
            .subscribe()
            .disposed(by: disposeBag)
        
        if showSearch {
            searchTextField.rx
                .text
                .orEmpty
                .subscribe(with: self, onNext: { vc, text in
                    vc.filter(text)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setupLayout() {
        if let base = baseView.superview?.convert(baseView.frame.origin, to: nil) {
            
            let offSet: CGFloat
            if isLeft {
                offSet = -325 - 16 - 2
            } else {
                offSet = baseView.frame.width + 16 + 2
            }
            let position = CGPoint(
                x: (base.x + offSet),
                y: (base.y + (baseView.frame.height / 2))
            )
            
            view.addSubview(bgView) { make in
                make.width.equalTo(325)
                if showSearch {
                    make.height.equalTo(424)
                } else {
                    make.height.equalTo(375)
                }
                make.leading.equalTo(position.x)
                make.centerY.equalTo(position.y)
            }
            view.addSubview(triangleView) { make in
                make.width.equalTo(16)
                make.height.equalTo(26)
                if isLeft {
                    make.leading.equalTo(base.x - 16 - 2)
                } else {
                    make.leading.equalTo(position.x - 16)
                }
                make.centerY.equalTo(position.y)
            }
            view.addSubview(coverView) { make in
                make.width.equalTo(10)
                make.height.equalTo(triangleView)
                make.centerY.equalTo(bgView)
                if isLeft {
                    make.trailing.equalTo(bgView)
                } else {
                    make.leading.equalTo(bgView)
                }
            }
            
            bgView.addSubview(label) { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(24)
            }
            
            bgView.addSubview(button) { make in
                make.width.equalTo(96)
                make.height.equalTo(40)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-14)
            }
            
            if showSearch {
                bgView.addSubview(searchTextField) { make in
                    make.height.equalTo(38)
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().offset(-30)
                    make.top.equalTo(label.snp.bottom).offset(24)
                }
                
                bgView.addSubview(pickerView) { make in
                    make.leading.equalToSuperview().offset(14)
                    make.top.equalTo(searchTextField.snp.bottom).offset(24)
                    make.trailing.equalToSuperview().offset(-14)
                }
            } else {
                bgView.addSubview(pickerView) { make in
                    make.leading.equalToSuperview().offset(14)
                    make.top.equalTo(label.snp.bottom).offset(10)
                    make.trailing.equalToSuperview().offset(-14)
                }
            }
        }
        isGenerated = true
    }
    
    private let triangleView = UIView()
    private let coverView = UIView()
    private let bgView = UIView()
    private let label = UILabel()
    private let searchTextField = POSDemoTextField()
    private let pickerView = UIPickerView()
    private let button = SolidButton()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
