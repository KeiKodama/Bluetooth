//
//  DetailViewController.m
//  test1
//
//  Created by kodamakei on 2015/04/15.
//  Copyright (c) 2015年 kccs. All rights reserved.
//

#import "DetailViewController.h"
#import "FMDatabase.h"
#import "MasterViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *barcodeField;
@property (weak, nonatomic) IBOutlet UITextField *itemField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
    
    [self createDb];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createItemInfo:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (FMDatabase *) getDbObject {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *db_path = [dir stringByAppendingPathComponent:@"barcode.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:db_path];
    return db;
}

- (void) createDb {
    FMDatabase *db = [self getDbObject];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS barcodedb (barcode TEXT PRIMARY KEY, item TEXT, price INTEGER);";
    [db open];
    [db executeUpdate:sql];
    [db close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createItemInfo:(id)sender {
    
    NSString *barcode = self.barcodeField.text;
    NSString *item = self.itemField.text;
    NSString *price = self.priceField.text;
    
    if (0 == barcode.length || 0 == item.length || 0 == price.length) {
        [self showAlert];
        return;
    }
    
    [self insertItemInfoWithBarcode:barcode item:item price:price];
    MasterViewController *controller = [self.navigationController.viewControllers objectAtIndex:0];
    [controller addItemToTable:item];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert {
    UIAlertView* alert = [[UIAlertView alloc]
                         initWithTitle:@"エラー"
                         message:@"未入力の項目があります"
                         delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK",
                         nil];
    [alert show];
}

- (void)insertItemInfoWithBarcode:(NSString *)barcode item:(NSString *)item price:(NSString *)price {
    NSString *sql = @"INSERT INTO barcodedb (barcode, item, price) values (?, ?, ?)";
    FMDatabase *db = [self getDbObject];
    [db open];
    [db executeUpdate:sql, barcode, item, price];
    [db close];
}

@end
