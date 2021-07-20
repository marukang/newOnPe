package com.funidea.utils;

import android.graphics.Camera;
import android.graphics.Matrix;
import android.view.animation.Animation;
import android.view.animation.Transformation;

public class Rotate3dAnimation extends Animation {
    private final float mFromDegrees;
    private final float mToDegrees;
    private final float mCenterX;
    private final float mCenterY;
    private final float mDepthZ;
    private final boolean mReverse;
    private Camera mCamera;

    public Rotate3dAnimation(float fromDegrees, float toDegrees, float centerX, float centerY, float depthZ, boolean reverse) {
        this.mFromDegrees = fromDegrees;
        this.mToDegrees = toDegrees;
        this.mCenterX = centerX;
        this.mCenterY = centerY;
        this.mDepthZ = depthZ;
        this.mReverse = reverse;
    }

    public void initialize(int width, int height, int parentWidth, int parentHeight) {
        super.initialize(width, height, parentWidth, parentHeight);
        this.mCamera = new Camera();
    }

    protected void applyTransformation(float interpolatedTime, Transformation t) {
        float fromDegrees = this.mFromDegrees;
        float degrees = fromDegrees + (this.mToDegrees - fromDegrees) * interpolatedTime;
        float centerX = this.mCenterX;
        float centerY = this.mCenterY;
        Matrix matrix = t.getMatrix();
        float ratio = this.mReverse ? interpolatedTime : 1.0F - interpolatedTime;
        float depthZ = this.mDepthZ * ratio;
        this.mCamera.save();
        this.mCamera.translate(0.0F, 0.0F, depthZ);
        this.mCamera.rotateY(degrees);
        this.mCamera.getMatrix(matrix);
        this.mCamera.restore();
        matrix.preTranslate(-centerX, -centerY);
        matrix.postTranslate(centerX, centerY);
    }
}
