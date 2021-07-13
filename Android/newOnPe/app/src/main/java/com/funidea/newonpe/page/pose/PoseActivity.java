package com.funidea.newonpe.page.pose;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.media.MediaFormat;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Handler;
import android.text.Html;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.DrawableImageViewTarget;
import com.bumptech.glide.request.target.Target;
import com.funidea.newonpe.page.main.ExerciseRecordPage;
import com.funidea.newonpe.R;
import com.funidea.utils.convert_time;
import com.funidea.newonpe.camera.CameraSource;
import com.funidea.newonpe.camera.CameraSourcePreview;
import com.funidea.newonpe.camera.GraphicOverlay;
import com.funidea.newonpe.detector.PoseDetectorProcessor;
import com.funidea.newonpe.detector.PoseGraphic;
import com.funidea.newonpe.detector.PoseInformation;
import com.funidea.newonpe.detector.PoseMeasureFunction;
import com.funidea.newonpe.detector.Pose_ResultInformation;
import com.funidea.newonpe.detector.ResultInformation;
import com.funidea.newonpe.preference.PreferenceUtils;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetectorOptionsBase;
import com.homesoft.encoder.FrameMuxer;
import com.homesoft.encoder.Mp4FrameMuxer;
import com.homesoft.encoder.Muxer;
import com.homesoft.encoder.MuxerConfig;
import com.homesoft.encoder.MuxingCompletionListener;

import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;
import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import static com.funidea.utils.set_User_info.getStudent_name;

import static com.funidea.utils.set_User_info.setStudent_recent_exercise_date;
import static com.funidea.newonpe.detector.PoseGraphic.draw_value;

