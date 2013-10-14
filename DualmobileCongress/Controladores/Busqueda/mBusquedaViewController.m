//
//  mBusquedaViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 11-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mBusquedaViewController.h"
#import "mBusquedaCloseViewController.h"
#import "NSDataAdditions.h"
#import "GAI.h"

@interface mBusquedaViewController ()
@property(nonatomic,strong)mAppDelegate *delegate;
@end

@implementation mBusquedaViewController

#pragma -mark Metodos De Inicializacion

-(void)AnularActualizaEstadoAutorizadorSincronizacion{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];
    
    NSLog(@"valor de autorizador   %c", [defaults boolForKey:@"kAutorizadorSincronizacion"]);
    
}

-(void)AnularActualizaEstadoAutorizadorSincronizacionImagen{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"kAutorizadorSincronizacionImagen"];
    [defaults synchronize];
    
    NSLog(@"valor de autorizador IMAGEN %c", [defaults boolForKey:@"kAutorizadorSincronizacionImagen"]);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //trackenado GA
    
    id trackerBusqueda = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerBusqueda sendView:@"Busqueda"];
    
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
    self.SearchTableview.scrollEnabled = YES;
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"aimagos.png",@"publicidad_ahora.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    
}

#pragma -mark Tableview datasource y delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.ResultadosCoreData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Evento *info = [self.ResultadosCoreData objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"SearchCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"celdas_actividades_jornada.png"]];
    UIView *ColorSelecion = [[UIView alloc] init];
    ColorSelecion.backgroundColor = [UIColor colorWithRed:(76/255.0) green:(124/255.0) blue:(255/255.0) alpha:1.0f];
    cell.selectedBackgroundView = ColorSelecion;
      NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
    cell.Titulo.text = info.titulo;
    cell.Subtitulo.text = info.speaker.nombre;
    cell.Imagen.image = [UIImage imageWithData:dataObj];
    cell.texto.text   = info.lugarEnQueMeDesarrollo.ciudad;
    cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];
    cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];
    cell.Actividad.text = info.descripcionEvento;
   
    return cell;
}

-(NSDate*)StringToDate:(NSString*)hora{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    NSRange RangoReemplazo = {20, 5};
    
    NSString *remplaso = [hora stringByReplacingCharactersInRange:RangoReemplazo withString:@"-0400"];
    return  [dateFormatter dateFromString:remplaso];
}

-(NSString*)DateToString:(NSDate*)Date{
    
    
    NSDateFormatter *formateadorFecha = [[NSDateFormatter alloc] init];
    [formateadorFecha setDateFormat:@"H:mm"];
    return  [formateadorFecha stringFromDate:Date];
    
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.BarraBusqeuda resignFirstResponder];
}

#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"SearchDet"])
    {
        Evento *info = [self.ResultadosCoreData objectAtIndex:[self.SearchTableview indexPathForSelectedRow].row];
        mDetalleViewController *destino = (mDetalleViewController *)segue.destinationViewController;
        NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
        UIImage *beforeImage = [UIImage imageWithData:dataObj];
        destino.ExpositorCelda = info.speaker.nombre;
        destino.tituloCelda = info.titulo;
        destino.ContenidoCelda =info.tematica;
        destino.LugarCelda = info.lugarEnQueMeDesarrollo.ciudad;
        destino.ActividadSpeaker = info.descripcionEvento;
        destino.NombreImagen = beforeImage;
        NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
        destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
        destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
        destino.PaisSpeaker = info.speaker.lugarDondeProvengo.ciudad;
        destino.BiografiaSpeaker = info.speaker.bio;
        destino.Referencia  = info.speaker.tratamiento;
    }
}

#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 73.0f;
}

#pragma -mark Filtro Barra Busqueda

-(void)filter:(NSString*)text
{
    self.DysplayItems = [[NSMutableArray alloc] init];
    
    // creamos nuestro fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Definimos que vamos a clasificar de la entidad
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"titulo" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate *predicadoBusqueda = [NSPredicate predicateWithFormat:@"(speaker.nombre >%@) OR (titulo >%@) ",@"",@""];
    [fetchRequest setPredicate:predicadoBusqueda];
    
    // Si se busca alguna huea
    
    if(text.length > 0)
    {
        [ovController.view removeFromSuperview];
        self.SearchTableview.scrollEnabled = YES;
        searching = YES;
        // define cuantas entidades queremos que se filtren
        //hice unas hueas reparches en la busqueda hay que arreglarlas de ahí
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(titulo CONTAINS[cd] %@) OR (speaker.nombre CONTAINS[cd] %@) OR (speaker.bio CONTAINS[cd] %@) OR (lugarEnQueMeDesarrollo.ciudad CONTAINS[cd] %@)", text, text,text,text];
        [fetchRequest setPredicate:predicate];
    }
    else
    {
        [self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
        self.SearchTableview.scrollEnabled = NO;
        searching = NO;
    }

    NSError *error;
    
    // Acá se caga
    
    self.ResultadosCoreData= [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.DysplayItems= [[NSMutableArray alloc] initWithArray:self.ResultadosCoreData];
    
    [self.SearchTableview reloadData];
}

-(void)searchBar:(UISearchBar*)thesearchBar textDidChange:(NSString*)text
{
    [self filter:text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
        [self.BarraBusqeuda resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)ThesearchBar{
    
   //Acá se implementa como queremos que se inicie la barra de nuestra búsqueda, en este caso será en blanco.
    if (searching) {
        return;
    }
	if(ovController == nil)
		ovController = [[mBusquedaCloseViewController alloc] initWithNibName:@"TouchBusqueda" bundle:[NSBundle mainBundle]];
	
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	CGFloat yaxis = self.BarraBusqeuda.frame.size.height;
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor whiteColor];
	ovController.view.alpha = 0.7;
	ovController.rvController = self;
	
    [self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    self.SearchTableview.scrollEnabled = NO;
    searching = YES;
}

#pragma -mark Metodos De Accion

- (IBAction)RevelarMenuLateral:(id)sender {
    if(ovController == nil)
        [self.BarraBusqeuda resignFirstResponder];
    else
        [self CerrarTeclado];
    
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RevelarNotificaciones:(id)sender {
    if(ovController == nil)
        [self.BarraBusqeuda resignFirstResponder];
    else
        [self CerrarTeclado];
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

-(void)CerrarTeclado{
    [self.BarraBusqeuda resignFirstResponder];
    [ovController.view removeFromSuperview];
    self.SearchTableview.scrollEnabled = YES;
	ovController = nil;
	[self.SearchTableview reloadData];
    searching = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL estadoAutorizador = [defaults boolForKey:@"kAutorizadorSincronizacion"];
    BOOL estadoAutorizadorImagen = [defaults boolForKey:@"kAutorizadorSincronizacionImagen"];
    
    if (estadoAutorizador == YES) {

// Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
        
        [self AnularActualizaEstadoAutorizadorSincronizacion];
        
    }
    if (estadoAutorizadorImagen == YES) {

// Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
        
        [self AnularActualizaEstadoAutorizadorSincronizacionImagen];
        
    }
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload {
    [self setBotonMenu:nil];
    [self setBarraBusqeuda:nil];
    [self setSearchTableview:nil];
    [super viewDidUnload];
}


@end
