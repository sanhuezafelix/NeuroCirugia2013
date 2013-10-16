//
//  mHomeViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 06-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mHomeViewController.h"
#import "mAppDelegate.h"
#import "NSDataAdditions.h"
#import "GAI.h"
#import "Evento.h"
#import "Notificacion.h"

@interface mHomeViewController ()

@property(nonatomic,strong)mAppDelegate *delegate;

@end

@implementation mHomeViewController

-(void)awakeFromNib
{
    [self.HomeTableview reloadData];

}

//***********************-----> INICIO DE 4 METODOS QUE TENEMOS QUE REFACTORIZAR <-------*******************

-(void)cancelaInicioTimer{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"kCanceladorInicioTimer"];
    [defaults synchronize];
    NSLog(@"valor de cancelador  %c", [defaults boolForKey:@"kCanceladorInicioTimer"]);
}


-(void)actualizaEstadoAutorizadorSincronizacion{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];

NSLog(@"valor de autorizador  %c", [defaults boolForKey:@"kAutorizadorSincronizacion"]);
    
}

//-(void)actualizaEstadoAutorizadorSincronizacionImagen{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    [defaults setBool:YES forKey:@"kAutorizadorSincronizacionImagen"];
//    [defaults synchronize];
//    
//    NSLog(@"valor de autorizador IMAGEN %c", [defaults boolForKey:@"kAutorizadorSincronizacionImagen"]);
//}

-(void)AnularActualizaEstadoAutorizadorSincronizacion{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];
    
    NSLog(@"valor de autorizador   %c", [defaults boolForKey:@"kAutorizadorSincronizacion"]);
    
}

//-(void)AnularActualizaEstadoAutorizadorSincronizacionImagen{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:NO forKey:@"kAutorizadorSincronizacionImagen"];
//    [defaults synchronize];
//    
//    NSLog(@"valor de autorizador IMAGEN %c", [defaults boolForKey:@"kAutorizadorSincronizacionImagen"]);
//    
//}

//***********************-----> FIN DE 4 METODOS QUE TENEMOS QUE REFACTORIZAR <-------*******************

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // refresh
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    
    [self.HomeTableview addSubview:refresh];
    
    //trackenado GA

    id trackerAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerAhora sendView:@"Ahora"];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    BOOL estadoCanceladorTimer = [defaults boolForKey:@"kCanceladorInicioTimer"];


   

    NSTimeInterval interval = [defaults floatForKey:@"kIntervaloHora"];
  //  NSTimeInterval intervalImagen = [defaults floatForKey:@"kIntervaloHoraImagen"];

    if (estadoCanceladorTimer == NO) {

    

    // ponemos el timer en funcionamiento y se actualizará cada "interval" segundos
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(actualizaEstadoAutorizadorSincronizacion)
                                                userInfo:nil
                                                 repeats:YES];
        

//            self.timerImagen = [NSTimer scheduledTimerWithTimeInterval:intervalImagen
//                                                      target:self
//                                                    selector:@selector(actualizaEstadoAutorizadorSincronizacionImagen)
//                                                    userInfo:nil
//                                                     repeats:YES];
//
    }
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"btnmenu.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    [self.BotonMenu setBackgroundImage:barButtonImage
                                  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.delegate = [[UIApplication sharedApplication]delegate];

    self.title = @" ";
    self.EnesteMomento = [[NSMutableArray alloc]initWithArray:[self CargarEnEsteMomento]];
    self.ProximasActividades = [[NSMutableArray alloc]initWithArray:[self CargarProximasActividades]];
    EstadoDeLaconexion = [UIDevice estaConectado];
    self.refresh = refresh;
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self              action:@selector(imageTapped:)];
    self.animationImageView.userInteractionEnabled = YES;
    [self.animationImageView addGestureRecognizer:tap];
    
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

#pragma -mark Tableview datasource y delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDate *horaDispocitivo = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    
//    NSString *strDate = [dateFormatter stringFromDate:horaDispocitivo];
//    NSRange remplazoFecha = {0, 7};
//    
//    NSDate *HoraActual2 = [dateFormatter dateFromString:[strDate stringByReplacingCharactersInRange:remplazoFecha withString:@"2013-10"]];
//    
//    NSString *strDate2 = [dateFormatter stringFromDate:horaDispocitivo];
//    NSLog(@"%@",strDate2);
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    // Defineself.navigationItem.hidesBackButton = YES; the entity we are looking for
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@" (horaInicio CONTAINS[cd] %@)",strDate2];
//    [fetchRequest setPredicate:Predicado];
//    // Define how we want our entities to be sorted
//    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"horaInicio" ascending:YES];
//    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    NSError *error = nil;
//
//    NSArray *efff= [_delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"%lu",(unsigned long)[efff count]);
    int rows;
    if (section == 0) {
        rows = [self.EnesteMomento count];
    }
    else{
        rows = [self.ProximasActividades count];
        
    }
        return rows;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

