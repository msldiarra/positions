package com.abidos.tech;


import com.abidos.tech.model.*;
import com.mysema.query.jpa.impl.JPAQuery;
import com.mysema.query.jpa.impl.JPAQueryFactory;

import javax.annotation.security.PermitAll;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.inject.Provider;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.*;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.abidos.tech.model.QReservableCar.reservableCar;
import static com.abidos.tech.model.QZone.zone;

@Path("/cars")
@Consumes({"application/json"})
@Produces({"application/json"})
@Stateless
public class Cars {

    @Inject
    Positions positions;

    @PersistenceContext(unitName = CarsPersistenceUnit.NAME)
    private EntityManager entityManager;

    @GET
    @PermitAll
    public Response available(String where) {

        List<ReservableCar> availableCars = new JPAQuery(entityManager)
                .from(reservableCar)
                .where(reservableCar.available.eq(true))
                .list(reservableCar);

        Zone searchZone = new JPAQuery(entityManager)
                .from(zone)
                .where(zone.name.equalsIgnoreCase(where))
                .singleResult(zone);

        Optional<ReservableCar> cars = positions.getAvailableCarsInZone(searchZone, availableCars);

        return Response.ok(cars.toString()).build();
    }

    @PUT
    @PermitAll
    public Response save(ReservableCar car) {

        ReservableCar existingCarInfo = new JPAQuery(entityManager)
                .from(reservableCar)
                .where(reservableCar.reference.equalsIgnoreCase(car.getReference()))
                .singleResult(reservableCar);

        Location location = new Location();
        location.setLatitude(car.getLocation().getLatitude());
        location.setLongitude(car.getLocation().getLongitude());

        existingCarInfo.setLocation(location);
        existingCarInfo.setAvailable(car.getAvailable());

        ReservableCar savedCar = entityManager.merge(existingCarInfo);

        return Response.ok(savedCar.toString()).build();
    }

}
