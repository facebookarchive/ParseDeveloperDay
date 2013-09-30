package com.parse.parsedevday.model;

import java.util.Date;

import com.parse.ParseClassName;
import com.parse.ParseObject;

import android.content.Context;
import android.text.format.DateFormat;

/**
 * A time slot that a talk could be held in.
 */
@ParseClassName("Slot")
public class Slot extends ParseObject {
  public Date getStartTime() {
    return getDate("startTime");
  }

  public Date getEndTime() {
    return getDate("endTime");
  }
  
  /**
   * Returns a string representation of the time slot suitable for use in the UI.
   */
  public String format(Context context) {
    return DateFormat.getTimeFormat(context).format(getStartTime()) + " - "
        + DateFormat.getTimeFormat(context).format(getEndTime());
  }
}
