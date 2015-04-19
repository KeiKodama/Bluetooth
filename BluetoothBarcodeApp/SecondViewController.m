//
//  SecondViewController.m
//  BluetoothBarcodeApp
//
//  Created by kodamakei on 2015/04/15.
//  Copyright (c) 2015年 kccs. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomView.h"

@interface SecondViewController () {
    int count;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButton:(id)sender {
    count++;
    CustomView *customView = [[CustomView alloc] init];
    customView.frame = CGRectMake(10,100*count,100,100);
    customView.backgroundImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:customView];
    
}

@end
