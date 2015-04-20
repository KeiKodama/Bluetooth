//
//  SecondViewController.m
//  BluetoothBarcodeApp
//
//  Created by kodamakei on 2015/04/15.
//  Copyright (c) 2015年 kccs. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomView.h"
#import "FMDatabase.h"

@interface SecondViewController () {
    int count;
}
@property (nonatomic) NSArray *commands;
@property (nonatomic) NSString *barcode;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addInputComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray *)keyCommands {
    if (!self.commands) {
        NSMutableArray *commands = [[NSMutableArray alloc] init];
        NSArray *characterSets = @[[NSCharacterSet characterSetWithRange:NSMakeRange(0x20, 0x7f-0x20)],
                                   [NSCharacterSet newlineCharacterSet]];
        for (unichar i=0x00; i<0x7f; i++) {
            for (NSCharacterSet *characterSet in characterSets) {
                if ([characterSet characterIsMember:i]) {
                    NSString *string = [[NSString alloc] initWithCharacters:&i length:1];
                    UIKeyCommand *command = [UIKeyCommand keyCommandWithInput:string
                                                                modifierFlags:kNilOptions
                                                                       action:@selector(handleCommand:)];
                    [commands addObject:command];
                    break;
                }
            }
        }
        
        self.commands = commands;
    }
    return self.commands;
}

- (void)handleCommand:(UIKeyCommand *)command {
    
    NSString *key = command.input;
    NSCharacterSet *newlineCharacterSet = [NSCharacterSet newlineCharacterSet];
    if ([key rangeOfCharacterFromSet:newlineCharacterSet].location != NSNotFound) {
        if (self.barcode != nil || self.barcode.length > 0) {
            [self loadBarcodeInfo:self.barcode];
            [self addInputComponent];
        }
        self.barcode = nil;
    } else {
        if (self.barcode) {
            self.barcode = [self.barcode stringByAppendingString:key];
        } else {
            self.barcode = key;
        }
    }
}

- (void)addInputComponent {
    count++;
    CustomView *customView = [[CustomView alloc] init];
    customView.frame = CGRectMake(0, 20+60*count, 600, 60);
    customView.tag = count;
    [self.view addSubview:customView];
}

- (FMDatabase *)getDbObject {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *db_path = [dir stringByAppendingPathComponent:@"barcode.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:db_path];
    return db;
}

- (void)loadBarcodeInfo:(NSString *)barcode {
    NSString *item;
    NSString *code;
    NSString *price;
    NSString *sql = @"select * from barcodedb where barcode = ?";
    
    FMDatabase *db = [self getDbObject];
    [db open];
    FMResultSet *rs = [db executeQuery:sql, barcode];
    while ([rs next]) {
        item = [rs stringForColumn:@"item"];
        code = [rs stringForColumn:@"barcode"];
        price = [rs stringForColumn:@"price"];
    }
    [db close];
    
    if (item == nil || code == nil || price == nil) {
        return;
    }
    
    UIView *view = [self.view viewWithTag:count];
    CustomView *cv = (CustomView *)view;
    cv.barcodeField.text = code;
    cv.itemField.text = item;
    cv.priceField.text = price;
    cv.countField.text = @"1";
    NSInteger sum = (cv.priceField.text.integerValue) * (cv.countField.text.integerValue);
    cv.sumField.text = [NSString stringWithFormat:@"%d", sum];
}

@end
