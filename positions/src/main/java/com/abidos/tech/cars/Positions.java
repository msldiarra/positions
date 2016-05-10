package com.abidos.tech.cars;

import com.abidos.tech.model.Bounds;
import com.abidos.tech.model.CarPosition;
import com.abidos.tech.model.Location;
import com.abidos.tech.model.Zone;

import java.util.List;
import java.util.Optional;

public class Positions {

    public Optional<CarPosition> getAvailableCarsInZone(Zone zone, List<CarPosition> availableCars) {

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
