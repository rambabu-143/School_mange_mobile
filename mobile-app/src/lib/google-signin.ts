import { Platform } from 'react-native';
import { GoogleSignin } from '@react-native-google-signin/google-signin';

// Same OAuth clients the native apps use (android build.gradle ServerClientId / iOS GoogleService-Info.plist CLIENT_ID).
// The backend checks the ID token's audience: native Android requests it for the web (server) client,
// native iOS never sets a server client, so its token's audience is the iOS client. Match both.
GoogleSignin.configure({
  webClientId:
    Platform.OS === 'android' ? '531308145809-7hf2v0bk9j4d5fe6i7om5gv7ud3qgmia.apps.googleusercontent.com' : undefined,
  iosClientId: '531308145809-6b1f2itukpt6rdmslhhahkfo8dntjnbl.apps.googleusercontent.com',
});

/** Returns null if the user cancelled the Google sheet. */
export async function pickGoogleAccount(): Promise<{ email: string; idToken: string } | null> {
  await GoogleSignin.hasPlayServices();
  const res = await GoogleSignin.signIn();
  if (res.type !== 'success') return null;
  const { idToken, user } = res.data;
  if (!idToken) throw new Error('Google did not return an ID token');
  return { email: user.email, idToken };
}

export const googleSignOut = () => GoogleSignin.signOut().catch(() => {});
