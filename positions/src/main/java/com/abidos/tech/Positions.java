package com.abidos.tech;

import com.abidos.tech.model.Bounds;
import com.abidos.tech.model.Location;
import com.abidos.tech.model.ReservableCar;
import com.abidos.tech.model.Zone;

import java.util.List;
import java.util.Optional;

public class Positions {

    public Optional<ReservableCar> getAvailableCarsInZone(Zone zone, List<ReservableCar> availableCars) {

        return availableCars
                .stream()
                .filter( car -> carIsInZone(car.getLocation(), zone.getBounds()))
                .findAny();
    }


    public Boolean carIsInZone(Location location, Bounds zoneBounds)
    {
        if(zoneBounds.getSouthwest().getLatitude() > location.getLatitude())
            return false;
        if(zoneBounds.getNorthEast().getLatitude() < location.getLatitude())
            return false;

        if(zoneBounds.getSouthwest().getLongitude() > location.getLongitude())
            return false;

        if(zoneBounds.getNorthEast().getLongitude() < location.getLongitude())
            return false;

        return true;
    }
}
