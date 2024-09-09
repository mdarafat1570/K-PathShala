import "package:kpathshala/app_base/common_imports.dart";
import "package:kpathshala/view/Profile%20page/profile_edit.dart";

class BeforeProfile extends StatefulWidget {
  const BeforeProfile({super.key});

  @override
  State<BeforeProfile> createState() => _BeforeProfileState();
}

class _BeforeProfileState extends State<BeforeProfile> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  slideNavigationPush(const Profile(), context);
                },
                child: Text("Profile page")),
            ElevatedButton(onPressed: () {}, child: Text("Sign up"))
          ],
        ),
      ),
    ));
  }
}