/*
 *  Esta condicion indica el estilo del fondo de cada celda
 *  si es una en este momento y las de las prximas actividades
 *  indicando la cantidad de actividades hay en ese momento podemos
 *  preguntamos cuantas actividades hay en el momento y le cambiamos el fondo.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"HomeCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.opaque = YES;
        cell.Imagen.opaque = YES;
    }
    
        if (indexPath.section == 0)
    {
        Evento *info = [self.EnesteMomento objectAtIndex:indexPath.row];
        NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
        UIImage *beforeImage = [UIImage imageWithData:dataObj];
        UIView *ColorSelecion = [[UIView alloc] init];
        ColorSelecion.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(146/255.0) blue:(28/255.0) alpha:1.0f];
        cell.selectedBackgroundView = ColorSelecion;
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"eem.png"]];
        cell.Subtitulo.text = info.speaker.nombre;
        cell.Titulo.text = info.titulo;
        cell.Imagen.image = beforeImage;
        cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];
        cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];
        cell.texto.text = info.lugarEnQueMeDesarrollo.nombreLugar;
        cell.Actividad.text = info.tipoEvento;
    }

        else
    {
        
         Evento *info = [self.ProximasActividades objectAtIndex:indexPath.row];
        UIView *ColorSelecion = [[UIView alloc] init];
        ColorSelecion.backgroundColor = [UIColor colorWithRed:(76/255.0) green:(124/255.0) blue:(255/255.0) alpha:1.0f];
        cell.selectedBackgroundView = ColorSelecion;
        cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];
        cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];
        NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
        UIImage *beforeImage = [UIImage imageWithData:dataObj];
        cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"paa.png"]];
        cell.Titulo.text = info.titulo;
        cell.Subtitulo.text = info.speaker.nombre;
        cell.Imagen.image = beforeImage;
        cell.texto.text = info.lugarEnQueMeDesarrollo.nombreLugar;
        cell.Actividad.text = info.tipoEvento;
    
    }

    return cell;
}

-(NSDate*)StringToDate:(NSString*)hora{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    NSRange RangoReemplazo = {20,5};
    
   NSString *remplaso = [hora stringByReplacingCharactersInRange:RangoReemplazo withString:@"-0300"];
    return  [dateFormatter dateFromString:remplaso];
}

-(NSString*)DateToString:(NSDate*)Date{
    
    
    NSDateFormatter *formateadorFecha = [[NSDateFormatter alloc] init];
    [formateadorFecha setDateFormat:@"H:mm"];
    return  [formateadorFecha stringFromDate:Date];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *ColorSelecion = [[UIView alloc] init];
    
    if (section==0)
    {
        if ([self.EnesteMomento count]>0)
        {
            ColorSelecion.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"labeleem"]];
        }
    }
    return ColorSelecion;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float altotitulo;
    if (section == 0) {
        if ([self.EnesteMomento count]==0) {
            altotitulo = 0.0f;
            if ([UIScreen mainScreen].bounds.size.height == 568.0)
            {
                self.HomeTableview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"no_hay_activ_1136"]];
            }
            else
            {

            self.HomeTableview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"no_hay_activ"]];
            }

        }
        else
        {
            altotitulo = 20.0f;
        }
    }
    else{
        altotitulo = 0.0f;
    }
    return altotitulo;
}




#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"home"])
    {
        // Obtenemos el controlador destino
        
       mDetalleViewController *destino = (mDetalleViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.HomeTableview indexPathForSelectedRow];
        NSLog(@"seccion seleccionada es ==> %d",indexPath.section);
        if (indexPath.section == 0)
        {
            Evento *info = [self.EnesteMomento objectAtIndex:indexPath.row];
            NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
            UIImage *beforeImage = [UIImage imageWithData:dataObj];
            destino.ExpositorCelda = info.speaker.nombre;
            destino.tituloCelda = info.titulo;
            destino.ContenidoCelda =info.descripcionEvento;
            destino.LugarCelda = info.lugarEnQueMeDesarrollo.nombreLugar;
            destino.NombreImagen = beforeImage;
            NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
            destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
            destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
            destino.PaisSpeaker = info.speaker.lugarDondeProvengo.ciudad;
            destino.BiografiaSpeaker = info.speaker.bio;
            destino.Referencia  = info.speaker.tratamiento;
            destino.DateFin = [self StringToDate:info.horaFin];
            destino.DateInicio = [self StringToDate:info.horaInicio];
            destino.ActividadSpeaker = info.tipoEvento;
            
            
        }
        else
        {
            Evento *info = [self.ProximasActividades objectAtIndex:indexPath.row];
            NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
            UIImage *beforeImage = [UIImage imageWithData:dataObj];
            destino.ExpositorCelda = info.speaker.nombre;
            destino.tituloCelda = info.titulo;
            destino.ContenidoCelda =info.descripcionEvento;
            destino.LugarCelda = info.lugarEnQueMeDesarrollo.nombreLugar;
            destino.NombreImagen = beforeImage;
            NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
            destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
            destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
            destino.PaisSpeaker = info.speaker.lugarDondeProvengo.ciudad;
            destino.BiografiaSpeaker = info.speaker.bio;
            destino.Referencia  = info.speaker.tratamiento;
            destino.DateFin = [self StringToDate:info.horaFin];
            destino.DateInicio = [self StringToDate:info.horaInicio];
            destino.ActividadSpeaker = info.tipoEvento;
            
        }
    }

    
}
#pragma mark - Fetchs Coredata

-(NSArray*)CargarEnEsteMomento
{
    NSDate *horaDispositivo = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
 
    NSString *strDate = [dateFormatter stringFromDate:horaDispositivo];
    NSRange remplazoFecha = {0, 7};
    NSDate *HoraActual = [dateFormatter dateFromString:[strDate stringByReplacingCharactersInRange:remplazoFecha withString:@"2013-10"]];
    NSString *strDate2 = [dateFormatter stringFromDate:HoraActual];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@"(horaInicio <= %@) AND (horaFin > %@)",strDate2,strDate2];
    [fetchRequest setPredicate:Predicado];

    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"horaInicio" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    return [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

-(NSArray*)CargarProximasActividades{
    
    NSDate *horaDispocitivo = [[NSDate alloc]initWithTimeIntervalSinceNow:10800];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    
    NSString *strDate = [dateFormatter stringFromDate:horaDispocitivo];
    NSRange remplazoFecha = {0, 7};
    NSDate *HoraActual = [dateFormatter dateFromString:[strDate stringByReplacingCharactersInRange:remplazoFecha withString:@"2013-10"]];
    NSString *strDate2 = [dateFormatter stringFromDate:HoraActual];
    
    
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
       
        // Defineself.navigationItem.hidesBackButton = YES; the entity we are looking for
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@" (horaFin < %@) AND (horaInicio < %@)",strDate2,strDate2];
        [fetchRequest setPredicate:Predicado];
    [fetchRequest setFetchLimit:6];

        // Define how we want our entities to be sorted
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"horaInicio" ascending:YES];
        NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    
        NSError *error = nil;
        return [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        

    
   
}

#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section ==0)
    {
        return 73.0f;
    }
    else return 73.0f;
}


- (IBAction)RevelarMenuLateral:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
    
    id eventoMenuLateralAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoMenuLateralAhora sendEventWithCategory:@"uiAction"
                                       withAction:@"Revelar Menu Lateral"
                                        withLabel:@"Revelo desde Ahora"
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
    [self.slidingViewController anchorTopViewTo:ECLeft];

    
    id eventoNotificacionesDesdeAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoNotificacionesDesdeAhora sendEventWithCategory:@"uiAction"
                                               withAction:@"Revelar Notificaciones"
                                                withLabel:@"Revelo desde Ahora"
                                                withValue:nil];
    [self notifica];
}

#pragma mark - PullToRefresh delegate

- (void)beginRefreshing {
    if (EstadoDeLaconexion == TRUE)
    {
        NSLog(@"existe Conexion");
        [self refresh];
        [self.HomeTableview reloadData];
    }
    else
    {
        UIAlertView *Alerta = [[UIAlertView alloc]initWithTitle:@"Conexion De Red" message:@"No Existe Conexion al Servidor" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alerta show];
    }
    
    [self.refresh endRefreshing];
    
}

-(void)refreshView:(UIRefreshControl *)refresh {
    
    [self.EnesteMomento removeAllObjects];
    self.EnesteMomento = [[NSMutableArray alloc]initWithArray:[self CargarEnEsteMomento]];
    [self.ProximasActividades removeAllObjects];
    self.ProximasActividades = [[NSMutableArray alloc]initWithArray:[self CargarProximasActividades]];
    [self.HomeTableview reloadData];
    [self.refresh endRefreshing];
    
    //**********poner aqui sincronizador
}


- (void)endRefreshing {
    EstadoDeLaconexion = [UIDevice estaConectado];
    NSLog(@"conexcion ==> %d", EstadoDeLaconexion);
}

- (void)viewWillAppear:(BOOL)animated {
	   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    BOOL estadoAutorizador = [defaults boolForKey:@"kAutorizadorSincronizacion"];
  //  BOOL estadoAutorizadorImagen = [defaults boolForKey:@"kAutorizadorSincronizacionImagen"];
    
    BOOL estadoCanceladorTimer = [defaults boolForKey:@"kCanceladorInicioTimer"];
     
     
     if (estadoCanceladorTimer == NO) {
         
         [self cancelaInicioTimer];
         
     }    

    if (estadoAutorizador == YES) {
        // Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
                
        [self AnularActualizaEstadoAutorizadorSincronizacion];

    }
//    if (estadoAutorizadorImagen == YES) {
//        // Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
//        
//        [self AnularActualizaEstadoAutorizadorSincronizacionImagen];
//        
//    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setBotonMenu:nil];
    [self setBotonNotificaciones:nil];
    [self setHomeTableview:nil];
    [self setHomeTableview:nil];
    [super viewDidUnload];
}

@end
