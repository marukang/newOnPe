package com.funidea.newonpe.page.exercise;

import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.TextView;

import androidx.core.app.ActivityCompat;

import com.funidea.newonpe.R;
import com.funidea.newonpe.camera.CameraSource;
import com.funidea.newonpe.camera.CameraSourcePreview;
import com.funidea.newonpe.camera.GraphicOverlay;
import com.funidea.newonpe.detector.PoseDetectorProcessor;
import com.funidea.newonpe.detector.PoseGraphic;
import com.funidea.newonpe.network.OnAttachmentDownloadListener;
import com.funidea.newonpe.network.ServerConnection;
import com.funidea.newonpe.page.CommonActivity;
import com.funidea.newonpe.preference.PreferenceUtils;
import com.funidea.newonpe.views.CircleProgressBar;
import com.google.android.exoplayer2.ExoPlaybackException;
import com.google.android.exoplayer2.ExoPlayerFactory;
import com.google.android.exoplayer2.PlaybackParameters;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.Timeline;
import com.google.android.exoplayer2.extractor.DefaultExtractorsFactory;
import com.google.android.exoplayer2.source.ExtractorMediaSource;
import com.google.android.exoplayer2.source.MediaSource;
import com.google.android.exoplayer2.source.TrackGroupArray;
import com.google.android.exoplayer2.trackselection.TrackSelectionArray;
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout;
import com.google.android.exoplayer2.ui.PlayerView;
import com.google.android.exoplayer2.upstream.DataSource;
import com.google.android.exoplayer2.upstream.DataSpec;
import com.google.android.exoplayer2.upstream.FileDataSource;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetectorOptionsBase;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;

import java.io.File;
import java.io.IOException;
import java.util.Locale;

public class ExercisePage extends CommonActivity implements ActivityCompat.OnRequestPermissionsResultCallback, CompoundButton.OnCheckedChangeListener
{
    public static final String POSE_DETECTION = "Pose Detection";
    public static final String TAG = "TAG";

    private Pose                    mPose;
    private PlayerView              mMediaPlayerView;
    private SimpleExoPlayer         mMediaPlayer;
    private CameraSource            mCameraSource = null;
    private CameraSourcePreview     mCameraPreview;
    private GraphicOverlay          mGraphicOverlay;
    private BaseLoaderCallback      mLoaderCallback = new BaseLoaderCallback(this) {
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
    private CircleProgressBar mProgressBar;
    private TextView    mProgressBarTextView;
    private View        mProgressBarFrame;

    @Override
    protected void init(@Nullable Bundle savedInstanceState)
    {
        setContentView(R.layout.page_exercise);

        mMediaPlayerView = findViewById(R.id.videoView);
        mCameraPreview = findViewById(R.id.preview_view);
        mGraphicOverlay = findViewById(R.id.graphic_overlay);
        mProgressBarFrame = findViewById(R.id.circleDownloadProgressFrame);
        mProgressBar = findViewById(R.id.circleDownloadProgress);
        mProgressBarTextView = findViewById(R.id.circleDownloadProgressTextView);

        if (mMediaPlayer == null)
        {
            mMediaPlayer = ExoPlayerFactory.newSimpleInstance(this);
            mMediaPlayer.addListener(new Player.EventListener() {
                @Override
                public void onTimelineChanged(Timeline timeline, @androidx.annotation.Nullable @Nullable Object manifest, int reason) {

                }

                @Override
                public void onTracksChanged(TrackGroupArray trackGroups, TrackSelectionArray trackSelections) {

                }

                @Override
                public void onLoadingChanged(boolean isLoading) {

                }

                @Override
                public void onPlayerStateChanged(boolean playWhenReady, int playbackState) {

                }

                @Override
                public void onRepeatModeChanged(int repeatMode) {

                }

                @Override
                public void onShuffleModeEnabledChanged(boolean shuffleModeEnabled) {

                }

                @Override
                public void onPlayerError(ExoPlaybackException error) {

                }

                @Override
                public void onPositionDiscontinuity(int reason) {

                }

                @Override
                public void onPlaybackParametersChanged(PlaybackParameters playbackParameters) {

                }

                @Override
                public void onSeekProcessed() {

                }
            });
        }

        mMediaPlayerView.setPlayer(mMediaPlayer);
        mMediaPlayerView.setUseController(false);
        mMediaPlayerView.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_ZOOM);

        if (isAllPermissionsGranted())
        {
            initGuidePlayer();
        }
    }

