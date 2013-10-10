//
//  Persona.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 09-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Imagen, Institucion, Lugar;

@interface Persona : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * cargo;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * tratamiento;
@property (nonatomic, retain) NSSet *eventoQueDicto;
@property (nonatomic, retain) Imagen *fotoPersona;
@property (nonatomic, retain) Institucion *institucionQueMePatrocina;
@property (nonatomic, retain) Lugar *lugarDondeProvengo;
@end

@interface Persona (CoreDataGeneratedAccessors)

- (void)addEventoQueDictoObject:(Evento *)value;
- (void)removeEventoQueDictoObject:(Evento *)value;
- (void)addEventoQueDicto:(NSSet *)values;
- (void)removeEventoQueDicto:(NSSet *)values;

@end
