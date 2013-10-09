//
//  mNotificacionesViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mNotificacionesViewController.h"

@interface mNotificacionesViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;

@end

@implementation mNotificacionesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 100.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    //self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.PushTableview delegate:self];
    //self.pullToRefreshView.contentView = [[SSPullToRefreshSimpleContentView alloc]init];
    self.ResultadosNotificaciones = [[NSMutableArray alloc]initWithContentsOfFile:[self Ruta]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    
    [self.PushTableview addSubview:refresh];
    
    self.refresh = refresh;
}

#pragma -mark Tableview datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Notificaciones";
}

-(void)viewWillAppear:(BOOL)animated{
   
    [self refresh];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *ColorSelecion = [[UIView alloc] init];
    
       ColorSelecion.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"label_notificaciones"]];
       
    return ColorSelecion;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.ResultadosNotificaciones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PushCell";
    mMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[mMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
      UIView *ColorSelecion = [[UIView alloc] init];
    ColorSelecion.backgroundColor = [UIColor colorWithRed:(189/255.0) green:(189/255.0) blue:(189/255.0) alpha:1.0f];
    cell.selectedBackgroundView = ColorSelecion;
    
    NSMutableArray* reversedArray = [[NSMutableArray alloc] initWithArray:[[[[NSArray alloc] initWithArray: self.ResultadosNotificaciones] reverseObjectEnumerator] allObjects]];
        
    cell.Contenido.text = [reversedArray objectAtIndex:indexPath.row];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
       return 73.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.slidingViewController anchorTopViewOffScreenTo:100 animations:nil onComplete:^{
    [self.slidingViewController resetTopView];

        if ([[NSFileManager defaultManager]fileExistsAtPath:[self Ruta]] == TRUE) {
        NSLog(@"existe ruta actualizando");
    
            [self refresh];
}}];
}

-(NSString *)Ruta{
    NSString * PathFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [PathFolder stringByAppendingPathExtension:@"Notificaciones.plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)beginRefreshing {
    [self refresh];
    [self.PushTableview reloadData];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    
    [self.ResultadosNotificaciones removeAllObjects];
    NSArray *datos = [[NSArray alloc]initWithContentsOfFile:[self Ruta]];
    [self.ResultadosNotificaciones addObjectsFromArray:datos];
    [self.PushTableview reloadData];
    
    [self.refresh endRefreshing];
    
}

//
//- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view{
//  
//    return YES;
//}
//
//- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view{
//    
//    [self refresh];
//}
//
//- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view{
//}

//- (void)refresh {
//    
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_after(popTime, backgroundQueue, ^(void){
//        if ([[NSFileManager defaultManager]fileExistsAtPath:[self Ruta]] == TRUE) {
//            NSLog(@"existe ruta actualizando pull");
//            [self.ResultadosNotificaciones removeAllObjects];
//            NSArray *datos = [[NSArray alloc]initWithContentsOfFile:[self Ruta]];
//            [self.ResultadosNotificaciones addObjectsFromArray:datos];
//    }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.PushTableview reloadData];
//            [self.refresh endRefreshing]];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//});
//});
//}

//-(void)actualizar{
//    
//    [self.ResultadosNotificaciones removeAllObjects];
//    NSArray *datos = [[NSArray alloc]initWithContentsOfFile:[self Ruta]];
//    [self.ResultadosNotificaciones addObjectsFromArray:datos];
//    [self.PushTableview reloadData];
//
//}

- (void)viewDidUnload {
    [self setPushTableview:nil];
    [super viewDidUnload];
}
@end
