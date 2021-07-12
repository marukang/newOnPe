package kr.co.onpe.common;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.client.RestTemplate;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

public class Fcm_Util {
	public void send_FCM(List<String> tokenId, String title, String content) {
		try {
			
			RestTemplate template = new RestTemplate();
			
			String path = "/resources/onpeproject-firebase-adminsdk-tkivq-9372299288.json";
            String MESSAGING_SCOPE = "https://www.googleapis.com/auth/firebase.messaging";
            String[] SCOPES = { MESSAGING_SCOPE };
            
            FirebaseOptions options = new FirebaseOptions.Builder()
            		.setCredentials(GoogleCredentials.fromStream(new FileInputStream(path)))
            		.build();
            if(FirebaseApp.getApps().isEmpty()) {
            	FirebaseApp.initializeApp(options);
            }
            List<Message> messages = new ArrayList<Message>();
            
            for(int x=0;x<tokenId.size();x++) {
            	messages.add(Message.builder()
            			.setNotification(Notification.builder()
            	                .setTitle(title)
            	                .setBody(content)
            	                .build())
            	            .setToken(tokenId.get(x))
            	            .build());
            	if(messages.size() > 499) {
            		BatchResponse response = FirebaseMessaging.getInstance().sendAll(messages);
            		messages = new ArrayList<Message>();
            	}
            }
            
            if(messages.size() > 0) {
            	BatchResponse response = FirebaseMessaging.getInstance().sendAll(messages);
        		messages = new ArrayList<Message>();
            }
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}
