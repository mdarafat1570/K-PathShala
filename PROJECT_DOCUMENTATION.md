# K-PathShala — Project Documentation

## অ্যাপ পরিচিতি
- **App name:** K-PathShala (Flutter)
- **Android package:** `com.designdebugger.kpathshala`
- **Version:** 1.0.7+7
- **minSdk:** 23, **compileSdk/targetSdk:** 34

## এখন পর্যন্ত যা যা কাজ হয়েছে (Feature Inventory)

| মডিউল | বিবরণ |
|---|---|
| Splash / App bootstrap | Firebase init, OneSignal push init + permission request, deep link handling (`/courses`, `/ExamPurchasePage`, `/ProfileScreenInMainPage`, `/PaymentHistory`) |
| Authentication / Login-Signup | মোবাইল নম্বর দিয়ে OTP ভিত্তিক রেজিস্ট্রেশন/লগইন, ডিভাইস আইডি ক্যাপচার (২টি ডিভাইসের limit), Google ও Facebook সোশ্যাল লগইন |
| Home / Dashboard | ইমেজ ক্যারোসেল, পরীক্ষার performance গ্রাফ, shimmer লোডিং |
| Courses | কোর্স/প্যাকেজ ব্রাউজিং |
| Exam Module (সবচেয়ে বড় মডিউল) | Exam purchase, UBT mock test, quiz attempt ফ্লো (question navigation, option selection, zoomable images, listening প্রশ্নের জন্য audio playback/TTS), review, results, প্যাকেজ purchase bottom sheet, SSLCommerz payment sandbox |
| Notes / Video Lecture Notes | Question set-ভিত্তিক নোট যোগ/দেখা, explanation ভিডিও |
| Books / Bookselling | ফিজিক্যাল/ডিজিটাল বই অর্ডার (README অনুযায়ী স্ক্রিনশট-প্রোটেক্টেড ডিজিটাল বই) |
| Payment | SSLCommerz checkout, payment history, bKash (placeholder/অসম্পূর্ণ কোড) |
| Profile | প্রোফাইল দেখা/এডিট, সোশ্যাল অ্যাকাউন্ট কানেক্ট |
| Notifications | OneSignal push দিয়ে in-app নোটিশ |
| Common Infra | shared UI (loading/shimmer), connectivity-lost screen, device-id helper, network-aware wrapper, GetX দিয়ে global offline handling |

## Tech Stack / Third-party Integrations
- **Firebase:** core, auth, analytics
- **Social Auth:** Google Sign-In, Facebook Auth
- **Push Notification:** OneSignal
- **Payment Gateway:** SSLCommerz (live, ব্যবহৃত হচ্ছে) — bKash অসম্পূর্ণ/dead code
- **State Management:** GetX (`get`)
- **Networking:** `http` প্যাকেজ (BaseRepository এর মাধ্যমে) — `dio` dependency আছে কিন্তু কোডে ব্যবহার হয়নি
- **Media/UX:** youtube_player_flutter, audioplayers, flutter_tts, cached_network_image, carousel_slider, fl_chart, shimmer, lottie
- **Local Storage:** shared_preferences (authToken, login credentials, OneSignal user id)

## API Architecture সংক্ষেপে
- Base URL: `lib/api/api_container.dart` এ define করা (`useLiveServer` ফ্ল্যাগ দিয়ে live/dev টগল)
  - Live: `https://api.kpathshala.com/api/v1`
  - Dev: `https://dev.kpathshala.com/api/v1`
- HTTP client wrapper: `lib/authentication/base_repository.dart` (`BaseRepository`)
  - সব রিকোয়েস্টে `Content-Type: application/json` ও `Authorization: Bearer <token>` (SharedPreferences থেকে)
  - Internet না থাকলে ConnectionLost স্ক্রিনে নিয়ে যায়
  - HTTP 401 এ Session Expired ডায়ালগ দেখিয়ে অটো লগআউট

## API Endpoints (সংক্ষিপ্ত তালিকা — বিস্তারিত Postman collection-এ)

### Auth / OTP
- `POST /send-otp`
- `POST /verify-otp`
- `POST /auth/register`
- `POST /logout`

### Profile
- `GET /profile`
- `POST /user-update` (JSON বা multipart, image সহ)

### Dashboard
- `GET /dashboard`

### Packages / Courses
- `GET /package`

### Exam / Question Sets
- `GET /question-sets?package_id=`
- `GET /question?questionSetId=`
- `POST /text-to-speech`
- `POST /answer_submission`
- `GET /result_question_set?questionSetId=`
- `GET /answer_review?questionSetId=`

### Notes
- `GET /notes?questionSetId=`
- `GET /setExplanationVideo?questionSetId=`
- `POST /notes`
- `PUT /notes/{noteId}`
- `DELETE /notes/{noteId}`

### Payment
- `GET /payment_history`
- `POST /payments`

### Third-party
- `GET https://www.googleapis.com/youtube/v3/channels` (YouTube চ্যানেল স্ট্যাটিসটিক্স)

> সম্পূর্ণ রিকোয়েস্ট বডি, হেডার ও উদাহরণসহ Postman collection দেখুন: `postman/K-PathShala.postman_collection.json`

## নিরাপত্তা সংক্রান্ত নোট (আলাদাভাবে ঠিক করা দরকার)
- `lib/view/exam_main_page/widgets/payment_sandbox.dart` এ SSLCommerz live store id/password হার্ডকোড করা আছে
- `lib/api/api_container.dart` এ YouTube API key হার্ডকোড করা আছে
- `lib/main.dart` এ OneSignal App ID হার্ডকোড করা আছে
- `android/app/build.gradle` এ keystore alias/password প্লেইনটেক্সটে আছে
- এগুলো production-এ যাওয়ার আগে env variable/secure config এ সরিয়ে নেওয়া উচিত

## Postman ব্যবহারের নির্দেশনা
1. `postman/K-PathShala.postman_collection.json` ফাইলটি Postman-এ Import করুন।
2. Collection Variables থেকে `base_url` চেক করুন (default: live)।
3. `Verify OTP` কল করার পর response থেকে token কপি করে `auth_token` variable-এ বসান — এরপর বাকি সব authenticated endpoint কাজ করবে।
