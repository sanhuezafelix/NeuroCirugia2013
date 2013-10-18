//
//  mSpeakersViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mSpeakersViewController.h"
#import "mSpeakerCloseViewController.h"
#import "NSDataAdditions.h"
#import "GAI.h"
#import "Eventopadre.h"
#import "Persona.h"

@interface mSpeakersViewController ()
@property(nonatomic,strong)mAppDelegate *delegate;
@end

@implementation mSpeakersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     //trackenado GA
        
    id trackerSpeaker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerSpeaker sendView:@"Speaker"];
    

    UIImage *barButtonImage = [[UIImage imageNamed:@"btnmenu.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonMenu setBackgroundImage:barButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.title = @" ";
	self.delegate = [[UIApplication sharedApplication]delegate];
    [self filter:@""];
    
        UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   
    self.title = @" ";
    self.SpeakerTableview.scrollEnabled = YES;
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self              action:@selector(imageTapped:)];
    self.animationImageView.userInteractionEnabled = YES;
    [self.animationImageView addGestureRecognizer:tap];
    
    [self llamarPersonasEntrada];
}

-(void)llamarPersonasEntrada {

    NSError*erro;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Eventopadre" inManagedObjectContext:_delegate.managedObjectContext];
    NSPredicate *predicador = [NSPredicate predicateWithFormat:@"participantes.nombre.length >0"];
    [fetch setEntity:entidad];
    [fetch setPredicate:predicador];

    
    _arrayete = [_delegate.managedObjectContext executeFetchRequest:fetch error:&erro];

    NSLog(@"DATOS DE SALIDA DE LOS LA SARTA DE HEUAS QUE ESTAN EN PERSONAS ===== %@ ========= %lu",_arrayete,(unsigned long)_arrayete.count);
}

- (void )imageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    NSLog(@"tap imagen");
    id TokeImagenTracking = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [TokeImagenTracking sendEventWithCategory:@"uiAction"
                                   withAction:@"Tap Publicidad"
                                    withLabel:@"Tap Branding Principal"
                                    withValue:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma -mark Filtro Barra Busqueda

-(void)filter:(NSString*)text
{
    self.DysplayItems = [[NSMutableArray alloc] init];
    
    // Create our fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Define the entity we are looking for
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Persona" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Define how we want our entities to be sorted
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"nombre" ascending:YES];
    NSArray* NombreSpeaker = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:NombreSpeaker];
    // If we are searching for anything...
    
    NSPredicate *predicadoSpeaker = [NSPredicate predicateWithFormat:@"(nombre >%@) AND (nombre != %@)AND (nombre != %@)",@"",@"Almuerzo",@"Café"];
    [fetchRequest setPredicate:predicadoSpeaker];
    if(text.length > 0)
    {
        [ovController.view removeFromSuperview];
        
        self.SpeakerTableview.scrollEnabled = YES;
        
        NSPredicate *predicadoSpeaker = [NSPredicate predicateWithFormat:@"(nombre >%@) AND (nombre != %@)AND (nombre != %@)",@"",@"Almuerzo",@"Café"];
        
        [fetchRequest setPredicate:predicadoSpeaker];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((lugarDondeProvengo.pais CONTAINS[cd] %@) OR (nombre CONTAINS[cd] %@)OR (institucionQueMePatrocina.nombreInstitucion CONTAINS[cd] %@) OR (rol CONTAINS[cd] %@)) AND(nombre >%@)", text,text,text,text,@""];
        
      [fetchRequest setPredicate:predicate];
        searching = YES;
    }
    else
    {
        [self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
         self.SpeakerTableview.scrollEnabled = NO;
        searching = NO;
	}

    
    NSError *error;
    
    // Finally, perform the load
    self.ResultadosCoreData= [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.DysplayItems= [[NSMutableArray alloc] initWithArray:self.ResultadosCoreData];
    
    [self.SpeakerTableview reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self filter:text];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)ThesearchBar{
    
    /*
     * Este Metodo implementa una vista blanco  al tableview cuando la barra de busqueda
     * a sido selecionada y no contiene ningun caracter al presionar sobre ella
     * el teclado se esconde
     */
    if (searching)
    {
        return;
    }

	if(ovController == nil)
		ovController = [[mSpeakerCloseViewController alloc] initWithNibName:@"touchSpeaker" bundle:[NSBundle mainBundle]];
	

	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	CGFloat yaxis = self.buscar.frame.size.height;
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor whiteColor];
	ovController.view.alpha = 0.7;
	
	ovController.rvController = self;
	
	[self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    searching =YES;

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    [self.buscar resignFirstResponder];
}

#pragma -mark Tableview datasource y delegate

// Delegados  y datasource tableview (speakertableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ResultadosCoreData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Persona *info = [self.ResultadosCoreData objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"SpeakerCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"celdaSpeaker.png"]];
    UIView *ColorSelecion = [[UIView alloc] init];
    ColorSelecion.backgroundColor = [UIColor colorWithRed:(76/255.0) green:(124/255.0) blue:(255/255.0) alpha:1.0f];
    cell.selectedBackgroundView = ColorSelecion;
    cell.Titulo.text    =   info.nombre;
    cell.Subtitulo.text =   info.institucionQueMePatrocina.nombreInstitucion;
    cell.texto.text     =   info.lugarDondeProvengo.nombreLugar;
    
    if (info.institucionQueMePatrocina.nombreInstitucion == nil) {
        
        cell.Subtitulo.text = info.rol;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.buscar resignFirstResponder];
}

