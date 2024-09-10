  import 'package:kpathshala/app_base/common_imports.dart';

Widget _bottomSheetType1(BuildContext context, int score,
      int listingTestScore, int readingTestScore, String timeTaken) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 50,
                  color: AppColor.navyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "/40",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          const Text(
            "Final score",
            style: TextStyle(color: AppColor.navyBlue),
          ),
          const Gap(10),
          Row(
            children: [
              _buildScoreContainer('$listingTestScore of 20', "Reading Test"),
              const SizedBox(width: 4),
              _buildScoreContainer('$readingTestScore of 20', "Listening Test"),
              const SizedBox(width: 4),
              _buildScoreContainer(timeTaken, "Time taken"),
            ],
          ),
          const SizedBox(height: 10),
          const Text("2 Retakes taken"),
          const Text("3h 21m spent in total"),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 49,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Close"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AppColor.navyBlue),
        ),
      ),
    );
  }

  Widget _buildScoreContainer(String score, String label) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(135, 206, 235, 0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                score,
                style: const TextStyle(
                  color: AppColor.navyBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: AppColor.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
 Widget _bottomSheetType2(
      BuildContext context, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildButton("Solve video", Colors.lightBlue, () {}),
          const SizedBox(height: 16),
          _buildButton("Solve video", Colors.lightBlue, () {}),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Retake test"),
            ),
          ),
        ],
      ),
    );
  }
