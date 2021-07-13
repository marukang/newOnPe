package com.funidea.newonpe.page.juggling;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.annotation.TargetApi;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.view.SurfaceView;
import android.view.WindowManager;
import android.widget.TextView;

import com.funidea.newonpe.R;
import com.funidea.newonpe.detector.ResultInformation;
import com.funidea.newonpe.page.pose.GetDateActivity_kt;

import org.opencv.android.BaseLoaderCallback;

import org.opencv.android.CameraBridgeViewBase;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;
import org.opencv.core.Core;
import org.opencv.core.Mat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static android.Manifest.permission.CAMERA;


public class JugglingActivity extends AppCompatActivity implements CameraBridgeViewBase.CvCameraViewListener2 {

    private static final String TAG = "opencv";
    private Mat matInput;
    private Mat matResult;

    private CameraBridgeViewBase mOpenCvCameraView;

    //public native int opencvround(long matAddrInput, long matAddrResult);
    public native String opencvboth(long matAddrInput, long matAddrResult);

    //동작 측정 함수
    public Juggling_Function ball_function;

    //동작 형태, 개수를 나타내는 TEXTVIEW
    TextView jugglingname_textview;
    TextView jugglingcount_textview;
    TextView jugglingstatus_textview;

    //측정해야할 동작 관련 Array (동작이름, 개수, 제한시간)
    private  ArrayList<String> jugglingname_array;
    private  ArrayList<Integer> jugglingcount_array;
    private  ArrayList<Integer> jugglingtime_array;

    //동작 이름
    private String juggling_name;
    private int juggling_count;
    private int juggling_time;
    private boolean juggling_status;



    static {
        System.loadLibrary("opencv_java3");
        System.loadLibrary("native-lib");
    }



    private BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(this) {
        @Override
        public void onManagerConnected(int status) {
            switch (status) {
                case LoaderCallbackInterface.SUCCESS:
                {
                    mOpenCvCameraView.enableView();
                } break;
                default:
                {
                    super.onManagerConnected(status);
                } break;
            }
        }
    };




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        setContentView(R.layout.activity_juggling);

        mOpenCvCameraView = (CameraBridgeViewBase)findViewById(R.id.activity_surface_view);
        mOpenCvCameraView.setVisibility(SurfaceView.VISIBLE);
        mOpenCvCameraView.setCvCameraViewListener(this);
        mOpenCvCameraView.setCameraIndex(1);

        jugglingname_textview = findViewById(R.id.jugglingname_textview);
        jugglingcount_textview = findViewById(R.id.jugglingcount_textview);
        jugglingstatus_textview = findViewById(R.id.jugglingstatus_textview);

        jugglingname_textview.setText("동작");
        jugglingcount_textview.setText("개수");
        jugglingstatus_textview.setText("상태");


        //저글링 종목 arraylist
        jugglingname_array = new ArrayList<String>();
        jugglingname_array.add("동시 공던져잡기");
        jugglingname_array.add("번갈아 공던져잡기");
        //저글링 개수 arraylist
        jugglingcount_array = new ArrayList<Integer>();
        jugglingcount_array.add(3);
        jugglingcount_array.add(4);
        //저글링 시간 arraylist
        jugglingtime_array = new ArrayList<Integer>();
        jugglingtime_array.add(60000);
        jugglingtime_array.add(50000);


