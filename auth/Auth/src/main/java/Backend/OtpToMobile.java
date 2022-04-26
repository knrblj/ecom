//$Id$
package Backend;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

public class OtpToMobile {

	public static void send(String phone, int otp) throws UnirestException {
		Unirest.setTimeouts(0, 0);
		try {
			HttpResponse<String> response = Unirest.get("https://2factor.in/API/V1/4f2a6c78-c21c-11ec-9c12-0200cd936042/SMS/+91" + phone + "/" + otp).asString();
			System.out.println(response.getBody());
		} catch (UnirestException e) {
			e.printStackTrace();
		}
	}

	// public static void send(String phone, int otp) {
	// try {
	// URL url = new URL("https://2factor.in/API/V1/4f2a6c78-c21c-11ec-9c12-0200cd936042/SMS/+91" + phone + "/" + otp);
	// HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	// connection.setRequestMethod("GET");
	// connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	//
	// // String urlParameters;
	// // connection.setRequestProperty("Content-Length", Integer.toString(urlParameters.getBytes().length));
	// connection.setRequestProperty("Content-Language", "en-US");
	//
	// connection.setUseCaches(false);
	// connection.setDoOutput(true);
	//
	// // Send request
	// DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
	//
	// wr.close();
	//
	// // Get Response
	// InputStream is = (InputStream) connection.getInputStream();
	// BufferedReader rd = new BufferedReader(new InputStreamReader(is));
	// StringBuilder response = new StringBuilder(); // or StringBuffer if Java version 5+
	// String line;
	// while ((line = rd.readLine()) != null) {
	// response.append(line);
	// response.append('\r');
	// }
	// rd.close();
	// System.out.println(response.toString());
	// } catch (Exception e) {
	// e.printStackTrace();
	//
	// }
	// }

	public static void main(String[] args) {
		try {
			send("6304417926", 123098);
		} catch (Exception e) {
			System.out.println(e);
		}
	}

}
