package com.funidea.newonpe.model;

import com.funidea.newonpe.model.Pose;

public class Squirt implements Pose
{
    @Override
    public boolean isQualified()
    {
        return false;
    }

    @Override
    public int getPoseScore()
    {
        return 0;
    }
}
