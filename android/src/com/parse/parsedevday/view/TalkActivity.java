package com.parse.parsedevday.view;

import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseImageView;
import com.parse.parsedevday.R;
import com.parse.parsedevday.model.Favorites;
import com.parse.parsedevday.model.Speaker;
import com.parse.parsedevday.model.Talk;

import android.os.Bundle;
import android.support.v7.app.ActionBar.LayoutParams;
import android.support.v7.app.ActionBarActivity;
import android.text.TextUtils.TruncateAt;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

/**
 * An Activity to display information about a particular talk.
 */
public class TalkActivity extends ActionBarActivity {
  /**
   * Adds a click listener to toggle between text truncated with ellipses and the full text.
   * @param view the view the user can click to toggle.
   * @param textView the text view to collapse.
   * @param maxLines the maximum number of lines to show when collapsed.
   */
  private void enableTextCollapsing(final View view, final TextView textView, final int maxLines) {
    if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.GINGERBREAD_MR1) {
      /*
       * There's a bug in Gingerbread at least where ellipsized text doesn't wrap before it gets
       * ellipsized, so the layout turns out all wrong. So let's just have long screens of text in
       * old versions of Android.
       */
      return;
    }
    
    textView.setEllipsize(TruncateAt.END);
    textView.setMaxLines(maxLines);
    view.setOnClickListener(new OnClickListener() {
      boolean expanded = false;

      @Override
      public void onClick(View v) {
        // In newer versions of Android, we could use getMaxLines to know if it was expanded.
        if (expanded) {
          textView.setMaxLines(maxLines);
          expanded = false;
        } else {
          textView.setMaxLines(Integer.MAX_VALUE);
          expanded = true;
        }
      }
    });

  }
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_talk);

    // Fetch the data about this talk from Parse.
    String talkId = Talk.getTalkId(getIntent().getData());
    Talk.getInBackground(talkId, new GetCallback<Talk>() {
      @Override
      public void done(final Talk talk, ParseException e) {
        // If we can't get the data right now, the best we can do is show a toast.
        if (e != null) {
          Toast toast = Toast.makeText(TalkActivity.this, e.getMessage(), Toast.LENGTH_LONG);
          toast.show();
          return;
        }
        
        if (talk == null) {
          throw new RuntimeException("Somehow the talk was null.");
        }

        TextView titleView = (TextView) findViewById(R.id.title);
        TextView timeView = (TextView) findViewById(R.id.time);
        TextView roomView = (TextView) findViewById(R.id.room);
        TextView abstractView = (TextView) findViewById(R.id.talk_abstract);

        titleView.setText(talk.getTitle());
        timeView.setText(talk.getSlot().format(TalkActivity.this));
        roomView.setText(talk.getRoom().getName());
        abstractView.setText(talk.getAbstract());
        enableTextCollapsing(abstractView, abstractView, 10);

        final ImageButton favoriteButton = (ImageButton) findViewById(R.id.favorite_button);
        if (Favorites.get().contains(talk)) {
          favoriteButton.setImageResource(R.drawable.light_rating_important);
        } else {
          favoriteButton.setImageResource(R.drawable.light_rating_not_important);
        }
        if (talk.isAlwaysFavorite()) {
          favoriteButton.setVisibility(View.INVISIBLE);
        }

        favoriteButton.setOnClickListener(new OnClickListener() {
          @Override
          public void onClick(View v) {
            if (Favorites.get().contains(talk)) {
              Favorites.get().remove(talk);
              favoriteButton.setImageResource(R.drawable.light_rating_not_important);
            } else {
              Favorites.get().add(talk);
              favoriteButton.setImageResource(R.drawable.light_rating_important);
            }
            Favorites.get().save(TalkActivity.this);
          }
        });

        // Add a view for each speaker in the talk.

        LinearLayout scrollView = (LinearLayout) findViewById(R.id.scroll_view);
        for (Speaker speaker : talk.getSpeakers()) {
          View speakerView = View.inflate(TalkActivity.this, R.layout.list_item_speaker, null);

          ParseImageView photo = (ParseImageView) speakerView.findViewById(R.id.photo);
          photo.setParseFile(speaker.getPhoto());
          photo.loadInBackground();

          TextView nameView = (TextView) speakerView.findViewById(R.id.name);
          nameView.setText(speaker.getName());

          TextView titleAndCompany = (TextView) speakerView.findViewById(R.id.title_company);
          titleAndCompany.setText(String.format("%s @ %s", speaker.getTitle(), speaker.getCompany()));

          final TextView bioView = (TextView) speakerView.findViewById(R.id.bio);
          bioView.setText(speaker.getBio());

          // Put in some heuristics for how much text we can show for each speaker.
          if (talk.getSpeakers().size() > 1) {
            enableTextCollapsing(speakerView, bioView, 2);
          } else {
            if (talk.getAbstract().length() > 2) {
              enableTextCollapsing(speakerView, bioView, 8);
            } else {
              enableTextCollapsing(speakerView, bioView, 20);
            }
          }
          
          LayoutParams layout = new LayoutParams(LayoutParams.MATCH_PARENT,
              LayoutParams.WRAP_CONTENT);
          speakerView.setLayoutParams(layout);

          scrollView.addView(speakerView);
        }
      }
    });
  }
}
