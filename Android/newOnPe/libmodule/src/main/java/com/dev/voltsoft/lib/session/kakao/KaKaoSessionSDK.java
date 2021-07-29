package com.dev.voltsoft.lib.session.kakao;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import androidx.appcompat.app.AppCompatActivity;
import com.dev.voltsoft.lib.session.*;
import com.dev.voltsoft.lib.utility.EasyLog;
import com.kakao.auth.*;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.LogoutResponseCallback;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.callback.MeV2ResponseCallback;
import com.kakao.usermgmt.response.MeV2Response;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.exception.KakaoException;

public class KaKaoSessionSDK extends KakaoAdapter implements ISessionSDK
{


    private static class LazyHolder
    {
        private static KaKaoSessionSDK mInstance = new KaKaoSessionSDK();
    }

    private Application         mApplication;

    private AppCompatActivity   mTopActivity;

    public void init(Application application)
    {
        try
        {
            mApplication = application;

            KakaoSDK.init(LazyHolder.mInstance);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    public static KaKaoSessionSDK getInstance()
    {
        return LazyHolder.mInstance;
    }

    @Override
    public IApplicationConfig getApplicationConfig()
    {
        return new IApplicationConfig()
        {

            @Override
            public Context getApplicationContext()
            {
                return mApplication;
            }
        };
    }

    @Override
    public ISessionConfig getSessionConfig()
    {
        return new ISessionConfig() {
            @Override
            public AuthType[] getAuthTypes()
            {
                return new AuthType[]{AuthType.KAKAO_TALK};
            }

            @Override
            public boolean isUsingWebviewTimer()
            {
                return false;
            }

            @Override
            public boolean isSecureMode() {
                return false;
            }

            @Override
            public ApprovalType getApprovalType()
            {
                return ApprovalType.INDIVIDUAL;
            }

            @Override
            public boolean isSaveFormData()
            {
                return true;
            }
        };
    }

    @Override
    public void login(SessionLogin sessionLogin)
    {
        EasyLog.LogMessage(">> KaKao login");

        final KaKaoSessionLogin kaKaoSessionLogin = (KaKaoSessionLogin) sessionLogin;

        if (kaKaoSessionLogin.ProgressView != null)
        {
            kaKaoSessionLogin.ProgressView.onLoading();
        }

        mTopActivity = kaKaoSessionLogin.getAppCompatActivity();

        final ISessionLoginListener<MeV2Response> loginListener = kaKaoSessionLogin.getSessionLoginListener();

        if (Session.getCurrentSession().isOpened())
        {
            requestKaKaoSession(loginListener);
        }
        else
        {
            ISessionCallback sessionCallback = new ISessionCallback()
            {
                @Override
                public void onSessionOpened()
                {
                    if (kaKaoSessionLogin.ProgressView != null)
                    {
                        kaKaoSessionLogin.ProgressView.onLoadingEnd();
                    }

                    requestKaKaoSession(loginListener);

                    Session.getCurrentSession().removeCallback(this);
                }

                @Override
                public void onSessionOpenFailed(KakaoException exception)
                {
                    if (kaKaoSessionLogin.ProgressView != null)
                    {
                        kaKaoSessionLogin.ProgressView.onLoadingEnd();
                    }

                    EasyLog.LogMessage(">> KaKao onSessionOpenFailed exception = " + exception.getMessage());

                    if (loginListener != null)
                    {
                        loginListener.onError(exception);
                    }

                    Session.getCurrentSession().removeCallback(this);
                }
            };

            Session.getCurrentSession().addCallback(sessionCallback);

            Session.getCurrentSession().open(AuthType.KAKAO_LOGIN_ALL, mTopActivity);
        }
    }

    @Override
    public void logout(final SessionLogout sessionLogout)
    {
        EasyLog.LogMessage(">> KaKao logout");

        UserManagement.getInstance().requestLogout(new LogoutResponseCallback() {
            @Override
            public void onCompleteLogout()
            {
                EasyLog.LogMessage(">> KaKao logout success");

                if (sessionLogout.getSessionLogoutListener() != null)
                {
                    sessionLogout.getSessionLogoutListener().onError();
                }
            }
        });
    }

    @Override
    public void handleActivityResult(AppCompatActivity activity, int requestCode, int resultCode, Intent data)
    {
        try
        {
            Session.getCurrentSession().handleActivityResult(requestCode, resultCode, data);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    private void requestKaKaoSession(final ISessionLoginListener<MeV2Response> loginListener)
    {
        UserManagement.getInstance().me(new MeV2ResponseCallback() {
            @Override
            public void onSessionClosed(ErrorResult errorResult)
            {
                EasyLog.LogMessage("-- KaKao onSessionClosed ErrorCode.CLIENT_ERROR_CODE");

                if (loginListener != null)
                {
                    loginListener.onError(errorResult);
                }
            }

            @Override
            public void onSuccess(MeV2Response result)
            {
                EasyLog.LogMessage(">> KaKao onSuccess");

                if (loginListener != null)
                {
                    loginListener.onLogin(result);
                }
            }
        });
    }
}
