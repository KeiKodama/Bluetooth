//
//  DetailViewController.h
//  test1
//
//  Created by kodamakei on 2015/04/15.
//  Copyright (c) 2015年 kccs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

