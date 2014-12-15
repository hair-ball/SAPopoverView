//
//  ViewController.m
//  SAPopoverDemo
//
//  Created by sagles on 14/12/15.
//  Copyright (c) 2014年 SA. All rights reserved.
//

#import "ViewController.h"
#import "SAPopoverView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 250.f) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    SAPopoverView *popoverView = [SAPopoverView popoverViewWithView:tableView];
    popoverView.innerPadding = 10.f;
    popoverView.cornerRadio = 5.f;
    popoverView.controlPadding = 10.f;
    [popoverView showWithView:sender];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row %d",indexPath.row);
    [tableView.popoverView dismissPopoverView:YES];
}

@end
