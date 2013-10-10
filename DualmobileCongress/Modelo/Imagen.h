//
//  Imagen.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 09-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Persona;

@interface Imagen : NSManagedObject

@property (nonatomic, retain) id binarioImagen;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) Evento *eventoQueGrafico;
@property (nonatomic, retain) NSSet *personaQueGrafico;
@end

@interface Imagen (CoreDataGeneratedAccessors)

- (void)addPersonaQueGraficoObject:(Persona *)value;
- (void)removePersonaQueGraficoObject:(Persona *)value;
- (void)addPersonaQueGrafico:(NSSet *)values;
- (void)removePersonaQueGrafico:(NSSet *)values;

@end
