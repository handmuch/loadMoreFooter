//
//  ViewController.m
//  loadMoreFooter
//
//  Created by POWER on 14/10/27.
//  Copyright (c) 2014年 ditaon. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initMainView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initMainView
{
    UIButton *pushButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 100, 320-80, 40)];
    pushButton.backgroundColor = [UIColor clearColor];
    [pushButton setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushToController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushButton];
}

- (void)pushToController
{
    [self.navigationController pushViewController:[[TableViewController alloc]initWithStyle:UITableViewStylePlain] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
