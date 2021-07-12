package com.funidea.newonpe.serviceClass;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import com.funidea.newonpe.R;
import com.funidea.newonpe.SplashActivity;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.jetbrains.annotations.NotNull;

import java.util.List;

import static android.content.ContentValues.TAG;


/** 웹 페이지에서 선생님 혹은 관리자가 Push (FCM)를 보냈을 때
 * 해당 메세지를 Catch 하여 띄울 수 있도록 해주는 Service Class
 *
 */

public class MyFirebaseMessagingService  extends FirebaseMessagingService {


    private static final String CHANNEL_NAME = "com.funidea.newonpe.serviceClass";
    private static final int REQUEST_CODE = 100;



    @Override
    public void onNewToken(@NonNull @org.jetbrains.annotations.NotNull String s) {
        super.onNewToken(s);
        Log.d(TAG, "onNewToken ------> " + s);
        sendRegistrationToServer(s);
    }

    @Override
    public void onMessageReceived(@NonNull @NotNull RemoteMessage remoteMessage) {
        // TODO(developer): Handle FCM messages here.
        // Not getting messages here? See why this may be: https://goo.gl/39bRN
        super.onMessageReceived(remoteMessage);
        Log.d(TAG, "From: "+remoteMessage.getFrom());


        try{

        if(remoteMessage.getData().size() > 0){
            Log.d(TAG, "Message data payload : " + remoteMessage.getData());

            if (/* Check if data needs to be processed by long running job */ true) {
                // For long-running tasks (10 seconds or more) use WorkManager.
                scheduleJob();
            } else {
                // Handle message within 10 seconds
                handleNow();
            }
        }

        if(remoteMessage.getNotification() != null){
            Log.d(TAG, "Message Notification Body : " + remoteMessage.getNotification().getBody());
        }
        sendNotification(remoteMessage.getNotification().getBody());


        }
        catch (NullPointerException nullPointerException)
        {

        }
    }


    private void scheduleJob() {
        // [START dispatch_job]
        OneTimeWorkRequest work = new OneTimeWorkRequest.Builder(MyWorker.class)
                .build();
        WorkManager.getInstance().beginWith(work).enqueue();
        // [END dispatch_job]
    }

    /**
     * Handle time allotted to BroadcastReceivers.
     */
    private void handleNow() {
        Log.d(TAG, "Short lived task is done.");
    }

    /**
     * Persist token to third-party servers.
     *
     * Modify this method to associate the user's FCM InstanceID token with any server-side account
     * maintained by your application.
     *
     * @param token The new token.
     */
    private void sendRegistrationToServer(String token) {
        // TODO: Implement this method to send token to your app server.
    }

    /**
     * Create and show a simple notification containing the received FCM message.
     *
     * @param messageBody FCM message body received.
     */
    private void sendNotification(String messageBody) {

        Log.d("메세지바디", "sendNotification:"+messageBody);

        Log.d("확인", "sendNotification:"+isAppRunning(this));
        String channelId = getString(R.string.default_notification_channel_id);
        if(isAppRunning(this))
        {

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationCompat.Builder notificationBuilder =
                    new NotificationCompat.Builder(this, channelId)
                            .setSmallIcon(R.drawable.image_logo)
                            .setContentTitle("온체육")
                            .setContentText(messageBody)
                            .setAutoCancel(true)
                            .setSound(defaultSoundUri)
                            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                            .setPriority(NotificationCompat.PRIORITY_MAX) //새로 추가 0311
                            .setDefaults(Notification.DEFAULT_VIBRATE); // 새로 추가 0311

            NotificationManager notificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

            // Since android Oreo notification channel is needed.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                NotificationChannel channel = new NotificationChannel(channelId,
                        CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH);

                notificationManager.createNotificationChannel(channel);
                notificationManager.notify(0, notificationBuilder.build());


            }
        }
        else
        {
            Intent intent = new Intent(this, SplashActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, REQUEST_CODE /* Request code */, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT);

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationCompat.Builder notificationBuilder =
                    new NotificationCompat.Builder(this, channelId)
                            .setSmallIcon(R.drawable.image_logo)
                            .setContentTitle("온체육")
                            .setContentText(messageBody)
                            .setAutoCancel(true)
                            .setSound(defaultSoundUri)
                            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                            .setPriority(NotificationCompat.PRIORITY_MAX) //새로 추가 0311
                            .setDefaults(Notification.DEFAULT_VIBRATE) // 새로 추가 0311
                            .setContentIntent(pendingIntent);

            NotificationManager notificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

            // Since android Oreo notification channel is needed.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                NotificationChannel channel = new NotificationChannel(channelId,
                        CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH);

                notificationManager.createNotificationChannel(channel);
                notificationManager.notify(0, notificationBuilder.build());


            }

        }






    }

    private boolean isAppRunning(Context context){
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> procInfos = activityManager.getRunningAppProcesses();
        for(int i = 0; i < procInfos.size(); i++){
            if(procInfos.get(i).processName.equals(context.getPackageName())){

                return true;
            }
        }

        return false;
    }

}