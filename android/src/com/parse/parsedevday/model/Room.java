package com.parse.parsedevday.model;

import com.parse.ParseClassName;
import com.parse.ParseObject;

/**
 * A room that a talk could be held in.
 */
@ParseClassName("Room")
public class Room extends ParseObject {
  public String getName() {
    return getString("name");
  }
}
