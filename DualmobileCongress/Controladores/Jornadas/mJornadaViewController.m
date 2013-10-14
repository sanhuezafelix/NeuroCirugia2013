//
//  mJornadaViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mJornadaViewController.h"
#import "mAppDelegate.h"
#import "mDetalleViewController.h"
#import "NSDataAdditions.h"
#import "GAI.h"

@interface mJornadaViewController ()

@property(nonatomic,strong)mAppDelegate *delegate;

@end

@implementation mJornadaViewController


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
    
    id trackerJornada = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerJornada sendView:@"Jornada"];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.TituloJornada.text = self.Titulo;
    
    self.title = @" ";
    
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.title = @" ";
    [self llamadoEventus];
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    
}

-(void)llamadoEventus{
    
    NSError *error;
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:_delegate.managedObjectContext];
    NSFetchRequest *fetchengue = [[NSFetchRequest alloc] init];
    [fetchengue setEntity:entidad];
    NSArray *arrayengue = [_delegate.managedObjectContext executeFetchRequest:fetchengue error:&error];
    NSLog(@"%@",arrayengue);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma -mark Tableview datasource y delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"JornadaCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"celdas_actividades_jornada.png"]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
  }


#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 73.0f;
}


#pragma -mark FetchResult controller metodos

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    
    NSDate *HoraInicio = [dateFormatter dateFromString:self.InicioJornada];
    NSDate *HoraFin = [dateFormatter dateFromString:self.FinJornada];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento"
                                              inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"horaInicio" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@"(horaInicio >= %@) AND (horaInicio < %@)",HoraInicio,HoraFin];
    [fetchRequest setPredicate:Predicado];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.delegate.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    _fetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.JornadasTableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.JornadasTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.JornadasTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.JornadasTableView;
    //Pegarle una mira después.
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
   
    [self.JornadasTableView endUpdates];
}

- (void)configureCell:(mCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Evento *info = [_fetchedResultsController
                    objectAtIndexPath:indexPath];
    UIView *ColorSelecion = [[UIView alloc] init];
    ColorSelecion.backgroundColor = [UIColor colorWithRed:(76/255.0) green:(124/255.0) blue:(255/255.0) alpha:1.0f];
    cell.selectedBackgroundView = ColorSelecion;

    NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
    UIImage *beforeImage = [UIImage imageWithData:dataObj];

    cell.Titulo.text = info.titulo;
    cell.Subtitulo.text = info.speaker.nombre;
    cell.texto.text = info.lugarEnQueMeDesarrollo.ciudad;
    cell.Imagen.image = beforeImage;
    cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];
    cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];
    cell.Actividad.text = info.descripcionEvento;
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


#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"JornadaDetalle"])
    {
        Evento *info = [_fetchedResultsController
                        objectAtIndexPath:[self.JornadasTableView indexPathForSelectedRow]];
        mDetalleViewController *destino = (mDetalleViewController *)segue.destinationViewController;
        NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
        UIImage *beforeImage = [UIImage imageWithData:dataObj];
        destino.ExpositorCelda = info.speaker.nombre;
        destino.tituloCelda = info.titulo;
        destino.ContenidoCelda =info.tematica;
        destino.LugarCelda = info.lugarEnQueMeDesarrollo.ciudad;
        destino.NombreImagen = beforeImage;
        NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
        destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
        destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
        destino.PaisSpeaker = info.speaker.lugarDondeProvengo.ciudad;
        destino.BiografiaSpeaker = info.speaker.bio;
        destino.Referencia  = info.speaker.tratamiento;
        destino.DateFin = [self StringToDate:info.horaFin];
        destino.DateInicio = [self StringToDate:info.horaInicio];
        destino.ActividadSpeaker = info.descripcionEvento;

    }
}


- (IBAction)RevelarNotificaciones:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
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


- (void)viewDidUnload
{
  
    [self setTituloJornada:nil];
    [self setJornadasTableView:nil];
    [super viewDidUnload];
}
@end