public class PoseActivity extends AppCompatActivity
        implements ActivityCompat.OnRequestPermissionsResultCallback,
        AdapterView.OnItemSelectedListener,
        CompoundButton.OnCheckedChangeListener {



    private BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(this) {
        @Override
        public void onManagerConnected(int status) {
            switch (status) {
                case LoaderCallbackInterface.SUCCESS:
                {

                } break;
                default:
                {
                    super.onManagerConnected(status);
                } break;
            }
        }
    };

    //동작 인식 관련 소스
    private static final String POSE_DETECTION = "Pose Detection";
    private static final String TAG = "LivePreviewActivity";
    private static final int PERMISSION_REQUESTS = 1;

    //카메라 관련
    private CameraSource            cameraSource = null;
    private CameraSourcePreview     preview;
    //포즈 인식 관련
    private GraphicOverlay          graphicOverlay;


    private String selectedModel = POSE_DETECTION;
    private Pose pose;

    public static String pose_class_code = "";
    public static String pose_unit_code ="";

    public static int bitmap_width = 0;
    public static int bitmap_height =0;
    //시간 데이터
    // 현재시간을 msec 으로 구한다.
    long now = System.currentTimeMillis();
    // 현재시간을 date 변수에 저장한다.
    Date date = new Date(now);
    // 시간을 나타냇 포맷을 정한다 ( yyyy/MM/dd 같은 형태로 변형 가능 )
    SimpleDateFormat sdfNow = new SimpleDateFormat("yyyyMMddHHmmss");
    // nowDate 변수에 값을 저장한다.
    String formatDate = sdfNow.format(date);

    //동작 측정 함수
    public PoseMeasureFunction posemeasurefunction;
    //스켈레톤 좌표 변수 모음
    Float leftShoulder_x, leftShoulder_y, rightShoulder_x,rightShoulder_y,leftElbow_x,leftElbow_y,rightElbow_x,rightElbow_y,leftWrist_x,leftWrist_y,rightWrist_x,rightWrist_y;
    Float leftHip_x,leftHip_y,rightHip_x,rightHip_y,leftKnee_x,leftKnee_y,rightKnee_x,rightKnee_y,leftAnkle_x,leftAnkle_y,rightAnkle_x,rightAnkle_y,leftPinky_x,leftPinky_y,rightPinky_x,rightPinky_y;
    Float leftIndex_x,leftIndex_y,rightIndex_x,rightIndex_y,leftThumb_x,leftThumb_y,rightThumb_x,rightThumb_y,leftHeel_x,leftHeel_y,rightHeel_x,rightHeel_y,leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y;
    Float leftEar_x,leftEar_y,rightEar_x,rightEar_y;

   /* //타이머 관련 변수
    private CountDownTimer mCountDownTimer;
    private boolean mTimerRunning;
    private long mTimeLeftInMillis;
    private String timeLeftFormatted = "";*/


    //타이머 관련 함수
    private static long START_TIME_IN_MILLIS = 0;
    private CountDownTimer mCountDownTimer;
    private boolean mTimerRunning;
    private long mTimeLeftInMillis = START_TIME_IN_MILLIS;


    //운동 시작 타이머
    private static long Pose_FIRST_START_TIME_IN_MILLIS =10000;
    private CountDownTimer Pose_Start_mCountDownTimer;
    private boolean Pose_Start_mTimerRunning;
    private long Pose_Start_mTimeLeftInMillis = Pose_FIRST_START_TIME_IN_MILLIS;
    //운동 시작 전 카운트다운 타이머
    TextView pose_activity_start_timer_textview;
    //운동 시작 버튼
    TextView pose_activity_start_button_textview;
    //운동 시작 버튼 레이아웃
    LinearLayout pose_activity_start_linearlayout;

    //동작 개수를 나타내줄 TextView
    TextView pose_activity_count_textview;
    //포즈 Count Animaiton
    Animation pose_count_start_animation;
    Animation pose_count_end_animation;
    //포즈 카운트 값 비교
    private  int pose_count_value = 0;

    //다음 운동 시작 전 타이머 레이아웃

    Animation next_exercise_start_animation;
    Animation next_exercise_end_animation;

    //부모 레이아웃
    LinearLayout next_exercise_post_parent_layout;
    //다음 운동 이름
    TextView next_exercise_pose_name_textview;
    //돌아가기
    TextView next_exercise_pose_reset_textview;
    //일시정지 / 다시 시작
    TextView next_exercise_pose_pause_textview;
    //카운트 다운
    TextView next_exercise_pose_count_textview;

    private static long Next_Pose_START_TIME_IN_MILLIS = 6000;
    private CountDownTimer Next_Pose_mCountDownTimer;
    private boolean Next_Pose_mTimerRunning;
    private long Next_Pose_mTimeLeftInMillis = Next_Pose_START_TIME_IN_MILLIS;

    private  int Next_Pose_mTimerRunning_value = 0;

    private int Next_Pose_pause_value = 0;


    //동작이름, 제한시간 카운트, 평가, 평가리스트 Textview
    private TextView posename_textview;
    private TextView posetime_textview;
    private TextView posecount_textview;
    private TextView posescore_textview;
    private TextView posescorelist_textview;

    //측정해야할 동작 관련 Array (동작이름, 개수, 제한시간)
    private  ArrayList<String> posename_array; //동작이름
    private  ArrayList<String> pose_category_name_array;//동작 카테고리
    private  ArrayList<String> pose_detail_name_array;//동작 상세 이름
    private  ArrayList<Integer> posecount_array; //카운트
    private  ArrayList<Integer> posetime_array; //시간
    private  ArrayList<String> pose_gif_url_array; //시간

    //콘텐츠 네임
    private ArrayList<String> pose_content_name_array;//운동 종목명

    //각각의 동작 이름, 개수, 제한시간
    private String pose_name;//동작이름
    public static String get_pose_category_name="홈트레이닝";
    private String pose_category_name; //동작 카테고리 이름
    private String pose_detail_name;//동작 상세 이름
    private String pose_content_name;
    private int pose_count;//카운트
    private int pose_time;//시간


    //포즈 인식 원 이미지
    public static ImageView pose_estimation_imageview;
    //포즈동작명 관련 리사이클러뷰
    private ArrayList<pose_name_Item> pose_name_item = new ArrayList<>();
    private pose_name_Adapter  pose_name_adapter;
    RecyclerView pose_recyclerview;

    //메인 이미지 View
    ImageView main_imageview;
    //리셋 버튼
    TextView pose_reset_button_textview;


    public static Boolean photo_value = false;
    public static int photo_capture_value = 0;

    //사이드 작은 이미지 View
    public static ImageView imageView;
    //사이드 gif 이미지
    public ImageView side_gif_imageview;
    public static int side_image_value = 0;
    //포즈 담기 ArrayList
    ArrayList pose_resultInformation;

    //타이머 Start valuef
    boolean start_timer_value = false;

    //카메라 전환 토글
    ToggleButton facingSwitch;

    //운동 완료시 보여줄 layout
    LinearLayout pose_complete_layout;
    //완료하기 버튼 TextView
    TextView pose_complete_move_textview;
    //기록확인 TextView
    TextView pose_complete_show_record_textview;
    //처음부터 다시하기
    TextView pose_complete_reset_textview;
    //부모 레이아웃
    LinearLayout pose_complete_linearlayout;

    //선택버튼
    TextView pose_class_textview;
    //private MediaRecorder mediaRecorder;
    private MediaRecorder recorder;
    boolean recording = false;

    String content_title = "";
    int position_number = 0;
    int array_size = 0;

    String class_code = "";
    String unit_class_code = "";
    String class_title = "";
    //좌측하단 운동명 입력해주기
    TextView pose_exercise_name_textview;

    ProgressBar progressBar ;

    int on_display_value = 0;





    //비디오 저장
    public static boolean recordBool = false;
    public static ArrayList<Bitmap> getBitMapList = new ArrayList<>();
    String filename;
    public boolean exercise_boolean = false;

    //운동 완료 애니메이션
    Animation pose_complete_start_animation;
    Animation pose_complete_end_animation;

    //작은 화면 포즈 보여주기
    FrameLayout pose_gif_framelayout;
    //화면 전환
    LinearLayout change_camera_linearlayout;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pose);


        setStudent_recent_exercise_date(formatDate);

        pose_resultInformation = new ArrayList<Pose_ResultInformation>();

        on_display_value = 1;

        //프로그래스바
        progressBar = findViewById(R.id.pose_activity_progressbar);

        //콘텐츠 타이틀
        pose_class_textview  = findViewById(R.id.pose_class_textview);
        pose_class_textview.setOnClickListener(captrureListener);

        //운동 종목 / 현재 운동 중인 것의 이름
        pose_exercise_name_textview = findViewById(R.id.pose_exercise_name_textview);

        //메인 이미지 View
        main_imageview = findViewById(R.id.main_imageview);

        //사이드 이미지 View
        side_gif_imageview = findViewById(R.id.side_gif_imageview);
        side_gif_imageview.setVisibility(View.VISIBLE);
        side_gif_imageview.setOnClickListener(change_gif_size);

        //리셋 버튼 //이전 동작으로 돌아가야함.
        pose_reset_button_textview = findViewById(R.id.pose_reset_button_textview);
        pose_reset_button_textview.setOnClickListener(reset_button);


        imageView = findViewById(R.id.side_user_imageview);
        imageView.setOnClickListener(change_gif_size);


        //imageView.setDrawingCacheEnabled(true);
        //imageView.getDrawingCache();
        Log.d(TAG, "onCreate: "+ convert_time.Companion.set_convert_time(100));


        //포즈 측정 가능 여부
        pose_estimation_imageview  = findViewById(R.id.pose_estimation_imageview);

        //카메라 뷰
        preview = findViewById(R.id.preview_view);

        //preview2 = findViewById(R.id.preview_view2);


        if (preview == null) {
            Log.d(TAG, "Preview is null");
        }
        //좌표 (점,선) 그리는 뷰
        graphicOverlay = findViewById(R.id.graphic_overlay);


        if (graphicOverlay == null) {
            Log.d(TAG, "graphicOverlay is null");
        }
        //카메라 화면 전환
         facingSwitch = findViewById(R.id.facing_switch);

        facingSwitch.setOnCheckedChangeListener(this);

        change_camera_linearlayout = findViewById(R.id.change_camera_linearlayout);

        //카메라 전환 관련
        change_camera_linearlayout.setOnClickListener(change_gif_size);


        //퍼미션 있을 경우
        //카메라 시작 관련 코드
        if (allPermissionsGranted()) {

            createCameraSource(selectedModel);

        }
        else {
            getRuntimePermissions();
        }


        //View 설정
        //동작 이름
        posename_textview =  findViewById(R.id.posename_textview);
        //동작 제한시간
        posetime_textview = findViewById(R.id.posetime_textview);
        //동작 개수
        posecount_textview = findViewById(R.id.posecount_textview);
        //동작 평가 (BAD, NORMAL, GOOD)
        posescore_textview = findViewById(R.id.posescore_textview);
        //동작 평가 리스트
        posescorelist_textview = findViewById(R.id.posescorelist_textview);


        //이전 액티비티에서 받아온 ARRAYLIST (INTENT)로 받아올듯
        //종목 arraylist
        posename_array = new ArrayList<String>();
        //posename_array.add("스쿼트");
        //posename_array.add("스쿼트");
        //posename_array.add("푸쉬업");
        //posename_array.add("푸쉬업");
        //posename_array.add("브이업");
        //개수 arraylist
        pose_category_name_array = new ArrayList<String>();
        //pose_category_name_array.add("하체운동");
        //pose_category_name_array.add("하체운동");

        pose_detail_name_array = new ArrayList<String>();
        // pose_detail_name_array.add("기본 스쿼트");
        //pose_detail_name_array.add("기본 스쿼트");

        posecount_array = new ArrayList<Integer>();
        //posecount_array.add(2);
        //posecount_array.add(3);
        //posecount_array.add(7);
        //posecount_array.add(7);
        //시간 arraylist
        posetime_array = new ArrayList<Integer>();

        pose_gif_url_array  = new ArrayList<String>();

        pose_content_name_array = new ArrayList<String>();

        pose_recyclerview = findViewById(R.id.pose_recyclerview);

        //pose_name_item.add(new pose_name_Item("1번동작"));
        //pose_name_item.add(new pose_name_Item("2번동작"));
        //pose_name_item.add(new pose_name_Item("3번동작"));
        //pose_name_item.add(new pose_name_Item("4번동작"));
        //리사이클러뷰 셋팅 - 테스트용

        get_content_info();

        //시작하기 버튼
        pose_activity_start_button_textview = findViewById(R.id.pose_activity_start_button_textview);
        //시작하기 버튼 레이아웃
        pose_activity_start_linearlayout = findViewById(R.id.pose_activity_start_linearlayout);
        //타이머 보여줄 TextView
        pose_activity_start_timer_textview = findViewById(R.id.pose_activity_start_timer_textview);

        pose_activity_start_button_textview.setOnClickListener(start_button);

        //포즈 개수를 보여줄 TextView
        pose_activity_count_textview = findViewById(R.id.pose_activity_count_textview);

        //작은화면에서 보여지는 gif 부모 FrameLayout
        pose_gif_framelayout = findViewById(R.id.pose_gif_framelayout);

        //다음 운동 때 보여질 레이아웃
        set_next_exercise_layout();
        //운동 완료시 보여질 layout
        set_complete_layout();

        //과제인지 평가인지 구분해주기!
        evalutation_setting();
    }

    public void evalutation_setting()
    {
        if(evaluation_value.equals("1"))
        {
            pose_gif_framelayout.setVisibility(View.GONE);
            imageView.setVisibility(View.GONE);
            side_gif_imageview.setVisibility(View.GONE);
            main_imageview.setVisibility(View.GONE);
            change_camera_linearlayout.setVisibility(View.GONE);

        }
    }

    //운동 완료시 보여질 layout
    public void set_complete_layout()
    {

        pose_complete_start_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_in);// Create the animation.
        pose_complete_end_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_out);// Create the animation.

        //부모레이아웃
        pose_complete_layout = findViewById(R.id.pose_complete_layout);
        //완료하기 레이아웃
        pose_complete_move_textview = findViewById(R.id.pose_complete_move_textview);
        pose_complete_move_textview.setOnClickListener(exercise_complete_button);
        //기록 확인
        pose_complete_show_record_textview = findViewById(R.id.pose_complete_show_record_textview);
        pose_complete_show_record_textview.setOnClickListener(show_exercise_record);
        //처음부터
        pose_complete_reset_textview = findViewById(R.id.pose_complete_reset_textview);
        pose_complete_reset_textview.setOnClickListener(exercise_again);
        //부모 레이아웃
        //pose_complete_linearlayout = findViewById(R.id.pose_complete_linearlayout);


    }

    public void set_next_exercise_layout()
    {
        //다음 운동 시작 전 화면 보여주기
        next_exercise_post_parent_layout = findViewById(R.id.next_exercise_post_parent_layout);
        //운동 카운트 버튼 5초
        next_exercise_pose_count_textview = findViewById(R.id.next_exercise_pose_count_textview);
        //운동명
        next_exercise_pose_name_textview = findViewById(R.id.next_exercise_pose_name_textview);

        //운동 정지 / 재시작 버튼
        next_exercise_pose_pause_textview = findViewById(R.id.next_exercise_pose_pause_textview);
        next_exercise_pose_pause_textview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(Next_Pose_pause_value==0)
                {
                    Next_Pose_pause_value =1;
                    Next_Exercise_pauseTimer();
                    next_exercise_pose_pause_textview.setText("다시시작");
                    next_exercise_pose_pause_textview.setTextColor(Color.parseColor("#FFFFFF"));
                    next_exercise_pose_pause_textview.setBackgroundResource(R.drawable.view_main_color_round_button);
                }
                else
                {

                    Next_Exercise_startTimer();
                    Next_Pose_pause_value = 0;
                    next_exercise_pose_pause_textview.setText("일시정지");
                    next_exercise_pose_pause_textview.setTextColor(Color.parseColor("#3378fd"));
                    next_exercise_pose_pause_textview.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge);

                }

            }
        });

        //운동 리셋 버튼 - 이전 운동으로 돌아간다.
        next_exercise_pose_reset_textview = findViewById(R.id.next_exercise_pose_reset_textview);
        next_exercise_pose_reset_textview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Next_Exercise_pauseTimer();
                Next_Exercise_resetTimer();

                if(PoseInformation.array_count>=1)
                {
                    pose_name_item.get(PoseInformation.array_count - 1).setPose_value(1);
                    pose_name_item.get(PoseInformation.array_count).setPose_value(0);
                    pose_name_adapter.notifyDataSetChanged();
                }

                PoseInformation.array_count=PoseInformation.array_count-1;

                START_TIME_IN_MILLIS = posetime_array.get(PoseInformation.array_count);
                mTimeLeftInMillis= START_TIME_IN_MILLIS;


                pose_resultInformation.remove(pose_resultInformation.size()-1);


                next_exercise_end_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_out);// Create the animation.
                next_exercise_post_parent_layout.startAnimation(next_exercise_end_animation);

                next_exercise_end_animation.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {

                    }

                    @Override
                    public void onAnimationEnd(Animation animation)
                    {
                        Next_Pose_mTimerRunning_value = 0;
                        startTimer();

                        Next_Pose_pause_value = 0;
                        next_exercise_pose_pause_textview.setText("일시정지");
                        next_exercise_pose_pause_textview.setTextColor(Color.parseColor("#3378fd"));
                        next_exercise_pose_pause_textview.setBackgroundResource(R.drawable.view_main_color_in_white_round_edge);

                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });

            }
        });
    }

    //운동완료하기
    View.OnClickListener exercise_complete_button = new View.OnClickListener() {
        @Override
        public void onClick(View view) {


            Intent intent = new Intent(PoseActivity.this, GetDateActivity_kt.class);


            intent.putExtra("class_code", class_code);
            intent.putExtra("unit_code", unit_class_code);
            intent.putExtra("pose_result_Array", pose_resultInformation);
            intent.putExtra("content_title", content_title);
            intent.putExtra("position_number", position_number);
            intent.putExtra("array_size", array_size);

            startActivity(intent);
            next_exercise_post_parent_layout.setVisibility(View.GONE);
            finish();


        }
    };
    //운동 처음부터 다시하기
    View.OnClickListener exercise_again = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            //pose_complete_layout.setVisibility(View.INVISIBLE);
           // pose_activity_start_linearlayout.bringToFront();
            //pose_activity_start_linearlayout.setVisibility(View.VISIBLE);
            Intent intent = new Intent(PoseActivity.this, PoseActivity.class);

            intent.putExtra("evaluation_value", evaluation_value);
            intent.putExtra("class_title", class_title);
            intent.putExtra("class_code", class_code);
            intent.putExtra("unit_code", unit_class_code);
            intent.putExtra("content_title", content_title);
            intent.putExtra("position_number", position_number);
            intent.putExtra("array_size", array_size);
            intent.putExtra("content_name_list", content_name_list);
            intent.putExtra("content_cateogry_list", content_cateogry_list);
            intent.putExtra("content_type_list", content_type_list);
            intent.putExtra("content_detail_name_list", content_detail_name_list);
            intent.putExtra("content_count_list", content_count_list);
            intent.putExtra("content_time", content_time);
            intent.putExtra("content_url", content_url);
            intent.putExtra("content_level_list", content_level_list);

            startActivity(intent);
            finish();
            overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
        }
    };

    //운동 결과 보기
    View.OnClickListener show_exercise_record = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            Intent intent = new Intent(PoseActivity.this, ExerciseRecordPage.class);

            intent.putExtra("evaluation_value", evaluation_value);
            intent.putExtra("class_title", class_title);
            intent.putExtra("class_code", class_code);
            intent.putExtra("unit_code", unit_class_code);
            intent.putExtra("pose_result_Array", pose_resultInformation);
            intent.putExtra("content_title", content_title);
            intent.putExtra("position_number", position_number);
            intent.putExtra("array_size", array_size);
            intent.putExtra("content_name_list", content_name_list);
            intent.putExtra("content_cateogry_list", content_cateogry_list);
            intent.putExtra("content_type_list", content_type_list);
            intent.putExtra("content_detail_name_list", content_detail_name_list);
            intent.putExtra("content_count_list", content_count_list);
            intent.putExtra("content_time", content_time);
            intent.putExtra("content_url", content_url);
            intent.putExtra("content_level_list", content_level_list);




            startActivity(intent);
            finish();

        }
    };


    //보여지는 GIF or 사용자 영상 이미지 전환
    View.OnClickListener change_gif_size = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            if(facingSwitch.isChecked())
            {
                facingSwitch.setChecked(false);

            }
            else
            {
                facingSwitch.setChecked(true);

            }

        }
    };



    View.OnClickListener start_button = new View.OnClickListener() {
        @Override
        public void onClick(View view) {


            pose_activity_start_button_textview.setVisibility(View.GONE);

            //동작 측정 함수
            pose_activity_start_timer_textview.setVisibility(View.VISIBLE);

            //타이머 시작
            Pose_start_startTimer();


        }
    };


    //private static String filename = "";
    View.OnClickListener captrureListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            //본인 사진 저장 및 서버 업로드 연결
            // photo_value = true;

            if(recordBool){

                Toast.makeText(getApplicationContext(), "녹화종료", Toast.LENGTH_SHORT).show();
                //record_btn.setText("기록 시작");
                filename = Environment.getExternalStorageDirectory()+"/DCIM/Camera/"+formatDate+getStudent_name()+"평가제출영상.mp4";

                FrameMuxer frameMuxer = new Mp4FrameMuxer(filename, 10F);
                MuxerConfig muxerConfig = new MuxerConfig(new File(filename),bitmap_width,bitmap_height, MediaFormat.MIMETYPE_VIDEO_AVC,1,10F,1500000,frameMuxer,100000);
                Muxer muxer = new Muxer(getApplication().getApplicationContext(), muxerConfig);
                muxer.setMuxerConfig(muxerConfig);

                muxer.setOnMuxingCompletedListener(new MuxingCompletionListener() {
                    @Override
                    public void onVideoSuccessful(@NotNull File file) {
                            /*
                            File file = new File(filename);
                            */
                        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                        intent.setData(Uri.fromFile(file));
                        sendBroadcast(intent);
                        Log.d(TAG, "Video muxed - file path: " + file.getAbsolutePath());
                        getBitMapList.clear();


                    }

                    @Override
                    public void onVideoError(@NotNull Throwable throwable) {
                        Log.d(TAG, "There was an error muxing the video");
                    }
                });
                new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        muxer.mux(getBitMapList,R.raw.input_audio);
                        //a.mux(getBitMapList,null);
                    }
                });


            }
            else {
                //record_btn.setText("기록종료");
                Toast.makeText(getApplicationContext(), "녹화시작", Toast.LENGTH_SHORT).show();
            }

            recordBool = !recordBool;


        }
    };

    public void set_record_evaluation()
    {
        if(recordBool){

            Toast.makeText(getApplicationContext(), "녹화종료", Toast.LENGTH_SHORT).show();
            //record_btn.setText("기록 시작");
            filename = Environment.getExternalStorageDirectory()+"/DCIM/Camera/"+formatDate+getStudent_name()+"평가제출영상.mp4";

            FrameMuxer frameMuxer = new Mp4FrameMuxer(filename, 10F);
            MuxerConfig muxerConfig = new MuxerConfig(new File(filename),bitmap_width,bitmap_height, MediaFormat.MIMETYPE_VIDEO_AVC,1,10F,1500000,frameMuxer,100000);
            Muxer muxer = new Muxer(getApplication().getApplicationContext(), muxerConfig);
            muxer.setMuxerConfig(muxerConfig);

            muxer.setOnMuxingCompletedListener(new MuxingCompletionListener() {
                @Override
                public void onVideoSuccessful(@NotNull File file) {
                            /*
                            File file = new File(filename);
                            */
                    Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                    intent.setData(Uri.fromFile(file));
                    sendBroadcast(intent);
                    Log.d(TAG, "Video muxed - file path: " + file.getAbsolutePath());
                    getBitMapList.clear();
                    //Toast.makeText(getApplicationContext(), "영상 저장 중입니다.", Toast.LENGTH_SHORT).show();
                    progressBar.setVisibility(View.GONE);

                }

                @Override
                public void onVideoError(@NotNull Throwable throwable) {
                    Log.d(TAG, "There was an error muxing the video");
                }
            });
            new Handler().post(new Runnable() {
                @Override
                public void run() {
                    muxer.mux(getBitMapList,R.raw.input_audio);
                    //a.mux(getBitMapList,null);
                }
            });


        }
        else {
            //record_btn.setText("기록종료");
            Toast.makeText(getApplicationContext(), "평가 녹화를 시작합니다.", Toast.LENGTH_SHORT).show();
        }

        Log.d("전후1", "set_record_evaluation: "+recordBool);
        recordBool = !recordBool;
        Log.d("전후2", "set_record_evaluation: "+recordBool);
    }




    View.OnClickListener reset_button = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            AlertDialog.Builder builder = new AlertDialog.Builder(PoseActivity.this);     // 여기서 this는 Activity의 this
            // 여기서 부터는 알림창의 속성 설정
            builder.setTitle("다시 하기")// 제목 설정
                    .setMessage("해당 운동을 다시 진행하시겠습니까??")// 메세지 설정
                    .setCancelable(true)        // 뒤로 버튼 클릭시 취소 가능 설정
                    .setPositiveButton(Html.fromHtml("<font color='#999999'>확인</font>", Html.FROM_HTML_MODE_LEGACY), new DialogInterface.OnClickListener() {

                        //다시하기 실행
                        public void onClick(DialogInterface dialog, int whichButton) {
                            //items.get(i).counsel_code

                            if(mTimerRunning){


                                PoseInformation.pose_count = 0;
                                pose_count_value = 0;

                                pauseTimer();
                                resetTimer();

                                startTimer();
                              /*  Intent intent = new Intent(PoseActivity.this, PoseActivity.class);
                                intent.putExtra("evaluation_value", evaluation_value);
                                intent.putExtra("class_title", class_title);
                                intent.putExtra("class_code", class_code);
                                intent.putExtra("unit_code", unit_class_code);
                                intent.putExtra("content_title", content_title);
                                intent.putExtra("position_number", position_number);
                                intent.putExtra("array_size", array_size);

                                intent.putExtra("content_name_list", content_name_list);
                                intent.putExtra("content_cateogry_list", content_cateogry_list);
                                intent.putExtra("content_type_list", content_type_list);
                                intent.putExtra("content_detail_name_list", content_detail_name_list);
                                intent.putExtra("content_count_list", content_count_list);
                                intent.putExtra("content_time", content_time);
                                intent.putExtra("content_url", content_url);
                                intent.putExtra("content_level_list", content_level_list);

                                startActivity(intent);
                                finish();
                                overridePendingTransition(R.anim.fade_in, R.anim.fade_out);*/

                            }
                            else
                            {
                                Toast.makeText(getApplicationContext(), "운동 상태가 아닙니다.", Toast.LENGTH_SHORT).show();

                            }
                        }

                    })
                    //탈퇴하기 취소
                    .setNegativeButton(Html.fromHtml("<font color='#F80000'>취소</font>", Html.FROM_HTML_MODE_LEGACY), new DialogInterface.OnClickListener() {

                        // 취소 버튼 클릭시 설정

                        public void onClick(DialogInterface dialog, int whichButton) {

                            dialog.cancel();

                        }

                    });


            AlertDialog dialog = builder.create();    // 알림창 객체 생성

            dialog.show();





        }
    };

    String content_name_list ="";
    String content_cateogry_list="";
    String content_type_list="";
    String content_detail_name_list="";
    String content_count_list="";
    String content_time="";
    String content_url="";
    String content_level_list="";
    String evaluation_value ="";

    public void get_content_info()
    {
        Intent intent = getIntent();
        evaluation_value = intent.getStringExtra("evaluation_value");
        content_title = intent.getStringExtra("content_title");
        position_number = intent.getIntExtra("position_number", 0);
        array_size = intent.getIntExtra("array_size",0);
        class_code = intent.getStringExtra("class_code");
        unit_class_code = intent.getStringExtra("unit_code");
        class_title = intent.getStringExtra("class_title");

        Log.d("제목", "get_content_info: "+content_title);

        //좌측 하단 평가/실습/과제 명 입력 해주기
        pose_class_textview.setText(content_title);

        pose_class_code = class_code;
        pose_unit_code = unit_class_code;



        content_name_list = intent.getStringExtra("content_name_list");
        content_cateogry_list = intent.getStringExtra("content_cateogry_list");
        content_type_list = intent.getStringExtra("content_type_list");
        content_detail_name_list = intent.getStringExtra("content_detail_name_list");
        content_count_list = intent.getStringExtra("content_count_list");
        content_time = intent.getStringExtra("content_time");
        content_url = intent.getStringExtra("content_url");
        content_level_list = intent.getStringExtra("content_level_list");



        try {
            JSONArray content_name_list_JSONArray = new JSONArray(content_name_list);
            JSONArray content_cateogry_list_JSONArray =  new JSONArray(content_cateogry_list);
            JSONArray content_type_list_JSONArray =  new JSONArray(content_type_list);
            JSONArray content_detail_name_list_JSONArray =  new JSONArray(content_detail_name_list);
            JSONArray content_count_list_JSONArray =  new JSONArray(content_count_list);
            JSONArray content_time_list_JSONArray =  new JSONArray(content_time);
            JSONArray content_url_list_JSONArray =  new JSONArray(content_url);
            JSONArray content_level_list_JSONArray =  new JSONArray(content_level_list);


            if(content_name_list_JSONArray.length()!=0)
            {
                for(int i = 0 ; i < content_name_list_JSONArray.length(); i++)
                {
                    String exercise_str = content_name_list_JSONArray.get(i).toString();
                    pose_content_name_array.add(exercise_str);
                }
            }


            //상세이름
            if(content_detail_name_list_JSONArray.length()!=0)
            {
                for(int i =0 ; i < content_detail_name_list_JSONArray.length(); i++)
                {

                    int count = i+1;
                    String count_str = Integer.toString(count);
                    //하단 리사이클러뷰 동작 이름 보여주기

                    if(count==1){
                        pose_name_item.add(new pose_name_Item("동작"+count_str,1));
                    }
                    else
                    {
                        pose_name_item.add(new pose_name_Item("동작"+count_str,0));
                    }

                    //운동명
                    String exercise_str = content_detail_name_list_JSONArray.get(i).toString();
                    posename_array.add(exercise_str);
                    pose_detail_name_array.add(content_detail_name_list_JSONArray.get(i).toString());
                    //운동 카테고리
                    pose_category_name_array.add(content_cateogry_list_JSONArray.get(i).toString());
                }


            }
            //횟수
            if(content_count_list_JSONArray.length()!=0)
            {
                for(int i = 0 ; i< content_count_list_JSONArray.length() ; i++)
                {
                    posecount_array.add(content_count_list_JSONArray.getInt(i));

                }
            }
            //시간
            if(content_time_list_JSONArray.length()!=0)
            {
                for(int i = 0 ; i< content_time_list_JSONArray.length() ; i++)
                {
                    posetime_array.add(content_time_list_JSONArray.getInt(i)*1000);

                }
            }

            if(content_url_list_JSONArray.length()!=0)
            {
                for(int i = 0 ; i< content_url_list_JSONArray.length() ; i++)
                {
                    pose_gif_url_array.add(content_url_list_JSONArray.get(i).toString());

                }
            }


            pose_exercise_name_textview.setText(pose_content_name_array.get(0)+"/"+pose_detail_name_array.get(0));

            Glide.with(getApplicationContext()).load(pose_gif_url_array.get(0)).listener(new RequestListener<Drawable>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {


                    return false;
                }

                @Override
                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {

                    if(isFirstResource)
                    {

                        progressBar.setVisibility(View.GONE);
                        //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                    }
                    else
                    {
                        //progressBar.setVisibility(View.VISIBLE);
                    }


                    return false;
                }
            })
                    .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                    .into(new DrawableImageViewTarget(main_imageview));

            Glide.with(getApplicationContext()).load(pose_gif_url_array.get(0)).listener(new RequestListener<Drawable>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                    return false;
                }

                @Override
                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {

                    if(isFirstResource)
                    {
                        progressBar.setVisibility(View.GONE);
                        //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                    }
                    else
                    {
                        //progressBar.setVisibility(View.VISIBLE);
                    }
                    return false;
                }
            })
                    .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                    .into(new DrawableImageViewTarget(side_gif_imageview));



        }
        catch (JSONException e)
        {
            e.printStackTrace();
        }


        //리사이클러뷰 셋팅
        set_Recyclerview();

    }


    public void set_Recyclerview()
    {

        pose_name_adapter = new pose_name_Adapter(this, pose_name_item);

        GridLayoutManager mLayoutManager = new GridLayoutManager(this, pose_name_item.size());
        //mLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);

        pose_recyclerview.setLayoutManager(mLayoutManager);
        pose_recyclerview.setAdapter(pose_name_adapter);


    }


    @Override
    public void onResume() {
        super.onResume();



        Log.d(TAG, "onResume");
        if (!OpenCVLoader.initDebug()) {
            Log.d(TAG, "onResume :: Internal OpenCV library not found.");
            OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_2_0, this, mLoaderCallback);
        } else {
            Log.d(TAG, "onResume :: OpenCV library found inside package. Using it!");
            mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
        }


        createCameraSource(selectedModel);
        //카메라 시작
        startCameraSource();

        //동작 측정 함수
        PoseMeasure();

    }


    /**
     * Stops the camera.
     */
    @Override
    protected void onPause() {
        super.onPause();

        //on_display_value = 0;

    }

    @Override
    protected void onStop() {
        super.onStop();
        preview.stop();
        //2021-03-07 변경 전
/*
*  on_display_value=0;

        if(mTimerRunning) {

            mTimerRunning = false;
            pauseTimer();
            resetTimer();
            mCountDownTimer.cancel();
            mCountDownTimer.onFinish();

        }

        try {
            Pose_Start_mCountDownTimer.cancel();
            Pose_Start_mCountDownTimer.onFinish();
            if(content_title.contains("평가"))
            {
                if(recordBool)
                {
                    //set_record_evaluation();
                    recordBool = false;
                }
            }

        }catch (Exception  e)
        {
            Pose_Start_mCountDownTimer = null;
            mCountDownTimer = null;
        }



        Log.d("동작", "onDestroy: 끈거임?");
        //화면 전환시, 동작 데이터 초기화
        PoseInformation.pose_status = false;
        PoseInformation.pose_status_sub = false;
        PoseInformation.pose_degree = 180;
        PoseInformation.pose_count = 0;
        PoseInformation.array_count= 0;
        PoseInformation.pose_count_double = 0.0;
        ResultInformation.result_list.clear();
        PoseInformation.pose_arraylist.clear();
        pose_resultInformation.clear();
        //화면 전환시, 넘겨받은 배열 데이터 초기화
        posename_array.clear();
        posecount_array.clear();
        posetime_array.clear();
        photo_capture_value = 0;
        photo_value = false;

        finish();
*/
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        //2021-03-07 변경 후


        on_display_value=0;

        if(mTimerRunning) {

            mTimerRunning = false;
            pauseTimer();
            resetTimer();
            mCountDownTimer.cancel();
            mCountDownTimer.onFinish();

        }

        try {
            Pose_Start_mCountDownTimer.cancel();
            Pose_Start_mCountDownTimer.onFinish();
            if(content_title.contains("평가"))
            {
                if(recordBool)
                {
                    //set_record_evaluation();
                    recordBool = false;
                }
            }

        }catch (Exception  e)
        {
            Pose_Start_mCountDownTimer = null;
            mCountDownTimer = null;
        }




        //화면 전환시, 동작 데이터 초기화
        PoseInformation.pose_status = false;
        PoseInformation.pose_status_sub = false;
        PoseInformation.pose_degree = 180;
        PoseInformation.pose_count = 0;
        PoseInformation.array_count= 0;
        PoseInformation.pose_count_double = 0.0;
        ResultInformation.result_list.clear();
        PoseInformation.pose_arraylist.clear();
        pose_resultInformation.clear();
        //화면 전환시, 넘겨받은 배열 데이터 초기화
        posename_array.clear();
        posecount_array.clear();
        posetime_array.clear();
        photo_capture_value = 0;
        photo_value = false;

        finish();


    }


    //동작 측정 함수
    private void PoseMeasure(){


        PoseGraphic poseGraphic = new PoseGraphic(graphicOverlay, pose,false);

        //poseGraphic.get_state(pose_estimation_imageview);

        poseGraphic.setDrawViewListener(new PoseGraphic.drawViewListener(){

            //총 48개
            @Override
            public void detectSkeletonPoint(ArrayList<Float> mDrawPoint) {



                if(exercise_boolean){

                if(PoseInformation.array_count==-1){
                    //array_count가 -1일 경우 카메라 중지
                    preview.stop();
                }
                else if(posename_array.size() == PoseInformation.array_count) {

                    if(content_title.contains("평가"))
                    {
                        Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();

                    }
                    //개수 -1로 변경 (1번만 작동하도록)
                    PoseInformation.array_count=-1;
                    //동작을 다 실행한 경우 액티비티 이동

                    pauseTimer();



                    if(on_display_value==1) {


                        //여기 띄어주면 될 듯
                        pose_complete_layout.startAnimation(pose_complete_start_animation);
                        pose_complete_layout.setVisibility(View.VISIBLE);
                        exercise_boolean = false;

                        if(content_title.contains("평가"))
                        {
                            //Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();
                            progressBar.setVisibility(View.VISIBLE);
                            //녹화종료해주기
                            if(recordBool)
                            {
                                set_record_evaluation();
                            }
                        }

                    }
                }
                else if(posename_array.size() > PoseInformation.array_count && 0 <= PoseInformation.array_count){


                    if(!start_timer_value){

                        start_timer_value= true;
                        //타이머 초기화
                        START_TIME_IN_MILLIS = posetime_array.get(0);
                        mTimeLeftInMillis= START_TIME_IN_MILLIS;
                        //타이머 시작
                        startTimer();
                    }
                    //실행할 동작이 남은 경우

                    //동작 이름 설정
                    pose_name= posename_array.get(PoseInformation.array_count);
                    //동작 카테고리 이름[카테고리 이름]
                    pose_category_name = pose_category_name_array.get(PoseInformation.array_count);
                    get_pose_category_name = pose_category_name;
                    //디테일이름
                    pose_detail_name = pose_detail_name_array.get(PoseInformation.array_count);
                    //개수 설정
                    pose_count= posecount_array.get(PoseInformation.array_count);
                    //시간 설정
                    pose_time= posetime_array.get(PoseInformation.array_count);

                    pose_content_name = pose_content_name_array.get(PoseInformation.array_count);





                    if(PoseInformation.array_count>=1)
                    {
                        pose_name_item.get(PoseInformation.array_count - 1).setPose_value(0);
                        pose_name_item.get(PoseInformation.array_count).setPose_value(1);
                        pose_name_adapter.notifyDataSetChanged();
                    }

                    pose_exercise_name_textview.setText(pose_content_name_array.get(PoseInformation.array_count)+"/"+pose_detail_name_array.get(PoseInformation.array_count));

                    Glide.with(getApplicationContext()).load(pose_gif_url_array.get(PoseInformation.array_count)).listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {

                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {

                            if(isFirstResource)
                            {
                                progressBar.setVisibility(View.GONE);
                                //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                            }
                            else
                            {
                                //progressBar.setVisibility(View.VISIBLE);
                            }
                            return false;
                        }
                    })
                            .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                            .into(new DrawableImageViewTarget(main_imageview));

                    Glide.with(getApplicationContext()).load(pose_gif_url_array.get(PoseInformation.array_count)).listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {

                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            if(isFirstResource)
                            {
                                progressBar.setVisibility(View.GONE);
                                //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                            }
                            else
                            {
                                //progressBar.setVisibility(View.VISIBLE);
                            }

                            return false;
                        }
                    })
                            .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                            .into(new DrawableImageViewTarget(side_gif_imageview));

                    //스코어 리스트 모음
                    String poselist="";


                    // VIEW 설정 (동작 이름, 동작 개수, 동작 스코어, 스코어 리스트)
                    posename_textview.setText(pose_name);
                    posecount_textview.setText(String.valueOf(PoseInformation.pose_count)+"/"+String.valueOf(posecount_array.get(PoseInformation.array_count)));
                    posescore_textview.setText(PoseInformation.pose_score);
                    posescorelist_textview.setText(poselist);


                    //포즈 value 값이 같지 않을 경우 실행
                    if(pose_count_value<PoseInformation.pose_count) {

                        pose_count_value = PoseInformation.pose_count;
                        pose_count_start_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.pose_fade_in);// Create the animation.
                        pose_count_end_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.pose_fade_out);// Create the animation.
                        pose_activity_count_textview.setText(Integer.toString(PoseInformation.pose_count));
                        pose_activity_count_textview.setVisibility(View.VISIBLE);
                        pose_activity_count_textview.startAnimation(pose_count_start_animation);
                        pose_count_start_animation.setDuration(1000);

                        //동작 완료 시 소리 효과 주기
                        MediaPlayer mediaPlayer = MediaPlayer.create(PoseActivity.this, R.raw.onpe_success);
                        //효과 시작
                        mediaPlayer.start();

                        pose_count_start_animation.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {


                                pose_activity_count_textview.startAnimation(pose_count_end_animation);
                                pose_count_end_animation.setAnimationListener(new Animation.AnimationListener() {
                                    @Override
                                    public void onAnimationStart(Animation animation) {
                                    }

                                    @Override
                                    public void onAnimationEnd(Animation animation) {
                                        pose_activity_count_textview.setVisibility(View.GONE);
                                        //효과 종료
                                        mediaPlayer.release();
                                    }

                                    @Override
                                    public void onAnimationRepeat(Animation animation) {

                                    }
                                });

                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });
                    }



                        // 해당 동작의 개수를 모두 완료했을 경우
                    if(PoseInformation.pose_count==posecount_array.get(PoseInformation.array_count)||!mTimerRunning){

                        if(Next_Pose_mTimerRunning_value==0){

                            if(photo_value==false&&photo_capture_value==0)
                            {
                                Log.d("사진촬영", "detectSkeletonPoint:"+"사진촬영");
                                photo_value = true;
                            }


                         Next_Pose_mTimerRunning_value=1;
                        // 해당 동작의 개수를 모두 완료했거나, 타이머의 시간이 종료되었을 경우 -> 다음 동작으로 이동
                        PoseInformation.array_count=PoseInformation.array_count+1;

                        //완료한 동작의 평균점수 저장
                        ResultInformation.result_list.add(pose_name+"-"+PoseInformation.pose_score_average);

                        long exercise_time = START_TIME_IN_MILLIS - mTimeLeftInMillis;

                        Log.d(TAG, "detectSkeletonPoint: "+exercise_time);

                        int set_exercise_time = (int) exercise_time;



                        if(pose_time<set_exercise_time)
                        {
                            set_exercise_time = pose_time;
                        }

                            Log.d("운동시간1", "detectSkeletonPoint:"+set_exercise_time);
                            Log.d("운동시간2", "detectSkeletonPoint: "+ exercise_time/1000);
                            //포즈 결과값 저장하기
                        pose_resultInformation.add(new Pose_ResultInformation(pose_content_name,pose_category_name, pose_detail_name, String.format("%.0f", PoseInformation.pose_score_average), Integer.toString(PoseInformation.pose_count),Integer.toString(set_exercise_time/1000+1)));


                        if(posetime_array.size()>PoseInformation.array_count){

                            pauseTimer();
                            //타이머 초기화
                            START_TIME_IN_MILLIS = posetime_array.get(PoseInformation.array_count);
                            mTimeLeftInMillis= START_TIME_IN_MILLIS;
                            //타이머 시작

                            if(evaluation_value.equals("1"))
                            {
                                startTimer();
                                Next_Pose_mTimerRunning_value=0;
                            }
                            else
                            {
                                next_exercise_start_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_in);// Create the animation.
                                next_exercise_post_parent_layout.startAnimation(next_exercise_start_animation);
                                next_exercise_pose_name_textview.setText(posename_array.get(PoseInformation.array_count));
                                next_exercise_post_parent_layout.setVisibility(View.VISIBLE);
                                next_exercise_start_animation.setAnimationListener(new Animation.AnimationListener() {
                                    @Override
                                    public void onAnimationStart(Animation animation) {

                                    }

                                    @Override
                                    public void onAnimationEnd(Animation animation) {

                                        Next_Exercise_startTimer();
                                    }

                                    @Override
                                    public void onAnimationRepeat(Animation animation) {

                                    }
                                });

                            }




                            //next_exercise_post_parent_layout.setVisibility(View.VISIBLE);
                        }

                        //포즈 상태, 개수, 스코어, 각도, 리스트 초기화
                        PoseInformation.pose_status = false;
                        PoseInformation.pose_status_sub = false;
                        PoseInformation.pose_degree = 180;
                        PoseInformation.pose_count = 0;
                        PoseInformation.pose_count_double = 0.0;
                        PoseInformation.pose_arraylist.clear();
                        pose_count_value=0;
                        }


                    }

                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    Log.d("PoseGraphic으로부터의 return값", String.valueOf(mDrawPoint));
                    leftShoulder_x = mDrawPoint.get(0);leftShoulder_y = mDrawPoint.get(1);
                    rightShoulder_x = mDrawPoint.get(2);rightShoulder_y = mDrawPoint.get(3);
                    leftElbow_x = mDrawPoint.get(4);leftElbow_y = mDrawPoint.get(5);
                    rightElbow_x = mDrawPoint.get(6);rightElbow_y = mDrawPoint.get(7);
                    leftWrist_x = mDrawPoint.get(8);leftWrist_y = mDrawPoint.get(9);
                    rightWrist_x = mDrawPoint.get(10);rightWrist_y = mDrawPoint.get(11);
                    leftHip_x = mDrawPoint.get(12);leftHip_y = mDrawPoint.get(13);
                    rightHip_x = mDrawPoint.get(14);rightHip_y = mDrawPoint.get(15);
                    leftKnee_x = mDrawPoint.get(16);leftKnee_y = mDrawPoint.get(17);
                    rightKnee_x = mDrawPoint.get(18);rightKnee_y = mDrawPoint.get(19);
                    leftAnkle_x = mDrawPoint.get(20);leftAnkle_y = mDrawPoint.get(21);
                    rightAnkle_x = mDrawPoint.get(22);rightAnkle_y = mDrawPoint.get(23);
                    leftPinky_x = mDrawPoint.get(24);leftPinky_y = mDrawPoint.get(25);
                    rightPinky_x = mDrawPoint.get(26);rightPinky_y = mDrawPoint.get(27);
                    leftIndex_x = mDrawPoint.get(28);leftIndex_y = mDrawPoint.get(29);
                    rightIndex_x = mDrawPoint.get(30);rightIndex_y = mDrawPoint.get(31);
                    leftThumb_x = mDrawPoint.get(32);leftThumb_y = mDrawPoint.get(33);
                    rightThumb_x = mDrawPoint.get(34);rightThumb_y = mDrawPoint.get(35);
                    leftHeel_x = mDrawPoint.get(36);leftHeel_y = mDrawPoint.get(37);
                    rightHeel_x = mDrawPoint.get(38);rightHeel_y = mDrawPoint.get(39);
                    leftFootIndex_x = mDrawPoint.get(40);leftFootIndex_y = mDrawPoint.get(41);
                    rightFootIndex_x = mDrawPoint.get(42);rightFootIndex_y = mDrawPoint.get(43);
                    leftEar_x = mDrawPoint.get(44);leftEar_y = mDrawPoint.get(45);
                    rightEar_x = mDrawPoint.get(46);rightEar_y = mDrawPoint.get(47);

                    Log.d("좌표인식", "detectSkeletonPoint:"+leftShoulder_x+"/"+leftThumb_x+"/"+leftKnee_x+leftKnee_y);

                    if(leftShoulder_x > 720 || leftShoulder_y > 480 || rightShoulder_x > 720 || rightShoulder_y > 480 ||
                            leftElbow_x > 720 || leftElbow_y > 480 || rightElbow_x > 720 || rightElbow_y > 480 ||
                            leftWrist_x > 720 || leftWrist_y > 480 || rightWrist_x > 720 || rightWrist_y > 480 ||
                            leftHip_x > 720 || leftHip_y > 480 || rightHip_x > 720 || rightHip_y > 480 ||
                            leftKnee_x > 720 || leftKnee_y > 480 || rightKnee_x > 720 || rightKnee_y > 480 ||
                            leftAnkle_x > 720 || leftAnkle_y > 480 || rightAnkle_x > 720 || rightAnkle_y > 480 ||
                            leftPinky_x > 720 || leftPinky_y > 480 || rightPinky_x > 720 || rightPinky_y > 480 ||
                            leftIndex_x > 720 || leftIndex_y > 480 || rightIndex_x > 720 || rightIndex_y > 480 ||
                            leftThumb_x > 720 || leftThumb_y > 480 || rightThumb_x > 720 || rightThumb_y > 480 ||
                            leftHeel_x > 720 || leftHeel_y > 480 || rightHeel_x > 720 || rightHeel_y > 480 ||
                            leftFootIndex_x > 720 ||  leftFootIndex_y > 480 || rightFootIndex_x > 720 || rightFootIndex_y > 480){
                        //모든 좌표가 (0,0) ~ (720,480) 사이에 있어야 한다
                        Log.d("동작인식 범위 이탈: ", "좌표 범위 이탈로 인한 자세 미측정");

                        pose_estimation_imageview.setBackgroundResource(R.drawable.red_circle);

                    }else if(Math.abs(leftEar_x-rightEar_x)>60 || Math.abs(leftEar_y-rightEar_y)>60){
                        // 양쪽 귀간의 거리가 70이상일 경우 -> 얼굴 비중이 높으므로 측정 X
                        pose_estimation_imageview.setBackgroundResource(R.drawable.red_circle);
                        Log.d("동작인식 범위 이탈: ", "얼굴 과비중으로 인한 자세 미측정");

                    }else{

                        pose_estimation_imageview.setBackgroundResource(R.drawable.green_circle);

                        Log.d("동작인식 범위 포함: ", "측정 가능 범위 도달");

                        posemeasurefunction = new PoseMeasureFunction();




                        if(pose_name.equals("스쿼트")){
                            // 개수 측정 -  (엉덩이 - 무릎 - 발목) - 각도가 110 이하일 경우 카운트
                            // 예외처리 1 - (머리 > 엉덩이 > 발목) - 누워서 스쿼트할 경우 대비
                            // 예외처리 2 - (손목 - 어깨 - 발목) - ( 70 < 각도 < 120 ) 사이에 있어야 손모았다고 인식
                            // 예외처리 3 - 좌우 어깨, 무릎, 발목의 좌표가 동일할 정도로 가까워야한다
                            posemeasurefunction.squat_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y,
                                    leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftWrist_x, leftWrist_y, leftShoulder_x, leftShoulder_y, leftAnkle_x, leftAnkle_y,
                                    leftShoulder_x, leftShoulder_y, rightShoulder_x, rightShoulder_y,
                                    leftKnee_x, leftKnee_y, rightKnee_x, rightKnee_y,
                                    leftAnkle_x, leftAnkle_y, rightAnkle_x, rightAnkle_y);
                            Log.d("동작인식: ", "스쿼트 측정 중");
                        }
                        else if(pose_name.equals("팔굽혀펴기")){
                            // 개수 측정 - 각도1(어깨, 팔꿈치, 손목) - 각도가 100이하일 경우 카운트
                            // 예외처리1 - (머리 = 엉덩이 = 발목) - 엎드린 자세 확인
                            // 예외처리2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
                            // 예외처리3 - (엉덩이 , 무릎 , 발목) -  다리가 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
                            posemeasurefunction.pushup_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y, leftWrist_x, leftWrist_y,
                                    leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y);
                            Log.d("동작인식: ", "푸쉬업 측정 중");
                        }else if(pose_name.equals("무릎대고팔굽혀펴기")){
                            // 개수 측정 - 각도1(어깨, 팔꿈치, 손목) - 각도가 100이하일 경우 카운트
                            // 예외처리1 - (머리 = 엉덩이 = 발목) - 엎드린 자세 확인
                            // 예외처리2 - (머리 , 엉덩이 , 발목) -  몸이 1자인지 파악하기 위한 각도 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X)
                            // 예외처리3 - (엉덩이 , 무릎 , 발목) -  다리가 굽혀졌는지 파악하기 위한 각도 (100도 이하일 경우에만 측정, 100도이상일 경우 측정 X)
                            // 예외처리4 - 좌우 어깨, 무릎, 발목의 좌표가 동일할 정도로 가까워야한다
                            posemeasurefunction.knee_pushup_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y, leftWrist_x, leftWrist_y,
                                    leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y);
                            Log.d("동작인식: ", "무릎 푸쉬업 측정 중");
                        } else if(pose_name.equals("크런치")){
                            // 개수 측정 - 각도1(머리, 엉덩이, 무릎) - 각도가 110이하일 경우 카운트
                            // 예외처리1 - (엉덩이 = 발목) - 누운 자세 확인 (서서 크런치 방지)
                            // 예외처리2 - (엉덩이 , 무릎 , 발목) - 다리를 굽혔는지 확인
                            // 예외처리3 - (손목 = 무릎) - 무릎 짚었는 지 확인
                            posemeasurefunction.crunch_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftKnee_x, leftKnee_y,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y,
                                    leftWrist_x, leftWrist_y, leftKnee_x, leftKnee_y);
                            Log.d("동작인식: ", "크런치 측정 중");
                        }else if(pose_name.equals("브이업")){
                            // 개수 측정 - 각도1(어깨, 엉덩이, 발목) - 각도가 90이하일 경우 카운트
                            // 예외처리1 - (엉덩이 = 손목) - 몸이 바닥에 있는지 확인
                            // 예외처리2 - (엉덩이 , 어깨 , 손목) - 손 짚은 자세 확인
                            // 예외처리3 - (발목, 어깨) - 카운트 시 발목이 어깨 위에 있는지 확인
                            posemeasurefunction.vup_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftHip_x, leftHip_y, leftShoulder_x, leftShoulder_y, leftWrist_x, leftWrist_y,
                                    leftAnkle_x, leftAnkle_y, leftShoulder_x, leftShoulder_y);
                            Log.d("동작인식: ", "브이업 측정 중");
                        }else if(pose_name.equals("버피테스트")){
                            // 버피일 경우 각도1(머리,엉덩이,발목) / 각도2 (머리, 팔꿈치, 발목)
                            // 각도1 (엎드린 동작이 확인되었을 경우, 해당 동작에서 머리,엉덩이,발목의 각도가 수평일 수록 점수가 높다)
                            // 각도1 (80~120 -> BAD, 120~140 -> NORMAL, 140 이상 -> GOOD)
                            // 각도2 (서있는 동작과, 엎드린 동작을 구분하는 각도)
                            posemeasurefunction.burpee_data(PoseInformation.pose_count, PoseInformation.pose_status, PoseInformation.pose_status_sub, leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y, leftEar_x, leftEar_y, leftElbow_x, leftElbow_y, leftAnkle_x, leftAnkle_y);
                            Log.d("동작인식: ", "버피 측정 중");
                        }else if(pose_name.equals("접었다폈다복근")){
                            // 개수 측정 -  각도1(엉덩이, 무릎, 발목) -  각도가 110이하일 경우 카운트
                            // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~110도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
                            // 예외처리2 -  (발목 >> 엉덩이) - 서서 동작하는 것 방지
                            // 예외처리3 -  (무릎 >>> 어깨) - 다리를 바닥에 대고하는 것 방지
                            posemeasurefunction.kneeup_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y,
                                    leftHip_x, leftHip_y, leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y);
                            Log.d("동작인식: ", "접었다폈다복근 측정 중");
                        }else if(pose_name.equals("위아래지그재그복근")){
                            // 개수 측정 - 각도1(왼쪽발목, 엉덩이, 오른쪽발목) - 양쪽 발목이 교차할때마다 0.5씩 카운트 - 30도 이상일 경우 카운트
                            // 예외처리1 -  (엉덩이 - 어깨 - 팔꿈치) (20도~110도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
                            // 예외처리2 -  (발목 >= 엉덩이) - 서서 동작하는 것 방지
                            // 예외처리3 -  (발목 > 어깨) - 카운트 시 발목이 어깨 위로 올라가는지 확인
                            posemeasurefunction.ankleupdown_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftAnkle_x, leftAnkle_y, leftHip_x, leftHip_y, rightAnkle_x, rightAnkle_y,
                                    leftHip_x, leftHip_y, leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y,
                                    leftShoulder_x, leftShoulder_y, rightShoulder_x, rightShoulder_y);
                        }else if(pose_name.equals("런지")){
                            // 런지일 경우 각도1(왼쪽발목, 왼쪽무릎, 엉덩이) / 각도2(오른쪽발목, 오른쪽무릎, 엉덩이) / 각도3 (왼쪽발목, 엉덩이, 오른쪽발목)
                            // 각도1 or 각도2 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            // 각도3 - 런지 시작자세인지 파악
                            posemeasurefunction.lunge_data(PoseInformation.pose_count, PoseInformation.pose_status, leftAnkle_x, leftAnkle_y, leftKnee_x, leftKnee_y, leftHip_x, leftHip_y,
                                    rightAnkle_x, rightAnkle_y, rightKnee_x, rightKnee_y, rightHip_x, rightHip_y);
                            Log.d("동작인식: ", "런지 측정 중");
                        }else if(pose_name.equals("굿모닝")){
                            // 개수 측정  - 각도1(어깨, 엉덩이, 발목) - 각도가 120도 이하일 경우 측정
                            // 예외처리1 - (왼쪽손목>왼쪽어깨, 오른쪽손목>오른쪽어깨) - 굿모닝 준비자세
                            // 예외처리2 - (왼쪽발목, 엉덩이, 오른쪽발목) - 두 발이 붙어있는지 확인
                            // 예외처리3 - (엉덩이, 무릎, 발목) - 다리 1자로
                            posemeasurefunction.goodmorning_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftWrist_x,  leftWrist_y,  leftShoulder_x,  leftShoulder_y, rightWrist_x,  rightWrist_y,  rightShoulder_x,  rightShoulder_y,
                                    leftAnkle_x,  leftAnkle_y, leftHip_x, leftHip_y, rightAnkle_x, rightAnkle_y,
                                    leftHip_x,  leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y);
                            Log.d("동작인식: ", "굿모닝 측정 중");
                        }else if(pose_name.equals("덤벨프레스")){
                            // 개수 측정1 - 각도1(왼쪽어깨, 왼쪽팔꿈치, 왼쪽손목) - 140도 이상일 경우 카운트
                            // 개수 측정2 - 각도2(오른쪽어깨, 오른쪽팔꿈치, 른쪽손목) - 140도 이상일 경우 카운트
                            // 예외처리1 - (왼쪽엉덩이, 왼쪽무릎, 왼쪽발목) - 1자
                            // 예외처리2 - (오른쪽엉덩이, 오른쪽무릎, 오른쪽발목) - 1자
                            posemeasurefunction.dumbbellshoulder_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y, leftWrist_x, leftWrist_y,
                                    rightShoulder_x, rightShoulder_y,rightElbow_x, rightElbow_y, rightWrist_x, rightWrist_y,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y,
                                    rightHip_x, rightHip_y, rightKnee_x, rightKnee_y, rightAnkle_x, rightAnkle_y);
                            Log.d("동작인식: ", "덤벨숄더프레스 측정 중");
                        }else if(pose_name.equals("덤벨로우")){
                            // 개수 측정1 - 각도1(어깨, 팔꿈치, 손목) - 110도 이하일 경우 카운트
                            // 예외처리1 -  (머리, 엉덩이, 발목) - 덤벨로우 준비자세(130도 이하)
                            // 예외처리2 -  (머리> 엉덩이> 발목) - 누워서 할 경우 대비
                            // 예외처리3 -  (엉덩이 - 무릎 - 발목) - 덤벨로우 준비자세2 (140도 이하)
                            posemeasurefunction.dumbbelllow_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftShoulder_x, leftShoulder_y, leftElbow_x, leftElbow_y, leftWrist_x, leftWrist_y,
                                    leftEar_x, leftEar_y, leftHip_x, leftHip_y, leftAnkle_x, leftAnkle_y,
                                    leftHip_x, leftHip_y, leftKnee_x, leftKnee_y, leftAnkle_x, leftAnkle_y);
                            Log.d("동작인식: ", "덤벨로우 측정 중");
                        }

                        ///////////////////////////////////////////////////////// 점핑체조 ////////////////////////////////////////////////////
                        else if(pose_name.equals("제자리점핑")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표
                            posemeasurefunction.basicjump_data(PoseInformation.pose_count, PoseInformation.pose_status, leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "제자리점핑 측정 중");
                        }else if(pose_name.equals("두발사이드점핑")){
                            // 왼발, 오른발 좌표
                            posemeasurefunction.twolegsidejump_data(PoseInformation.pose_count, PoseInformation.pose_status,leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y);
                            Log.d("동작인식: ", "두발사이드점핑 측정 중");
                        }else if(pose_name.equals("두발앞뒤점핑")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표
                            posemeasurefunction.twolegfrontjump_data(PoseInformation.pose_count, PoseInformation.pose_status,leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "두발앞뒤점핑 측정 중");
                        }else if(pose_name.equals("펀치스텝")){
                            // 각도1(왼쪽손목, 왼쪽어깨, 왼쪽골반), 각도2(오른쪽손목, 오른쪽어깨, 왼쪽골반) 왼발/오른발 좌표
                            posemeasurefunction.punchstep_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftWrist_x,leftWrist_y,leftShoulder_x,leftShoulder_y,leftHip_x,leftHip_y,
                                    rightWrist_x,rightWrist_y,rightShoulder_x,rightShoulder_y,rightHip_x,rightHip_y,
                                    leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y);
                            Log.d("동작인식: ", "펀치스텝 측정 중");
                        }else if(pose_name.equals("지그재그점핑")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 무릎 좌표, 왼쪽/오른쪽 귀 좌표
                            posemeasurefunction.zigzagjump_data(PoseInformation.pose_count, PoseInformation.pose_status,leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y,leftKnee_x,leftKnee_y,rightKnee_x,rightKnee_y);
                            Log.d("동작인식: ", "지그재그점핑 측정 중");
                        }else if(pose_name.equals("스텝러닝")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표, 왼쪽/오른쪽 무릎 좌표
                            posemeasurefunction.steprunning_data(PoseInformation.pose_count, PoseInformation.pose_status,leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y,leftKnee_x,leftKnee_y,rightKnee_x,rightKnee_y);
                            Log.d("동작인식: ", "스텝러닝 측정 중");
                        }else if(pose_name.equals("스텝돌기")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표
                            posemeasurefunction.stepturnning_data(PoseInformation.pose_count, PoseInformation.pose_status, leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "스텝돌기 측정 중");
                        }else if(pose_name.equals("한발스텝")){
                            // 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표
                            posemeasurefunction.onelegstep_data(PoseInformation.pose_count, PoseInformation.pose_status, leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "한발스텝 측정 중");
                        }else if(pose_name.equals("바닥찍기")){
                            // 왼발/오른발목 좌표, 왼쪽/오른쪽 손끝 좌표
                            posemeasurefunction.floorstep_data(PoseInformation.pose_count, PoseInformation.pose_status, leftAnkle_x,leftAnkle_y,rightAnkle_x,rightAnkle_y,
                                    leftWrist_x,leftWrist_y,rightWrist_x,rightWrist_y);
                            Log.d("동작인식: ", "바닥찍기 측정 중");
                        }
                        ///////////////////////////////////////////////////////////////// 점핑체조 레벨2 ////////////////////////////////////////////////////////////
                        else if(pose_name.equals("제자리어깨짚기")){
                            // 각도1(왼쪽손목, 왼쪽어깨, 왼쪽골반), 각도2(오른쪽손목, 오른쪽어깨, 왼쪽골반), 왼발/오른발 좌표, 왼쪽/오른쪽 귀 좌표
                            // 각도1,2 -> 손동작 체크
                            // 왼발/오른발 좌표 -> 발 위치 체크
                            // 왼쪽/오른쪽 귀 좌표 -> 정면 측면 체크
                            posemeasurefunction.basicshoulder_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftWrist_x,leftWrist_y,leftShoulder_x,leftShoulder_y,leftHip_x,leftHip_y,
                                    rightWrist_x,rightWrist_y,rightShoulder_x,rightShoulder_y,rightHip_x,rightHip_y,
                                    leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "제자리어깨짚기 측정 중");
                        }else if(pose_name.equals("두발사이드어깨짚기")){
                            // 각도1(왼쪽손목, 왼쪽어깨, 왼쪽골반), 각도2(오른쪽손목, 오른쪽어깨, 왼쪽골반), 왼발/오른발 좌표
                            // 각도1,2 -> 손동작 체크
                            // 왼발/오른발 좌표 -> 발 위치 체크
                            // 왼쪽/오른쪽 귀 좌표 -> 정면 측면 체크
                            posemeasurefunction.twolegsideshoulder_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftWrist_x,leftWrist_y,leftShoulder_x,leftShoulder_y,leftHip_x,leftHip_y,
                                    rightWrist_x,rightWrist_y,rightShoulder_x,rightShoulder_y,rightHip_x,rightHip_y,
                                    leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "두발사이드어깨짚기 측정 중");
                        }else if(pose_name.equals("두발앞뒤어깨짚기")){
                            // 각도1(왼쪽손목, 왼쪽어깨, 왼쪽골반), 각도2(오른쪽손목, 오른쪽어깨, 왼쪽골반), 왼발/오른발 좌표
                            // 각도1,2 -> 손동작 체크
                            // 왼발/오른발 좌표 -> 발 위치 체크
                            // 왼쪽/오른쪽 귀 좌표 -> 정면 측면 체크
                            posemeasurefunction.twolegfrontshoulder_data(PoseInformation.pose_count, PoseInformation.pose_status,
                                    leftWrist_x,leftWrist_y,leftShoulder_x,leftShoulder_y,leftHip_x,leftHip_y,
                                    rightWrist_x,rightWrist_y,rightShoulder_x,rightShoulder_y,rightHip_x,rightHip_y,
                                    leftFootIndex_x,leftFootIndex_y,rightFootIndex_x,rightFootIndex_y,
                                    leftEar_x,leftEar_y,rightEar_x,rightEar_y);
                            Log.d("동작인식: ", "두발앞뒤어깨짚기 측정 중");
                        }
                        //포즈네임이 인식결과 없는 경우
                        else
                        {

                        }





                    }

                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                }

                }
            }
        });
    }

    public void no_pose_detection()
    {

        Log.d("포즈인식불가1", "no_pose_detection: ");

        if(PoseInformation.array_count==-1){
            //array_count가 -1일 경우 카메라 중지
            preview.stop();
        }
        else if(posename_array.size() == PoseInformation.array_count) {
            //개수 -1로 변경 (1번만 작동하도록)
            PoseInformation.array_count=-1;
            //동작을 다 실행한 경우 액티비티 이동
            Log.d("동작 실행 완료", "동작 " + String.valueOf(posename_array.size()) + "개 실행 완료");

            if(content_title.contains("평가"))
            {
                Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();

            }

            pauseTimer();

            if(on_display_value==1) {


                //여기 띄어주면 될 듯
                pose_complete_layout.startAnimation(pose_complete_start_animation);
                pose_complete_layout.setVisibility(View.VISIBLE);
                exercise_boolean = false;
                if(content_title.contains("평가"))
                {
                    Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();
                    progressBar.setVisibility(View.VISIBLE);
                    //녹화종료해주기
                    if(recordBool)
                    {
                        set_record_evaluation();
                    }
                }
             /*   Intent intent = new Intent(PoseActivity.this, GetDateActivity_kt.class);


                intent.putExtra("class_code", class_code);
                intent.putExtra("unit_code", unit_class_code);
                intent.putExtra("pose_result_Array", pose_resultInformation);
                intent.putExtra("content_title", content_title);
                intent.putExtra("position_number", position_number);
                intent.putExtra("array_size", array_size);


                startActivity(intent);
                finish();*/

            }
        }
        else if(posename_array.size() > PoseInformation.array_count && 0 <= PoseInformation.array_count){

            Log.d("포즈인식불가2", "no_pose_detection: ");


            if(!start_timer_value){

                Log.d("자세인식", "test: "+"시작!");
                start_timer_value= true;
                //타이머 초기화
                START_TIME_IN_MILLIS = posetime_array.get(0);
                mTimeLeftInMillis= START_TIME_IN_MILLIS;
                progressBar.setVisibility(View.GONE);
                //타이머 시작
                startTimer();
            }
            //실행할 동작이 남은 경우

            if(PoseInformation.pose_count==posecount_array.get(PoseInformation.array_count)||!mTimerRunning) {
                // 해당 동작의 개수를 모두 완료했거나, 타이머의 시간이 종료되었을 경우 -> 다음 동작으로 이동

                if (Next_Pose_mTimerRunning_value == 0) {

                    Next_Pose_mTimerRunning_value = 1;

                    if(photo_value==false&&photo_capture_value==0)
                    {
                        Log.d("사진촬영", "detectSkeletonPoint:"+"사진촬영");
                        photo_value = true;
                    }

                    //완료한 동작의 평균점수 저장
                    ResultInformation.result_list.add(pose_name + "-" + PoseInformation.pose_score_average);

                    long exercise_time = START_TIME_IN_MILLIS - mTimeLeftInMillis;

                    Log.d(TAG, "detectSkeletonPoint: "+exercise_time);

                    int set_exercise_time = (int) exercise_time;



                    if(pose_time<set_exercise_time)
                    {
                        set_exercise_time = pose_time;
                    }


                    //포즈 결과값 저장하기
                    pose_resultInformation.add(new Pose_ResultInformation(pose_content_name, pose_category_name, pose_detail_name, String.format("%.0f", PoseInformation.pose_score_average), Integer.toString(PoseInformation.pose_count), Integer.toString(set_exercise_time/ 1000+1)));


                    if (posetime_array.size() > PoseInformation.array_count) {

                        PoseInformation.array_count = PoseInformation.array_count + 1;

                        try {

                            //동작 이름 설정
                            pose_name = posename_array.get(PoseInformation.array_count);
                            //동작 카테고리 이름
                            pose_category_name = pose_category_name_array.get(PoseInformation.array_count);
                            get_pose_category_name = pose_category_name;
                            //디테일이름
                            pose_detail_name = pose_detail_name_array.get(PoseInformation.array_count);
                            //개수 설정
                            pose_count = posecount_array.get(PoseInformation.array_count);
                            //시간 설정
                            pose_time = posetime_array.get(PoseInformation.array_count);

                            pose_content_name = pose_content_name_array.get(PoseInformation.array_count);

                            // VIEW 설정 (동작 이름, 동작 개수, 동작 스코어, 스코어 리스트)
                            posename_textview.setText(pose_name);
                            posecount_textview.setText("0" + "/" + String.valueOf(posecount_array.get(PoseInformation.array_count)));
                            posescore_textview.setText(PoseInformation.pose_score);

                            if (PoseInformation.array_count >= 1) {

                                pose_name_item.get(PoseInformation.array_count - 1).setPose_value(0);
                                pose_name_item.get(PoseInformation.array_count).setPose_value(1);
                                pose_name_adapter.notifyDataSetChanged();
                            }


                            Glide.with(getApplicationContext()).load(pose_gif_url_array.get(PoseInformation.array_count)).listener(new RequestListener<Drawable>() {
                                @Override
                                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {

                                    return false;
                                }

                                @Override
                                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                                    if (isFirstResource) {
                                        progressBar.setVisibility(View.GONE);
                                        //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                                    } else {
                                        //progressBar.setVisibility(View.VISIBLE);
                                    }
                                    return false;
                                }
                            })
                                    .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                                    .into(new DrawableImageViewTarget(main_imageview));

                            Glide.with(getApplicationContext()).load(pose_gif_url_array.get(PoseInformation.array_count)).listener(new RequestListener<Drawable>() {
                                @Override
                                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {

                                    return false;
                                }

                                @Override
                                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                                    if (isFirstResource) {
                                        progressBar.setVisibility(View.GONE);
                                        //Toast.makeText(getApplicationContext(), "준비완료", Toast.LENGTH_SHORT).show();
                                    } else {
                                        //progressBar.setVisibility(View.VISIBLE);
                                    }

                                    return false;
                                }
                            })
                                    .apply(new RequestOptions().placeholder(R.drawable.black_drawable))
                                    .into(new DrawableImageViewTarget(side_gif_imageview));



                            pauseTimer();
                            //타이머 초기화
                            START_TIME_IN_MILLIS = posetime_array.get(PoseInformation.array_count);
                            mTimeLeftInMillis = START_TIME_IN_MILLIS;

                            //타이머 시작

                            if(evaluation_value.equals("1"))
                            {
                              startTimer();
                              Next_Pose_mTimerRunning_value=0;
                            }
                            else{

                            next_exercise_start_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_in);// Create the animation.
                            next_exercise_post_parent_layout.startAnimation(next_exercise_start_animation);
                            next_exercise_post_parent_layout.setVisibility(View.VISIBLE);
                            next_exercise_pose_name_textview.setText(posename_array.get(PoseInformation.array_count));
                            next_exercise_start_animation.setAnimationListener(new Animation.AnimationListener() {
                                @Override
                                public void onAnimationStart(Animation animation) {

                                }

                                @Override
                                public void onAnimationEnd(Animation animation) {

                                    Next_Exercise_startTimer();
                                }

                                @Override
                                public void onAnimationRepeat(Animation animation) {

                                }
                            });

                            }
                        }


                        catch (IndexOutOfBoundsException t) {

                            //포즈 상태, 개수, 스코어, 각도, 리스트 초기화
                            PoseInformation.pose_status = false;
                            PoseInformation.pose_status_sub = false;
                            PoseInformation.pose_degree = 180;
                            PoseInformation.pose_count = 0;
                            PoseInformation.pose_count_double = 0.0;
                            PoseInformation.pose_arraylist.clear();
                            pose_count_value=0;
                            //개수 -1로 변경 (1번만 작동하도록)
                            PoseInformation.array_count = -1;
                            //동작을 다 실행한 경우 액티비티 이동

                            pauseTimer();

                            if(content_title.contains("평가"))
                            {
                                Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();

                            }
                            if (on_display_value == 1) {
                                //no_pose_detection();

                                //여기 띄어주면 될 듯
                                pose_complete_layout.startAnimation(pose_complete_start_animation);
                                pose_complete_layout.setVisibility(View.VISIBLE);
                                exercise_boolean = false;

                                if(content_title.contains("평가"))
                                {
                                    //Toast.makeText(getApplicationContext(), "영상 저장 중입니다. 핸드폰을 끄지 말아주세요.", Toast.LENGTH_SHORT).show();
                                    progressBar.setVisibility(View.VISIBLE);
                                    //녹화종료해주기
                                    if(recordBool)
                                    {
                                        set_record_evaluation();
                                    }
                                }
                               /* Intent intent = new Intent(PoseActivity.this, GetDateActivity_kt.class);

                                intent.putExtra("class_code", class_code);
                                intent.putExtra("unit_code", unit_class_code);
                                intent.putExtra("pose_result_Array", pose_resultInformation);
                                intent.putExtra("content_title", content_title);
                                intent.putExtra("position_number", position_number);
                                intent.putExtra("array_size", array_size);


                                startActivity(intent);
                                finish();*/

                            }
                        }
                    }


                    //포즈 상태, 개수, 스코어, 각도, 리스트 초기화
                    PoseInformation.pose_status = false;
                    PoseInformation.pose_status_sub = false;
                    PoseInformation.pose_degree = 180;
                    PoseInformation.pose_count = 0;
                    PoseInformation.pose_count_double = 0.0;
                    PoseInformation.pose_arraylist.clear();
                    pose_count_value=0;
                    if (posename_array.size() == PoseInformation.array_count) {

                        //개수 -1로 변경 (1번만 작동하도록)
                        PoseInformation.array_count = -1;
                        //동작을 다 실행한 경우 액티비티 이동

                        pauseTimer();


                        if (on_display_value == 1) {
                            //no_pose_detection();
                            Intent intent = new Intent(PoseActivity.this, GetDateActivity_kt.class);

                            intent.putExtra("class_code", class_code);
                            intent.putExtra("unit_code", unit_class_code);
                            intent.putExtra("pose_result_Array", pose_resultInformation);
                            intent.putExtra("content_title", content_title);
                            intent.putExtra("position_number", position_number);
                            intent.putExtra("array_size", array_size);


                            startActivity(intent);
                            finish();

                        }
                    }

                }

            }

        }
    }

    //타이머 시작
    private void startTimer() {
        mCountDownTimer = new CountDownTimer(mTimeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                mTimeLeftInMillis = millisUntilFinished;
                updateCountDownText();

            }
            @Override
            public void onFinish() {
                mTimerRunning = false;

                if(draw_value==0)
                {
                    //PoseInformation.array_count=PoseInformation.array_count+1;
                    no_pose_detection();
                }

            }
        }.start();
        mTimerRunning = true;
    }
    //타이머 정지
    private void pauseTimer() {
        mCountDownTimer.cancel();
        mTimerRunning = false;
    }

    private void resetTimer() {
        mTimeLeftInMillis = posetime_array.get(PoseInformation.array_count);
        updateCountDownText();
    }


    private void updateCountDownText() {
        int minutes = (int) (mTimeLeftInMillis / 1000) / 60;
        int seconds = (int) (mTimeLeftInMillis / 1000) % 60;
        String timeLeftFormatted = String.format(Locale.getDefault(), "%02d:%02d", minutes, seconds);
        posetime_textview.setText(timeLeftFormatted);
    }


    //카메라 관련 소스
    //카메라 동작
    private void createCameraSource(String model) {
        // If there's no existing cameraSource, create one.
        if (cameraSource == null) {

            cameraSource = new CameraSource(this, graphicOverlay);

        }

        try {

            switch (model) {
                case POSE_DETECTION:
                    Log.d("posedetector 스위치: ", "posedetector 스위치");
                    PoseDetectorOptionsBase poseDetectorOptions = PreferenceUtils.getPoseDetectorOptionsForLivePreview(this);
                    Log.i(TAG, "Using Pose Detector with options " + poseDetectorOptions);
                    boolean shouldShowInFrameLikelihood = PreferenceUtils.shouldShowPoseDetectionInFrameLikelihoodLivePreview(this);
                    cameraSource.setMachineLearningFrameProcessor(new PoseDetectorProcessor(this, poseDetectorOptions, shouldShowInFrameLikelihood));


                    break;
                default:
                    Log.e(TAG, "Unknown model: " + model);
            }
        } catch (RuntimeException e) {
            Log.e(TAG, "Can not create image processor: " + model, e);
            Toast.makeText(
                    getApplicationContext(),
                    "Can not create image processor: " + e.getMessage(),
                    Toast.LENGTH_LONG)
                    .show();
        }
    }

    /**
     * Starts or restarts the camera source, if it exists. If the camera source doesn't exist yet
     * (e.g., because onResume was called before the camera source was created), this will be called
     * again when the camera source is created.
     */
    private void startCameraSource() {
        if (cameraSource != null) {
            try {
                if (preview == null) {
                    Log.d(TAG, "resume: Preview is null");
                }
                if (graphicOverlay == null) {
                    Log.d(TAG, "resume: graphOverlay is null");
                }
                //카메라 시작
                preview.start(cameraSource, graphicOverlay);
                //.start2(cameraSource);


            } catch (IOException e) {
                Log.e(TAG, "Unable to start camera source.", e);
                cameraSource.release();
                cameraSource = null;
            }
        }
    }

    @Override
    public synchronized void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
        // An item was selected. You can retrieve the selected item using
        // parent.getItemAtPosition(pos)
        selectedModel = parent.getItemAtPosition(pos).toString();
        Log.d(TAG, "Selected model: " + selectedModel);
        preview.stop();
        if (allPermissionsGranted()) {
            createCameraSource(selectedModel);
            startCameraSource();
        } else {
            getRuntimePermissions();
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
        // Do nothing.
    }

    //카메라 앞뒤 전환
    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Log.d(TAG, "Set facing");
        if (cameraSource != null) {
            //내화면 작게, 이미지 크게
            if (isChecked) {
                //카메라 앞
                //cameraSource.setFacing(CameraSource.CAMERA_FACING_FRONT);
                Toast.makeText(getApplicationContext(), "내화면 작게, 이미지 크게", Toast.LENGTH_SHORT).show();
                side_image_value = 1;
                main_imageview.setVisibility(View.VISIBLE);
                side_gif_imageview.setVisibility(View.GONE);
                imageView.setVisibility(View.VISIBLE);
            }
            //내 화면 작게, 이미지 작게
            else {
                //카메라 뒤
                //cameraSource.setFacing(CameraSource.CAMERA_FACING_BACK);
                Toast.makeText(getApplicationContext(), "내화면 크게, 이미지 작게", Toast.LENGTH_SHORT).show();
                side_image_value = 0;
                main_imageview.setVisibility(View.GONE);
                side_gif_imageview.setVisibility(View.VISIBLE);
                imageView.setVisibility(View.GONE);
            }
        }
        //preview.stop();
        //startCameraSource();
    }


    private String[] getRequiredPermissions() {

        try {
            PackageInfo info =
                    this.getPackageManager()
                            .getPackageInfo(this.getPackageName(), PackageManager.GET_PERMISSIONS);
            String[] ps = info.requestedPermissions;
            if (ps != null && ps.length > 0) {
                return ps;
            } else {
                return new String[0];
            }
        } catch (Exception e) {
            return new String[0];
        }
    }

    private boolean allPermissionsGranted() {
        for (String permission : getRequiredPermissions()) {
            if (!isPermissionGranted(this, permission)) {
                return false;
            }
        }
        return true;
    }

    private void getRuntimePermissions() {
        List<String> allNeededPermissions = new ArrayList<>();
        for (String permission : getRequiredPermissions()) {
            if (!isPermissionGranted(this, permission)) {
                allNeededPermissions.add(permission);
            }
        }

        if (!allNeededPermissions.isEmpty()) {
            ActivityCompat.requestPermissions(
                    this, allNeededPermissions.toArray(new String[0]), PERMISSION_REQUESTS);
        }
    }

    @Override
    public void onRequestPermissionsResult(
            int requestCode, String[] permissions, int[] grantResults) {
        Log.i(TAG, "Permission granted!");
        if (allPermissionsGranted()) {
            createCameraSource(selectedModel);
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    private static boolean isPermissionGranted(Context context, String permission) {
        if (ContextCompat.checkSelfPermission(context, permission)
                == PackageManager.PERMISSION_GRANTED) {
            Log.i(TAG, "Permission granted: " + permission);
            return true;
        }
        Log.i(TAG, "Permission NOT granted: " + permission);
        return false;
    }


    //============================================================운동 시작 전 타이머 조절 =========================================
    Animation start_anim;
    Animation end_anim;
    //타이머 시작
    private void Pose_start_startTimer() {
        Pose_Start_mCountDownTimer = new CountDownTimer(Pose_Start_mTimeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                Pose_Start_mTimeLeftInMillis = millisUntilFinished;
                Pose_Start_updateCountDownText();

            }

            @Override
            public void onFinish() {
                Pose_Start_mTimerRunning = false;
                Pose_Start_mCountDownTimer.cancel();
                //Pose_Start_mCountDownTimer.onFinish();

                pose_activity_start_timer_textview.setText(posename_array.get(0));
                pose_activity_start_timer_textview.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 80);
                start_anim = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_in);// Create the animation.
                end_anim = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_out);// Create the animation.
                pose_activity_start_timer_textview.startAnimation(start_anim);
                start_anim.setDuration(2000);

                start_anim.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {

                    }

                    @Override
                    public void onAnimationEnd(Animation animation) {

                        pose_activity_start_linearlayout.startAnimation(end_anim);
                        end_anim.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {
                                Toast.makeText(PoseActivity.this, "운동 측정 시작합니다.", Toast.LENGTH_SHORT).show();

                                exercise_boolean = true;
                                //PoseMeasure();
                                //녹화시작
                                if(content_title.contains("평가"))
                                {
                                    set_record_evaluation();
                                }

                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });

                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });


            }
        }.start();
        Pose_Start_mTimerRunning = true;
    }
    //타이머 정지
    private void Pose_start_pauseTimer() {
        Pose_Start_mCountDownTimer.cancel();
        Pose_Start_mTimerRunning = false;
    }

    private void Pose_start_resetTimer() {
        Pose_Start_mTimeLeftInMillis = Pose_FIRST_START_TIME_IN_MILLIS;
        Pose_Start_updateCountDownText();
    }


    private void Pose_Start_updateCountDownText() {

        int seconds = (int) (Pose_Start_mTimeLeftInMillis / 1000) % 60;
        String timeLeftFormatted = String.format(Locale.getDefault(), "%01d",  seconds);
        pose_activity_start_timer_textview.setText(timeLeftFormatted);

    }
