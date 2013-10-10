//
//  Pais.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 09-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lugar;

@interface Pais : NSManagedObject

@property (nonatomic, retain) NSString * nombrePais;
@property (nonatomic, retain) NSSet *lugarQueEstaEnMITerritorio;
@end

@interface Pais (CoreDataGeneratedAccessors)

- (void)addLugarQueEstaEnMITerritorioObject:(Lugar *)value;
- (void)removeLugarQueEstaEnMITerritorioObject:(Lugar *)value;
- (void)addLugarQueEstaEnMITerritorio:(NSSet *)values;
- (void)removeLugarQueEstaEnMITerritorio:(NSSet *)values;

@end