        juggling_status = false;
    }


    @Override
    public void onResume()
    {
        super.onResume();

        if (!OpenCVLoader.initDebug()) {
            Log.d(TAG, "onResume :: Internal OpenCV library not found.");
            OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_2_0, this, mLoaderCallback);
        } else {
            Log.d(TAG, "onResume :: OpenCV library found inside package. Using it!");
            mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
        }




    }

    @Override
    public void onPause()
    {
        super.onPause();
        if (mOpenCvCameraView != null)
            mOpenCvCameraView.disableView();

    }


    public void onDestroy() {
        super.onDestroy();

        if (mOpenCvCameraView != null)
            mOpenCvCameraView.disableView();

        Juggling_Information.ball_position_red = 0;
        Juggling_Information.ball_position_blue = 0;
        Juggling_Information.ball_count = 0;
        Juggling_Information.array_count = 0;
        Juggling_Information.ball_arraylist.clear();


        //화면 전환시, 넘겨받은 배열 데이터 초기화
        jugglingname_array.clear();
        jugglingcount_array.clear();
        jugglingtime_array.clear();
    }

    @Override
    public void onCameraViewStarted(int width, int height) {

    }

    @Override
    public void onCameraViewStopped() {

    }

    @Override
    public Mat onCameraFrame(CameraBridgeViewBase.CvCameraViewFrame inputFrame) {



        matInput = inputFrame.rgba();

        //카메라 mirror image
        Core.flip(matInput, matInput, 1);

        if ( matResult == null ){
            matResult = new Mat(matInput.rows(), matInput.cols(), matInput.type());
        }


        String opencvboth = opencvboth(matInput.getNativeObjAddr(), matResult.getNativeObjAddr());
        String[] opencvboth_array = opencvboth.split(",");


        if(Juggling_Information.array_count==-1){
            Log.d("동작측정여부", "동작측정중지");
            //array_count가 -1일 경우 카메라 중지
            if (mOpenCvCameraView != null)
                mOpenCvCameraView.disableView();
        }else if(jugglingname_array.size() == Juggling_Information.array_count) {
            Log.d("동작측정여부", "동작측정종료");
            Log.d("동작측정여부 jugglingname_array.size()", String.valueOf(jugglingname_array.size()));
            Log.d("동작측정여부 Juggling_Information.array_count", String.valueOf(Juggling_Information.array_count));

            //개수 -1로 변경 (1번만 작동하도록)
            Juggling_Information.array_count=-1;
            //동작을 다 실행한 경우 액티비티 이동
            Log.d("동작 실행 완료", "동작 " + String.valueOf(jugglingname_array.size()) + "개 실행 완료");
            Intent intent = new Intent(JugglingActivity.this, GetDateActivity_kt.class);
            startActivity(intent);
            finish();
        }else if(jugglingname_array.size() > Juggling_Information.array_count && 0 <= Juggling_Information.array_count){
            Log.d("동작측정여부", "동작측정중");

            //동작 설정
            juggling_name= jugglingname_array.get(Juggling_Information.array_count);
            //개수 설정
            juggling_count= jugglingcount_array.get(Juggling_Information.array_count);
            //시간 설정
            juggling_time= jugglingtime_array.get(Juggling_Information.array_count);
            //상태 설정


            Log.d("저글링배열-jugglingname_array",juggling_name);
            Log.d("저글링배열-jugglingcount_array", String.valueOf(juggling_count));
            Log.d("저글링배열-jugglingtime_array", String.valueOf(juggling_time));

            //화면에 뿌려지는 동작명/개수/상태
            jugglingname_textview.setText(juggling_name);
            jugglingcount_textview.setText(String.valueOf(Juggling_Information.ball_count)+"/"+String.valueOf(jugglingcount_array.get(Juggling_Information.array_count)));
            if(juggling_status){
                jugglingstatus_textview.setText("O");
            }else{
                jugglingstatus_textview.setText("X");
            }

            // 해당 동작의 개수를 모두 완료했을 경우
            if(Juggling_Information.ball_count==jugglingcount_array.get(Juggling_Information.array_count)){
                Log.d("동작 변경", "개수 완료 or 시간 종료");
                //동작측정 변경사항 (실행결과 저장 변경)
                ////////////////////////////////////////// 완료한 동작 개수저장 후 -> 다음동작으로 이동 //////////////////////////////////////

                //완료한 동작의 (실행 개수 / 총 개수) 저장
                double juggling_score =  Math.round((Juggling_Information.ball_count/(double)jugglingcount_array.get(Juggling_Information.array_count))*100);
                ResultInformation.result_list.add(juggling_name+"-"+ Juggling_Information.ball_count +"/"+ jugglingcount_array.get(Juggling_Information.array_count)
                        +"/"+ juggling_score);
                // 해당 동작의 개수를 모두 완료했거나, 타이머의 시간이 종료되었을 경우 -> 다음 동작으로 이동
                Juggling_Information.array_count= Juggling_Information.array_count+1;
                Log.d("저글링변경 : 배열 인덱스 ", String.valueOf(Juggling_Information.array_count));
                ////////////////////////////////////////// 완료한 동작 개수저장 후 -> 다음동작으로 이동 //////////////////////////////////////

                //저글링 상태, 개수, 스코어, 각도, 리스트 초기화
                Juggling_Information.ball_position_red = 0;
                Juggling_Information.ball_position_blue = 0;
                Juggling_Information.ball_count = 0;
                Juggling_Information.ball_arraylist.clear();

            }


            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


            int red_x = Integer.parseInt(opencvboth_array[0]);
            int red_y = Integer.parseInt(opencvboth_array[1]);
            int blue_x = Integer.parseInt(opencvboth_array[2]);
            int blue_y = Integer.parseInt(opencvboth_array[3]);

            if(red_x !=0 && red_y !=0 && blue_x !=0 && blue_y !=0){

                juggling_status=true;
                Log.d(TAG, "빨간공: 추적 가능");

                if(red_x>360 && red_y<240){
                    Log.d(TAG, "빨간공: 1사분면");
                    Log.d(TAG, "빨간공  x좌표: " + opencvboth_array[0]);
                    Log.d(TAG, "빨간공  y좌표: " + opencvboth_array[1]);

                    Juggling_Information.ball_position_red = 1;

                }else if(red_x<360 && red_y<240){
                    Log.d(TAG, "빨간공: 2사분면");
                    Log.d(TAG, "빨간공  x좌표: " + opencvboth_array[0]);
                    Log.d(TAG, "빨간공  y좌표: " + opencvboth_array[1]);

                    Juggling_Information.ball_position_red = 2;

                }else if(red_x<360 && red_y>240){
                    Log.d(TAG, "빨간공: 3사분면");
                    Log.d(TAG, "빨간공  x좌표: " + opencvboth_array[0]);
                    Log.d(TAG, "빨간공  y좌표: " + opencvboth_array[1]);

                    Juggling_Information.ball_position_red = 3;

                }else if(red_x>360 && red_y>240){
                    Log.d(TAG, "빨간공: 4사분면");
                    Log.d(TAG, "빨간공  x좌표: " + opencvboth_array[0]);
                    Log.d(TAG, "빨간공  y좌표: " + opencvboth_array[1]);

                    Juggling_Information.ball_position_red = 4;
                }


                /////////////////////////////////////////////////////////////////////////


                if(blue_x>360 && blue_y<240){
                    Log.d(TAG, "파란공: 1사분면");
                    Log.d(TAG, "파란공  x좌표: " + opencvboth_array[2]);
                    Log.d(TAG, "파란공  y좌표: " + opencvboth_array[3]);

                    Juggling_Information.ball_position_blue = 1;

                }else if(blue_x<360 && blue_y<240){
                    Log.d(TAG, "파란공: 2사분면");
                    Log.d(TAG, "파란공  x좌표: " + opencvboth_array[2]);
                    Log.d(TAG, "파란공  y좌표: " + opencvboth_array[3]);

                    Juggling_Information.ball_position_blue = 2;

                }else if(blue_x<360 && blue_y>240){
                    Log.d(TAG, "파란공: 3사분면");
                    Log.d(TAG, "파란공  x좌표: " + opencvboth_array[2]);
                    Log.d(TAG, "파란공  y좌표: " + opencvboth_array[3]);

                    Juggling_Information.ball_position_blue = 3;

                }else if(blue_x>360 && blue_y>240){
                    Log.d(TAG, "파란공: 4사분면");
                    Log.d(TAG, "파란공  x좌표: " + opencvboth_array[2]);
                    Log.d(TAG, "파란공  y좌표: " + opencvboth_array[3]);

                    Juggling_Information.ball_position_blue = 4;
                }

                ball_function = new Juggling_Function();


                if(juggling_name=="동시 공던져잡기"){
                    ball_function.same();
                }else if(juggling_name=="번갈아 공던져잡기"){
                    ball_function.cross();
                }else if(juggling_name=="헛갈려 공던져잡기(반시계)"){
                    ball_function.turn_anticlock();
                }else if(juggling_name=="헛갈려 공던져잡기(시계)"){
                    ball_function.turn_clock();
                }else if(juggling_name=="기본 저글링잡기"){
                    ball_function.basic();
                }else if(juggling_name=="동시 엇갈려 저글링잡기"){
                    ball_function.same_cross();
                }else if(juggling_name=="한손고정 엇갈려잡기(반시계)"){
                    //반시계 방향
                    ball_function.onehand_anticlock(red_x,red_y,blue_x,blue_y);
                }else if(juggling_name=="한손고정 엇갈려잡기(시계)"){
                    //시계 방향
                    ball_function.onehand_clock(red_x,red_y,blue_x,blue_y);
                }else if(juggling_name=="두손으로 한공잡기"){
                    //번갈아 공던져잡기과 동일한 알고리즘
                    ball_function.cross();
                }




            }else{
                juggling_status=false;
                Log.d(TAG, "빨간공 or 파란공: 추적 불가");
                //공 포지션 0
                Juggling_Information.ball_position_red = 0;
                //공 포지션 0
                Juggling_Information.ball_position_blue = 0;
                //공 위치 배열 Clear
                Juggling_Information.ball_arraylist.clear();

            }


//            //동작, 개수, 상태 TEXTVIEW에 나타내기
//            new Thread(new Runnable() {
//                @Override
//                public void run() {
//                    runOnUiThread(new Runnable(){
//                        @Override
//                        public void run() {
//
//                            // VIEW 설정
//                            jugglingname_textview.setText(juggling_name);
//                            jugglingcount_textview.setText(String.valueOf(Juggling_Information.ball_count)+"/"+String.valueOf(jugglingcount_array.get(Juggling_Information.array_count)));
//                            if(juggling_status){
//                                jugglingstatus_textview.setText("O");
//                            }else{
//                                jugglingstatus_textview.setText("X");
//                            }
//
//                        }
//                    });
//                }
//            }).start();
        }





        return matResult;
    }



    protected List<? extends CameraBridgeViewBase> getCameraViewList() {
        return Collections.singletonList(mOpenCvCameraView);
    }


    //여기서부턴 퍼미션 관련 메소드
    private static final int CAMERA_PERMISSION_REQUEST_CODE = 200;


    protected void onCameraPermissionGranted() {
        List<? extends CameraBridgeViewBase> cameraViews = getCameraViewList();
        if (cameraViews == null) {
            return;
        }
        for (CameraBridgeViewBase cameraBridgeViewBase: cameraViews) {

            if (cameraBridgeViewBase != null) {
                //cameraBridgeViewBase.setCameraPermissionGranted();
            }
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        boolean havePermission = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(CAMERA) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{CAMERA}, CAMERA_PERMISSION_REQUEST_CODE);
                havePermission = false;
            }
        }
        if (havePermission) {
            onCameraPermissionGranted();
        }
    }



    @Override
    @TargetApi(Build.VERSION_CODES.M)
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE && grantResults.length > 0
                && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            onCameraPermissionGranted();
        }else{
            showDialogForPermission("앱을 실행하려면 퍼미션을 허가하셔야합니다.");
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }


    @TargetApi(Build.VERSION_CODES.M)
    private void showDialogForPermission(String msg) {

        AlertDialog.Builder builder = new AlertDialog.Builder(JugglingActivity.this);
        builder.setTitle("알림");
        builder.setMessage(msg);
        builder.setCancelable(false);
        builder.setPositiveButton("예", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id){
                requestPermissions(new String[]{CAMERA}, CAMERA_PERMISSION_REQUEST_CODE);
            }
        });
        builder.setNegativeButton("아니오", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface arg0, int arg1) {
                finish();
            }
        });
        builder.create().show();
    }


}