//===================================================운동 중간 타이머 동작 ===============================================

    //타이머 시작
    private void Next_Exercise_startTimer() {
        Next_Pose_mCountDownTimer = new CountDownTimer(Next_Pose_mTimeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                Next_Pose_mTimeLeftInMillis = millisUntilFinished;
                Next_Exercise_Start_updateCountDownText();

            }

            @Override
            public void onFinish() {
                Next_Pose_mTimerRunning = false;
                //Next_Pose_mCountDownTimer.cancel();
                //Pose_Start_mCountDownTimer.onFinish();

                next_exercise_end_animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fade_out);// Create the animation.
                next_exercise_post_parent_layout.startAnimation(next_exercise_end_animation);

                next_exercise_end_animation.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {

                    }

                    @Override
                    public void onAnimationEnd(Animation animation)
                    {
                        Next_Pose_mTimerRunning_value = 0;
                        Next_Exercise_resetTimer();
                        startTimer();
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });


            }
        }.start();
        Next_Pose_mTimerRunning = true;
    }
    //타이머 정지
    private void Next_Exercise_pauseTimer() {
        Next_Pose_mCountDownTimer.cancel();
        Next_Pose_mTimerRunning = false;
    }

    private void Next_Exercise_resetTimer() {
        Next_Pose_mTimeLeftInMillis = Next_Pose_START_TIME_IN_MILLIS;
        Next_Exercise_Start_updateCountDownText();
    }


    private void Next_Exercise_Start_updateCountDownText() {

        int seconds = (int) (Next_Pose_mTimeLeftInMillis / 1000) % 60;
        String timeLeftFormatted = String.format(Locale.getDefault(), "%01d",  seconds);
        next_exercise_pose_count_textview.setText(timeLeftFormatted);

    }

}
