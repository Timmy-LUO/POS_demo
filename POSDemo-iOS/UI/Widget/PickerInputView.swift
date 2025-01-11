//
//  DailyBellePickerInputView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/14.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture
import RxRelay
import RxCocoa

public protocol PickerViewModel {
    var _id: String { get }
    var _title: String { get }
}

public final class PickerInputView<T : PickerViewModel>: UIView, PickerViewControllerDelegate {
    
    public typealias ModelType = T
    
    public enum Border {
        case black
        case pink
        case grey
    }
    
    private var border: Border!
    private var title: String?
    private var titleWidth: CGFloat?
    private var textFieldWidth: CGFloat?
    private var isNotEditable = true
    private var pickerTitle: String!
    private var isLeft = false
    private let bag = DisposeBag()
    
    public weak var delegate: PickerViewControllerDelegate? {
        didSet {
            pickerViewController.delegate = delegate
        }
    }
    
    public var content: String {
        get { textField.text ?? "" }
        set {
            textField.text = newValue
            textField.sendActions(for: .valueChanged)
        }
    }
    
    public var textFieldContentRelay: ControlProperty<String> {
        textField.rx.text.orEmpty
    }
    
    public var placeholder: String? {
        didSet { textField.placeholder = placeholder }
    }
    
    public var isEmptyObservable: Observable<Bool> {
        textField.isEmptyObservable
    }
    
    public var contentRelay = BehaviorRelay<ModelType?>(value: nil)
    public var selectedItem: T? { contentRelay.value }
    public var dataList = [T]()
    
    public convenience init(
        border: Border,
        title: String? = nil,
        titleWidth: CGFloat? = nil,
        textFieldWidth: CGFloat? = nil,
        isNotEditable: Bool = true,
        pickerTitle: String,
        isLeft: Bool = false
    ) {
        self.init(frame: .zero)
        self.border = border
        self.title = title
        self.titleWidth = titleWidth
        self.textFieldWidth = textFieldWidth
        self.isNotEditable = isNotEditable
        self.pickerTitle = pickerTitle
        self.isLeft = isLeft
        commonInit()
    }
    
    public func setData(list: [T], emitFirst: Bool) {
        dataList = list
        pickerViewController.setData(list: list)
        if emitFirst, let first = list.first {
            content = first._title
            contentRelay.accept(first)
        }
    }
    
    public func select(id: String) {
        pickerViewController.select(id: id)
    }
    
    public func pickerViewController<ModelType>(
        _ vc: PickerViewController<ModelType>,
        selectedIndex: Int,
        selectedItem: ModelType
    ) where ModelType: PickerViewModel {
        content = selectedItem._title
        contentRelay.accept(selectedItem as? T)
    }
    
    public func noSelection<ModelType>(_ vc: PickerViewController<ModelType>) {
        textField.text = contentRelay.value?._title
    }
    
    public func movePosition() {
        pickerViewController.move()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        if let title = title {
            titleLabel.setPink20(text: title)
        }
        imageView.image = "ic_picker_arrow_down".image
        
        if !isNotEditable {
            textField.rx
                .text
                .orEmpty
                .subscribe(onNext: { [weak self] text in
                    self?.pickerViewController.filter(text)
                })
                .disposed(by: bag)
        }
        
        if isNotEditable {
            textFieldCoverView.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.pickerViewController.show()
                })
                .disposed(by: bag)
        } else {
            textField.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.pickerViewController.show()
                    if let textField = self?.textField {
                        let newPosition = textField.endOfDocument
                        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                        textField.becomeFirstResponder()
                    }
                })
                .disposed(by: bag)
        }
        
        if border == .pink {
            textField.layer.borderColor = "bg_pink".color.cgColor
        } else if border == .grey {
            textField.layer.borderColor = "text_grey_light".color.cgColor
            textField.layer.borderWidth = 1
        }
        
        pickerViewController.delegate = self
        pickerViewController.baseView = textField
    }
    
    private func setupLayout() {
        if let titleWidth = titleWidth {
            self.addSubview(titleLabel) { make in
                make.width.equalTo(titleWidth)
                make.leading.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            self.addSubview(textField) { make in
                if let width = textFieldWidth {
                    make.width.equalTo(width)
                }
                make.leading.equalTo(titleLabel.snp.trailing)
                make.top.trailing.bottom.equalToSuperview()
            }
        } else {
            self.addSubview(textField) { make in
                make.edges.equalToSuperview()
            }
        }
        
        if isNotEditable {
            self.addSubview(textFieldCoverView) { make in
                make.edges.equalTo(textField)
            }
        }
        
        self.addSubview(imageView) { make in
            make.width.equalTo(12)
            make.height.equalTo(6)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(textField.snp.trailing).offset(-14)
        }
    }
    
    public let titleLabel = UILabel()
    private let textFieldCoverView = UIView()
    private let textField = POSDemoTextField()
    private let imageView = UIImageView()
    private lazy var pickerViewController = PickerViewController<ModelType>(title: pickerTitle, isLeft: isLeft)
}
