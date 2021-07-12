package com.funidea.newonpe;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.funidea.newonpe.posedetector.Pose_ResultInformation;
import com.funidea.newonpe.posedetector.ResultInformation;

import java.util.ArrayList;

//현재 사용 X
//저글링 Activity랑 연동 되어있음


public class GetDataActivity extends AppCompatActivity
{
    private TextView poseresult_textview;

    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_getdata);

        Intent intent = getIntent();

        ArrayList<Pose_ResultInformation> arrayList = (ArrayList<Pose_ResultInformation>) intent.getSerializableExtra("pose_result_Array");

        poseresult_textview = findViewById(R.id.poseresult_textview);
        poseresult_textview.setText(String.valueOf(ResultInformation.result_list));

    }

    @Override
    protected void onPause()
    {
        super.onPause();

        ResultInformation.result_list.clear();
    }
}
