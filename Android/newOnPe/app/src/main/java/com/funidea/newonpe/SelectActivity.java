package com.funidea.newonpe;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class SelectActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select);

        Button pose_button = (Button)findViewById(R.id.pose_button);
        Button juggling_button = (Button)findViewById(R.id.juggling_button);

        pose_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getApplicationContext(),PoseActivity.class);
                startActivity(intent);
            }
        });

        juggling_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getApplicationContext(),JugglingActivity.class);
                startActivity(intent);
            }
        });
    }
}