    private void initGuidePlayer()
    {
        File destinationFile = new File(getExternalCacheDir(),"guide1.mp4");

        if (destinationFile.exists())
        {
            startMediaPlayer(Uri.fromFile(destinationFile));

            mProgressBarFrame.setVisibility(View.GONE);
            mProgressBar.setProgress(0);
        }
        else
        {
            ServerConnection.INSTANCE.downloadGuideVideo(destinationFile, new OnAttachmentDownloadListener() {
                @Override
                public void onAttachmentDownloadedSuccess()
                {
                    mProgressBarFrame.setVisibility(View.GONE);
                    mProgressBar.setProgress(0);

                    startMediaPlayer(Uri.fromFile(destinationFile));
                }

                @Override
                public void onAttachmentDownloadedError()
                {

                }

                @Override
                public void onAttachmentDownloadedFinished()
                {

                }

                @Override
                public void onAttachmentDownloadUpdate(int percent)
                {
                    runOnUiThread(() -> {
                        mProgressBarTextView.setText(String.format(Locale.KOREA, "%d%%", percent));
                        mProgressBar.setProgress(percent);
                    });
                }
            });
        }
    }


    @Override
    public void onCheckedChanged(CompoundButton compoundButton, boolean b) {

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NotNull String[] permissions, @NotNull int[] grantResults)
    {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (isAllPermissionsGranted())
        {
            initGuidePlayer();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (isAllPermissionsGranted())
        {
            if (!OpenCVLoader.initDebug())
            {
                OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_2_0, this, mLoaderCallback);
            }
            else
            {
                mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
            }

            createCameraSource();

            startCameraSource();

            startPoseMeasure();
        }
        else
        {
            requestRuntimePermissions();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();

        if (mMediaPlayer != null) {
            mMediaPlayer.release();
            mMediaPlayer = null;
        }

        if (mCameraPreview != null) {
            mCameraPreview.stop();
        }
    }

    private void createCameraSource()
    {
        // If there's no existing cameraSource, create one.
        if (mCameraSource == null) {
            mCameraSource = new CameraSource(this, mGraphicOverlay);
        }

        try {

            PoseDetectorOptionsBase poseDetectorOptions = PreferenceUtils.getPoseDetectorOptionsForLivePreview(this);

            boolean shouldShowInFrameLikelihood = PreferenceUtils.shouldShowPoseDetectionInFrameLikelihoodLivePreview(this);
            mCameraSource.setMachineLearningFrameProcessor(new PoseDetectorProcessor(this, poseDetectorOptions, shouldShowInFrameLikelihood));

        } catch (RuntimeException e)
        {
            e.printStackTrace();
        }
    }

    private void startMediaPlayer(Uri uri)
    {
        DataSpec dataSpec = new DataSpec(uri);
        final FileDataSource fileDataSource = new FileDataSource();
        try {
            fileDataSource.open(dataSpec);
        } catch (FileDataSource.FileDataSourceException e) {
            e.printStackTrace();
        }

        DataSource.Factory factory = () -> fileDataSource;
        MediaSource audioSource = new ExtractorMediaSource(fileDataSource.getUri(),
                factory, new DefaultExtractorsFactory(), null, null);
        mMediaPlayer.setPlayWhenReady(true);
        mMediaPlayer.prepare(audioSource);
    }

    private void startCameraSource()
    {
        if (mCameraSource != null)
        {
            try
            {
                if (mCameraPreview == null) {
                    Log.d(TAG, "resume: Preview is null");
                }

                if (mGraphicOverlay == null) {
                    Log.d(TAG, "resume: graphOverlay is null");
                }
                mCameraPreview.start(mCameraSource, mGraphicOverlay);
            }
            catch (IOException e)
            {
                Log.e(TAG, "Unable to start camera source.", e);
                mCameraSource.release();
                mCameraSource = null;
            }
        }
    }

    private void startPoseMeasure()
    {
        PoseGraphic poseGraphic = new PoseGraphic(mGraphicOverlay, mPose,false);
        poseGraphic.setDrawViewListener(drawPoint -> {

        });
    }

}
