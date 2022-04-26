
package Backend;

import java.util.Base64;

public class Encryption {

	public static String enc(String str) {
		String res = "";
		for (int i = 0; i < str.length(); i++) {
			res += (char) (str.charAt(i) + 4);
		}
		str = res;
		String encodedString = Base64.getEncoder().encodeToString(str.trim().getBytes());
		return encodedString;
	}

	public static String dec(String str) {
		byte[] decodedBytes = Base64.getDecoder().decode(str.trim());
		String decodedString = new String(decodedBytes);
		String res = "";
		for (int i = 0; i < decodedString.length(); i++) {
			res += (char) (decodedString.charAt(i) - 4);
		}
		return res;
	}

	// public static void main(String args[]) {
	// System.out.println(enc("knrblj@gmail.com"));
	// System.out.println(dec("b3J2ZnBuRGtxZW1wMmdzcQ=="));
	// }

}