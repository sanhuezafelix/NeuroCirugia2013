//
//  mNotificacionesViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mNotificacionesViewController.h"
#import "Notificacion.h"
#import "mAppDelegate.h"


@interface mNotificacionesViewController ()

@property (nonatomic, assign) CGFloat peekLeftAmount;
@property (nonatomic,strong) mAppDelegate *delegue;
@end

@implementation mNotificacionesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 100.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    _delegue = [[UIApplication sharedApplication] delegate];
    [self llamarNotifi];
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

-(void)llamarNotifi{

    NSError*error;
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Notificacion" inManagedObjectContext:_delegue.managedObjectContext];
    NSFetchRequest *fetiche = [[NSFetchRequest alloc] init];
    [fetiche setEntity:entidad];
    _arrayNotificaciones = [_delegue.managedObjectContext executeFetchRequest:fetiche error:&error];    
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
 
    return [_arrayNotificaciones count];
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

    Notificacion *noti = [_arrayNotificaciones objectAtIndex:indexPath.row];
    
    cell.Contenido.text = noti.contenidoNoti;
        
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

        if ([_arrayNotificaciones count]>0) {
        NSLog(@"hay notis");
    
            [self refresh];
}}];
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

    [self llamarNotifi];
    [self.PushTableview reloadData];
    [self.refresh endRefreshing];
    
}

- (void)viewDidUnload {
    [self setPushTableview:nil];
    [super viewDidUnload];
}
@end
