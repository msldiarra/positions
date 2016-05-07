package com.abidos.tech.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;

@Entity
@XmlRootElement
@Table(name = "Bounds")
public class Bounds {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Location northEast;

    private Location southwest;

    public Location getNorthEast() {
        return northEast;
    }

    public void setNorthEast(Location northEast) {
        this.northEast = northEast;
    }

    public Location getSouthwest() {
        return southwest;
    }

    public void setSouthwest(Location southwest) {
        this.southwest = southwest;
    }
}
