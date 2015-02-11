//
//  TableViewController.m
//  loadMoreFooter
//
//  Created by POWER on 14/12/3.
//  Copyright (c) 2014年 ditaon. All rights reserved.
//

#import "TableViewController.h"

#import "couponLIstViewCell.h"

#define TEST_URL_HEAD @"http://203.195.192.178:81/"
#define TEST_URL_IMAGE_HEAD @"http://203.195.192.178:9010/images/"

#define APP_KEY @"IOS_KCOUPON"

#define HOTCOUPON_URL @"issue/phone/api/listHotCoupon.a"
#define GOODCOUPON_URL @"issue/phone/api/listPreferentialCoupon.a"
#define NEWCOUPON_URL @"issue/phone/api/listNewCoupon.a"
#define NEAR_COUPON_URL @"issue/phone/api/listNearbyCoupon.a"

@interface TableViewController (){
    
    NSMutableArray *couponIdArray;
    NSMutableArray *logUrlArray;
    NSMutableArray *picUrlArray;
    NSMutableArray *nameArray;
    NSMutableArray *typeArray;
    NSMutableArray *faceValueArray;
    NSMutableArray *introduceArray;
    NSMutableArray *estimateAmountArray;
    NSMutableArray *discountArray;
    NSMutableArray *debitAmountArray;
    
    LoadFooterView *footerView;
    
    BOOL isLoadMoreing;
    BOOL isEditor;
    
    int dataRow;
    
}

@end

@implementation TableViewController

- (void)setRightItemButton
{
    UIBarButtonItem *editorButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = editorButtonItem;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setRightItemButton];
    
    dataRow = 0;
    
}

- (void)getDataWithPage:(int)Page
{
    dataRow++;
    
    NSURL *kouponUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@issue/phone/api/listHotCoupon.a?pageSize=20&currentPage=%d",TEST_URL_HEAD,dataRow]];
    
    NSURLRequest *kouponRequest = [NSURLRequest requestWithURL:kouponUrl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:kouponRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        
        if([msg isEqualToString:@"success"]) {
            
            //根据加载次数决定是否刷新券的数据数组
            
            if (dataRow == 1)
            {
                couponIdArray = [[NSMutableArray alloc]initWithCapacity:0];
                logUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
                picUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
                nameArray = [[NSMutableArray alloc]initWithCapacity:0];
                typeArray = [[NSMutableArray alloc]initWithCapacity:0];
                introduceArray = [[NSMutableArray alloc]initWithCapacity:0];
                faceValueArray = [[NSMutableArray alloc]initWithCapacity:0];
                estimateAmountArray = [[NSMutableArray alloc]initWithCapacity:0];
                discountArray = [[NSMutableArray alloc]initWithCapacity:0];
                debitAmountArray = [[NSMutableArray alloc]initWithCapacity:0];
            }
            
            NSMutableArray *objListArray = [responseObject objectForKey:@"objList"];
            
            isLoadMoreing = NO;
            
            if(objListArray.count > 0) {
                
                for (int i = 0; i < objListArray.count; i++) {
                    
                    [couponIdArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"id"]];
                    [typeArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"type"]];
                    [nameArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"name"]];
                    [logUrlArray addObject:[NSString stringWithFormat:@"%@%@",TEST_URL_IMAGE_HEAD,[[objListArray objectAtIndex:i]objectForKey:@"logoUrl"]]];
                    [picUrlArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"picUrl"]];
                    [introduceArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"introduce"]];
                    [faceValueArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"faceValue"]];
                    [estimateAmountArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"estimateAmount"]];
                    [discountArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"discount"]];
                    [debitAmountArray addObject:[[objListArray objectAtIndex:i]objectForKey:@"debitAmount"]];
                    
                }
                
                [self.tableView reloadData];
                
                if (!footerView) {
                    
                    footerView = [[LoadFooterView alloc]initFooterViewWithFream:CGRectMake(0, 0, 320, 60)];
                }
                
                [footerView setLoadingFinishedWith:isLoadMoreing AndLoading:@"正在努力加载中..." AndFinished:@"上拉加载更多..."];
                
            } else {
                
                [footerView setWithNoMoreData];
            }
            
            self.tableView.tableFooterView = footerView;
            
        } else {
            
            UIAlertView *failAlertView = [[UIAlertView alloc]initWithTitle:@"出错了~" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [failAlertView show];
            
        }
        
        //网络请求失败
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return couponIdArray.count;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"status_%d",indexPath.section];
    
    couponLIstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[couponLIstViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    NSArray *picArray = [[picUrlArray objectAtIndex:indexPath.row] componentsSeparatedByString:@";"];
    
    //券的的图片
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TEST_URL_IMAGE_HEAD,[picArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
    
    //券的名称
    cell.titleLabel.text = [nameArray objectAtIndex:indexPath.row];
    
    //券的介绍
    cell.introduceLabel.text = [introduceArray objectAtIndex:indexPath.row];
    //暂不需要
    
    //券的类型logo
    UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(85-23, 75-23, 23, 23)];
    
    //券的类型
    NSString *couponTypeStr = [NSString stringWithFormat:@"%@",[typeArray objectAtIndex:indexPath.row]];
    //券的折扣
    NSString *discountStr = [NSString stringWithFormat:@"%@",[discountArray objectAtIndex:indexPath.row]];
    
    //根据couponTypeStr对不同的
    switch ([couponTypeStr intValue]) {
        case 0:
        {
            
            //销售价格
            typeImageView.image = [UIImage imageNamed:@"coupon_type_0.png"];
            
            NSString *estimateStr = [[NSString alloc]init];
            
            estimateStr = [NSString stringWithFormat:@"%@元",[estimateAmountArray objectAtIndex:indexPath.row]];
            
            NSMutableAttributedString *estimateAmountStr = [[NSMutableAttributedString alloc]initWithString:estimateStr];
            
            [estimateAmountStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, estimateStr.length)];
            [estimateAmountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.0f] range:NSMakeRange(0, estimateStr.length)];
            
            cell.valueLabel.attributedText = estimateAmountStr;
            
            //原价
            float estimateStrLength = [self widthOfString:estimateStr withFont:[UIFont systemFontOfSize:19.0f]];
            
            NSString *faceStr = [NSString stringWithFormat:@"%@元",[faceValueArray objectAtIndex:indexPath.row]];
            
            NSMutableAttributedString *faceValueStr = [[NSMutableAttributedString alloc]initWithString:faceStr];
            
            [faceValueStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:NSMakeRange(0, faceStr.length)];
            
            cell.cutValueLabel.frame = CGRectMake(105+estimateStrLength+5, 69, 50, 20);
            cell.cutValueLabel.attributedText = faceValueStr;
            
        }
            break;
        case 1:
        {
            if ([discountStr intValue] > 0) {
                
                NSString *countValueStr = [NSString stringWithFormat:@"直享%d折优惠",[[discountArray objectAtIndex:indexPath.row]intValue]/10];
                
                cell.valueLabel.textColor = [UIColor grayColor];
                cell.valueLabel.font = [UIFont systemFontOfSize:12.0f];
                
                NSMutableAttributedString *countValueAtr = [[NSMutableAttributedString alloc]initWithString:countValueStr];
                
                [countValueAtr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, 2)];
                [countValueAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.0f] range:NSMakeRange(2, 2)];
                
                typeImageView.image = [UIImage imageNamed:@"coupon_type_1.png"];
                
                cell.valueLabel.attributedText = countValueAtr;
                
                cell.cutValueLabel.text = @"";
                
            } else {
                
                NSString *debitValueStr = [NSString stringWithFormat:@"%@元",[debitAmountArray objectAtIndex:indexPath.row]];
                
                NSMutableAttributedString *debitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抵用%@",debitValueStr]];
                
                [debitStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, debitValueStr.length)];
                [debitStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.0f] range:NSMakeRange(2, debitValueStr.length)];
                
                typeImageView.image = [UIImage imageNamed:@"coupon_type_2.png"];
                
                cell.valueLabel.attributedText = debitStr;
                
                cell.cutValueLabel.text = @"";
            }
        }
            break;
        default:
            break;
    }
    
    [cell.logoImageView addSubview:typeImageView];
    
    // Configure the cell...
    
    return cell;
}

