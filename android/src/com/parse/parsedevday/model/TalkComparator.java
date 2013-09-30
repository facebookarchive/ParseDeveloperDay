package com.parse.parsedevday.model;

import java.util.Comparator;

/**
 * A Comparator that sorts talks first by time, then by room.
 */
public class TalkComparator implements Comparator<Talk> {
  /*
   * This is a Singleton, because it has no state, so it's silly to make new ones. 
   */
  final private static TalkComparator instance = new TalkComparator();
  public static TalkComparator get() {
    return instance;
  }
  
  @Override
  public int compare(Talk lhs, Talk rhs) {
    int startCompare = lhs.getSlot().getStartTime().compareTo(rhs.getSlot().getStartTime());
    if (startCompare != 0) {
      return startCompare;
    }
    return lhs.getRoom().getName().compareTo(rhs.getRoom().getName());
  }
}