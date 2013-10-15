//
//  mMenuLateralViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 06-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mMenuLateralViewController.h"
#import "GAI.h"
#import "Evento.h"
#import "mAppDelegate.h"

@interface mMenuLateralViewController ()

@end

@implementation mMenuLateralViewController
@synthesize IconoMenu , MenuItems;

#pragma -marks Inicialisacion

-(void)awakeFromNib
{
    self.IconoMenu   = [[NSArray alloc]initWithObjects:@"butonhome.png",@"ButtonJornada.png",@"ButtonSpeakers.png",@"ButtonBusqueda.png",@"ButtonMapa.png", @"buttonSopnia.png",@"ButtonAbout.png", nil];
                    
    self.MenuItems  = [[NSArray alloc]initWithObjects: @"Ahora",@"Jornada",@"Speaker",@"Busqueda",@"Mapas",@"Hazte Socio", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.slidingViewController setAnchorRightRevealAmount:205.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_side_1.png",@"publi_side_2.png",@"publi_side_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
}



#pragma mark Tableview Delegate y DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.MenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuCell";
    mMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[mMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.Titulo.text = [self.MenuItems objectAtIndex:indexPath.row];
    cell.IconoMenu.image = [UIImage imageNamed:[self.IconoMenu objectAtIndex:indexPath.row]];
    UIView *ColorSelecion = [[UIView alloc] init];
    ColorSelecion.backgroundColor = [UIColor colorWithRed:(189/255.0) green:(189/255.0) blue:(189/255.0) alpha:1.0f];
    cell.selectedBackgroundView = ColorSelecion;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.MenuItems objectAtIndex:indexPath.row]];
    NSString *label = [[NSString alloc]initWithFormat:@"Tap Opcion %@",identifier];
    id trackingMenu = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    
    [trackingMenu sendEventWithCategory:@"uiAction"
                             withAction:@"Tap Menu Lateral"
                              withLabel:label
                              withValue:nil];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:205.0f animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end