//获取字节长度
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isLoadMoreing) {
        //way-1
        CGPoint contentOffsetPoint = self.tableView.contentOffset;
        CGRect frame = self.tableView.frame;
        
        if (contentOffsetPoint.y == self.tableView.contentSize.height - frame.size.height || self.tableView.contentSize.height < frame.size.height)
        {
            NSLog(@"scroll to the end");
            
            isLoadMoreing = YES;
            [footerView setLoadingFinishedWith:isLoadMoreing AndLoading:@"正在努力加载中..." AndFinished:@"上拉加载更多..."];
            
            [self getDataWithPage:dataRow];
            
        }
    }
    
    //way-2
    /*
     CGPoint offset = self.tableView.contentOffset;
     CGRect bounds = dataTableView.bounds;
     CGSize size = dataTableView.contentSize;
     UIEdgeInsets inset = dataTableView.contentInset;w
     float y = offset.y + bounds.size.height - inset.bottom;
     float h = size.height;
     
     float reload_distance = 10;
     
     if(y > h + reload_distance) {
     
     NSLog(@"load more rows");
     }*/
}

- (void)editorButtonClick:(UIButton *)sender
{
    NSLog(@"editor");
    
    if (!isEditor) {
        
        [self.tableView setEditing:YES animated:YES];
        
        isEditor = YES;
        
    } else {
        
        [self.tableView setEditing:NO animated:YES];
        
        isEditor = NO;
    }
    
}

/*
 - (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
 
 [self deleteCouponFormCart:[couponIdArray objectAtIndex:indexPath.row]];
 
 [couponIdArray removeObjectAtIndex:indexPath.row];
 
 //        [couponCountArray removeObjectAtIndex:indexPath.row];
 //        [couponEstimateAmountArray removeObjectAtIndex:indexPath.row];
 
 [orderIdArray removeObjectAtIndex:indexPath.row];
 
 [orderTagArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
 
 selectCount = [self setCountWithOrderArray:orderTagArray And:indexPath.row];
 totalCount = [self setTotalWtihOrderArray:orderTagArray And:indexPath.row];
 
 [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
 totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
 
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 
 
 }];
 
 return @[deleteAction];
 }
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 
 - (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
 
 return @"删除";
 }*/

//>>>>>>>>>>>>>>>>>>>>> 系统原生方法 <<<<<<<<<<<<<<<<<<<<<<<<<<//

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
