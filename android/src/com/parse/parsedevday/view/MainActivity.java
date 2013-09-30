package com.parse.parsedevday.view;

import java.util.Locale;

import com.parse.ParseAnalytics;
import com.parse.parsedevday.R;

import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBar.Tab;
import android.support.v7.app.ActionBar.TabListener;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.view.Menu;

/**
 * An Activity with a tabs for the complete schedule and the list of favorited talks. This was
 * originally created from an ADT wizard.
 */
public class MainActivity extends ActionBarActivity implements TabListener {
  private static final int TAB_SCHEDULE = 0;
  private static final int TAB_FAVORITES = 1;
  private static final int TAB_COUNT = 2;

  /**
   * The {@link android.support.v4.view.PagerAdapter} that will provide fragments for each of the
   * sections. We use a {@link android.support.v4.app.FragmentPagerAdapter} derivative, which will
   * keep every loaded fragment in memory. If this becomes too memory intensive, it may be best to
   * switch to a {@link android.support.v4.app.FragmentStatePagerAdapter}.
   */
  private SectionsPagerAdapter sectionsPagerAdapter;

  /**
   * The {@link ViewPager} that will host the section contents.
   */
  private ViewPager viewPager;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // Tracks app-open metrics using Parse.
    ParseAnalytics.trackAppOpened(getIntent());

    // Set up the action bar.
    final ActionBar actionBar = getSupportActionBar();
    actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

    // This adapter will return a fragment for each of the primary sections of the app.
    sectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

    // Set up the ViewPager with the sections adapter.
    viewPager = (ViewPager) findViewById(R.id.pager);
    viewPager.setAdapter(sectionsPagerAdapter);

    // When swiping between different sections, select the corresponding tab.
    viewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
      @Override
      public void onPageSelected(int position) {
        actionBar.setSelectedNavigationItem(position);
      }
    });

    // Create the tabs for each section.
    for (int i = 0; i < sectionsPagerAdapter.getCount(); i++) {
      Tab tab = actionBar.newTab();
      tab.setText(sectionsPagerAdapter.getPageTitle(i));
      tab.setTabListener(this);
      actionBar.addTab(tab);
    }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu. This adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.main, menu);
    return true;
  }

  @Override
  public void onTabSelected(Tab tab, FragmentTransaction fragmentTransaction) {
    // When the given tab is selected, switch to the corresponding page in the ViewPager.
    viewPager.setCurrentItem(tab.getPosition());

    // If the favorites tab is selected, remove any items that have been unfavorited.
    if (tab.getPosition() == TAB_FAVORITES) {
      SectionsPagerAdapter adapter = (SectionsPagerAdapter) viewPager.getAdapter();
      TalkListFragment fragment = (TalkListFragment) adapter.getItem(TAB_FAVORITES);
      fragment.removeUnfavoritedItems();
    }
  }

  @Override
  public void onTabUnselected(Tab tab, FragmentTransaction fragmentTransaction) {
  }

  @Override
  public void onTabReselected(Tab tab, FragmentTransaction fragmentTransaction) {
  }

  /**
   * A {@link FragmentPagerAdapter} that returns a fragment corresponding to one of the sections.
   */
  public class SectionsPagerAdapter extends FragmentPagerAdapter {
    private TalkListFragment scheduleFragment = null;
    private TalkListFragment favoritesFragment = null;

    public SectionsPagerAdapter(FragmentManager fm) {
      super(fm);
    }

    @Override
    public Fragment getItem(int position) {
      // getItem is called to instantiate the fragment for the given page.
      switch (position) {
        case TAB_SCHEDULE: {
          if (scheduleFragment == null) {
            scheduleFragment = new TalkListFragment();
            Bundle args = new Bundle();
            scheduleFragment.setArguments(args);
          }
          return scheduleFragment;
        }
        case TAB_FAVORITES: {
          if (favoritesFragment == null) {
            favoritesFragment = new TalkListFragment();
            Bundle args = new Bundle();
            args.putBoolean("favoritesOnly", true);
            favoritesFragment.setArguments(args);
          }
          return favoritesFragment;
        }
      }
      return null;
    }

    @Override
    public int getCount() {
      return TAB_COUNT;
    }

    @Override
    public CharSequence getPageTitle(int position) {
      Locale l = Locale.getDefault();
      switch (position) {
        case TAB_SCHEDULE:
          return getString(R.string.title_schedule).toUpperCase(l);
        case TAB_FAVORITES:
          return getString(R.string.title_favorites).toUpperCase(l);
      }
      return null;
    }
  }
}
