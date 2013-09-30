package com.parse.parsedevday.model;

import com.parse.ParseClassName;
import com.parse.ParseFile;
import com.parse.ParseObject;

/**
 * A person speaking in a talk.
 */
@ParseClassName("Speaker")
public class Speaker extends ParseObject {
  public String getName() {
    return getString("name");
  }

  public String getTitle() {
    return getString("title");
  }

  public String getCompany() {
    return getString("company");
  }

  public String getBio() {
    return getString("bio");
  }
  
  public String getPhotoURL() {
    return getString("photoURL");
  }

  public ParseFile getPhoto() {
    return getParseFile("photo");
  }
}
