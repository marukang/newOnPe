package com.dev.voltsoft.lib.session.kakao;

import com.dev.voltsoft.lib.session.SessionLogin;
import com.dev.voltsoft.lib.session.SessionType;
import com.kakao.usermgmt.response.MeV2Response;
import com.kakao.usermgmt.response.model.UserProfile;

public class KaKaoSessionLogin extends SessionLogin<MeV2Response>
{
    @Override
    public SessionType getTargetSessionType()
    {
        return SessionType.KAKAO;
    }
}