#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"SpeakerDet"])
    {
        NSError *error;
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:_delegate.managedObjectContext];
        [fetch setEntity:entidad];
        
        NSArray *arrayete = [_delegate.managedObjectContext executeFetchRequest:fetch error:&error];
        mSpeakerDetViewController *destino = (mSpeakerDetViewController *)segue.destinationViewController;
        Persona *info = [arrayete objectAtIndex:[self.SpeakerTableview indexPathForSelectedRow].row];
        destino.Nombrecelda = info.eventoParticipo.participantes.nombre;
        destino.Paiscelda = info.lugarDondeProvengo.pais;
        destino.ReferenciaSpeaker = info.eventoParticipo.participantes.nombre;
        destino.BiografiaCelda = info.nombre;
        destino.Institucioncelda = info.eventoParticipo.tituloEP;
    }
}

#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 73.0f;
}

- (void)viewDidUnload {
    [self setBotonMenu:nil];
    [self setBuscar:nil];
    [self setSpeakerTableview:nil];
    [super viewDidUnload];
}

- (IBAction)RevelarMenuLateral:(id)sender
{
    if(ovController == nil)
        [self.buscar resignFirstResponder];
   else
        [self CerrarTeclado];
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    id eventoMenuLateralAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoMenuLateralAhora sendEventWithCategory:@"uiAction"
                                       withAction:@"Revelar Menu Lateral"
                                        withLabel:@"Revelo desde Speaker"
                                        withValue:nil];
   
}
-(void)notifica {
    
    NSError *error;
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Notificacion" inManagedObjectContext:_delegate.managedObjectContext];
    NSFetchRequest *fet = [[NSFetchRequest alloc]init];
    [fet setEntity:ent];
    NSArray *ar = [_delegate.managedObjectContext executeFetchRequest:fet error:&error];
    NSLog(@"%@",ar);
}


- (IBAction)RevelarNotificaciones:(id)sender
{
    
    if(ovController == nil)
        [self.buscar resignFirstResponder];
    else
        [self CerrarTeclado];
    [self.slidingViewController anchorTopViewTo:ECLeft];
    id eventoNotificacionesDesdeAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoNotificacionesDesdeAhora sendEventWithCategory:@"uiAction"
                                               withAction:@"Revelar Notificaciones"
                                                withLabel:@"Revelo desde Speaker"
                                                withValue:nil];
  //  [self notifica];
    
}

-(void)CerrarTeclado{
    [self.buscar resignFirstResponder];
    [ovController.view removeFromSuperview];
	ovController = nil;
	 self.SpeakerTableview.scrollEnabled = YES;
	[self.SpeakerTableview reloadData];
    searching = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
        [super viewWillAppear:animated];
    
}
@end
