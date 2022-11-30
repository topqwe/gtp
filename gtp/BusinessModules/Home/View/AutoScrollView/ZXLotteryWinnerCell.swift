

import UIKit

class ZXLotteryWinnerCell:UITableViewCell {
    // !!!:- just_dequeueReusableCell 不能用了/只能用传统的或class cellWithTableView
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 13)
         return btn
     }()
    
    
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.clear.cgColor)
        context!.fill(rect)
        //上分割线，
        //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
        //下分割线
        //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        context!.setStrokeColor(UIColor.clear.cgColor)
        context?.stroke(CGRect(x: 10, y: rect.size.height-0.5, width: rect.size.width - 10, height: 1))
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear;
        self.contentView.backgroundColor = .clear
        
        selectionStyle = .none
        
        setUp()
    }
  
    func configure(_ item: NSAttributedString, _ indexPath: IndexPath) {
//        self.delegate = delegate
        
        btn.isUserInteractionEnabled = false
//        btn.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: "defaultphoto"), options: nil, progressBlock: nil)//delegate.imageUrl
        //URL.init(string: "")
//        btn.setImage(UIImage.init(named: item.keys.first!), for: .normal)
        
        btn.setAttributedTitle(item, for: .normal)
        btn.backgroundColor = .clear;
        btn.contentHorizontalAlignment = .left
       
        if (indexPath.row%2 == 0) {//奇数
            btn.backgroundColor = UIColor.systemBlue;
        }else{
            btn.backgroundColor = UIColor.systemOrange;
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWith(_ tabelView:UITableView) -> UITableViewCell {
        var cell:UITableViewCell? = tabelView.dequeueReusableCell(withIdentifier: "ZXLotteryWinnerCell")
        if cell == nil {
            cell = ZXLotteryWinnerCell.init(style: .default, reuseIdentifier: "ZXLotteryWinnerCell")
        }
        return cell!
    }
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 25
    }
}
extension ZXLotteryWinnerCell{
    fileprivate func setUp() {
        self.contentView.addSubview(btn)
        
        setLayout()
    }
    private func setLayout() {
        btn.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width-0.0, height: 25.0)
        
    }

}


