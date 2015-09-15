//
//  ViewController.m
//  LetoApp
//
//  Created by Jake Holdom on 15/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
NSMutableArray *movies;
NSMutableDictionary *items;
NSXMLParser *RSSParse;
NSString *currentElement;
NSMutableString *movieTitle, *imgUrl;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
