//
//  PaymentPopupVC.swift
//  Tosstra
//
//  Created by Eweb on 09/09/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class PaymentPopupVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collect: UICollectionView!
  @IBOutlet weak var pageCont: UIPageControl!
    
    var titlleArray = ["You can see the job offer.","You can see job details and Accept or Reject the job offer.","You can Start accepted job.","You can see the job direction.","You can Complete started job."]
    var timr=Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageCont.numberOfPages = self.titlleArray.count
        
        timr=Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollAutomatically), userInfo: nil, repeats: true)

        collect.register(UINib(nibName: "ScrollCollect", bundle: nil), forCellWithReuseIdentifier: "ScrollCollect")
    }
  @objc  func scrollAutomatically(_ timer1: Timer) {
        print(timer1)
        if let coll = collect {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < titlleArray.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
    }
    
    @IBAction func cancelAct(_ sender: UIButton)
    {
        self.timr.invalidate()
        self.view.removeFromSuperview()
    }
    @IBAction func continueAct(_ sender: UIButton)
    {
        self.timr.invalidate()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
    
        self.navigationController?.pushViewController(vc, animated: true)
       self.view.removeFromSuperview()
    }
    // MARK: -  colletionview scroll method

      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return titlleArray.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCollect", for: indexPath) as! ScrollCollect
          cell.textLbl.text = self.titlleArray[indexPath.row]
          return cell
          
      }
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: SCREENWIDTH-30, height: 113)
      }

       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
       {
           if scrollView == collect
           {
               pageCont?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           }
           
           
           
          
       }
       
       func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
       {
           if scrollView == collect
           {
               pageCont?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           }
          
       }
     
}
