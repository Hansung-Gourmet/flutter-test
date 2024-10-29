import "dart:async";

import "package:chating_app/add_image/add_image.dart";
import "package:chating_app/config/palette.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import "chat_screen.dart";

class LoginSignScreen extends StatefulWidget {
  const LoginSignScreen({super.key});

  @override
  State<LoginSignScreen> createState() => _LoginSignScreenState();
}

class _LoginSignScreenState extends State<LoginSignScreen> {
  final _authentication=FirebaseAuth.instance;
  bool isSignupScreen=true;//현재 signupScreen이라면!!
  final _formKey=GlobalKey<FormState>();
  String? email;
  String? pwd;
  String? name;
  bool verification=false;
  Timer? timer;
  int maxAttempts = 60;  // 3분 (3초 * 60)
  int attempts = 0;



  void _tryValidation(){
    final is_valid=_formKey.currentState!.validate();
    if(is_valid)
      {
        _formKey.currentState!.save();
      }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  Future<void> checkEmailVerified(User user) async{


    await user.reload();//user가 속해있는 FirebaseAuth 인스턴스 업데이트!!!
    //업데이트를 했으면 다시 최신 user로 가져와야한다.
    final updatedUser = FirebaseAuth.instance.currentUser;
    print("${updatedUser?.email}의 ${updatedUser!.emailVerified}");
    //나중에는 여기서 setState호출하여 verification이 true가 되면 다음 화면이 보이도록 만든다. 또는 다음 버튼이 생기도록 만든다.
    //setState(() {
      verification = updatedUser!.emailVerified;
    //});

  }
  void showAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            backgroundColor: Colors.white,
            child:AddImage(),
          );
        });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Paltette.backgroundColor,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/red.jpg"),
                    fit: BoxFit.fill,
                  )
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 90,left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Welcome",
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25,
                            color:Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: " to Yummy chat!",
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color:Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )  ,
                      Text("Singup to continue",style: TextStyle(
                        letterSpacing: 1.0,
                        color:Colors.white,
                        ),
                      ),
        
                    ],
                  ),
                )
        
              ),
            ),
            Positioned(
              top: 180,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                padding: EdgeInsets.all(20),
                height: isSignupScreen? 280 : 250,
                width:MediaQuery.of(context).size.width-40 ,//반응형 앱처럼 width를 고정시키는 것이 아니라 각 디바이스의 실제 너비 값을 구한다!!
                margin: EdgeInsets.symmetric(horizontal: 20),//좌우 마진을 20px
                decoration: BoxDecoration(//Cotainer을 꾸며주고 있는것
                  color: Colors.white,//배경색은 흰색
                  borderRadius: BorderRadius.circular(15),//모서리 둥글게
                  boxShadow: [//박스 그림자 효과주기!! 이때 여러 색깔로 누적해서 효과를 줄 수 있으므로 배열을 갖는다.
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isSignupScreen=false;//바꿔준다! 현재 Login이 선택되었어!!!!
                            });
                          },
                          child: Column(
                            children: [
                              Text("LOGIN",style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen? Paltette.textColor1 : Paltette.activeColor),
                              ),
                              if(isSignupScreen==false)
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                height: 2,
                                width: 50,
                                color: Colors.orange,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isSignupScreen=true;
                            });
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("SIGNUP",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: isSignupScreen? Paltette.activeColor :Paltette.textColor1 ),),
                                  GestureDetector(
                                      onTap:(){
                                        showAlert(context);
                                      } ,
                                      child: Icon(Icons.image,color: Colors.cyan)
                                  ),
                                ],
                              ),
                              if(isSignupScreen==true)
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                height: 2,
                                width: 50,
                                color: Colors.orange,
                              )
                            ],
                          ),
                        )
                      ]
                    ),
                    if(isSignupScreen)
                      Expanded(//남은 공간 확장하기.
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Form(//폼
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormField(
                                  key: ValueKey(1),
                                  onSaved: (value){
                                    name=value;
                                  },
                                  onChanged: (value)
                                  {
                                    print("name"+value);
                                    name=value;
                                  },
                                  validator: (value){
                                    if(value!.isEmpty||value.length<4)
                                      {
                                        return "이름은 4글자 이상이어야 합니다. 빈칸도 안돼요!!";
                                      }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon( //perfixIcon은 TextField에 이미지 넣는것!
                                        Icons.account_circle,
                                        color: Paltette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(//focusedBorder!!는 Border에 포커스 즉, 입력하고 있을때도 같은 형태의 아웃라인을 유지하도록 만들어준다!!
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: "User name",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Paltette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),//TextFormField안에 폭, 넓이
                                  ),
                                ),
                                TextFormField(
                                  key: ValueKey(2),
                                  onSaved: (value){
                                    email=value;
                                  },
                                  onChanged: (value)
                                  {
                                    email=value;
                                  },
                                  validator: (value){
                                    if(value!.isEmpty||!value.contains("@"))
                                    {
                                      return "@가 포함되어야 합니다.유효하게 입력해주세요!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon( //perfixIcon은 TextField에 이미지 넣는것!
                                      Icons.account_circle,
                                      color: Paltette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(//focusedBorder!!는 Border에 포커스 즉, 입력하고 있을때도 같은 형태의 아웃라인을 유지하도록 만들어준다!!
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: "User name",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Paltette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),//TextFormField안에 폭, 넓이
                                  ),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.emailAddress,
                                  key: ValueKey(3),
                                  onSaved: (value){
                                    pwd=value;
                                  },
                                  onChanged: (value)
                                  {
                                    pwd=value;
                                  },
                                  validator: (value){
                                    if(value!.isEmpty||value.length<6)
                                    {
                                      return "최소 6글자!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon( //perfixIcon은 TextField에 이미지 넣는것!
                                      Icons.account_circle,
                                      color: Paltette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(//focusedBorder!!는 Border에 포커스 즉, 입력하고 있을때도 같은 형태의 아웃라인을 유지하도록 만들어준다!!
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: "User name",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Paltette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),//TextFormField안에 폭, 넓이
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(//남은 공간 확장하기.
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Form(//폼
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormField(
                                  key: ValueKey(4),
                                  onSaved: (value){
                                    email=value;
                                  },
                                  validator: (value){
                                    if(value!.isEmpty||!value.contains("@"))
                                    {
                                      return "@ 가 포함되어야합니다!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon( //perfixIcon은 TextField에 이미지 넣는것!
                                      Icons.account_circle,
                                      color: Paltette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(//focusedBorder!!는 Border에 포커스 즉, 입력하고 있을때도 같은 형태의 아웃라인을 유지하도록 만들어준다!!
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Paltette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),//TextFormField안에 폭, 넓이
                                  ),
                                ),
                                TextFormField(
                                  key: ValueKey(5),
                                  onSaved: (value){
                                    pwd=value;
                                  },
                                  validator: (value){
                                    if(value!.isEmpty||value.length<6)
                                    {
                                      return "6글자 이상이어야합니다.!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon( //perfixIcon은 TextField에 이미지 넣는것!
                                      Icons.account_circle,
                                      color: Paltette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    focusedBorder: OutlineInputBorder(//focusedBorder!!는 Border에 포커스 즉, 입력하고 있을때도 같은 형태의 아웃라인을 유지하도록 만들어준다!!
                                      borderSide: BorderSide(
                                        color: Paltette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Paltette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),//TextFormField안에 폭, 넓이
                                  ),
                                ),
        
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen? 430 : 400,
              right: 0,
              left: 0,//이렇게만 작성하면 right : 0, left : 0 이므로 최대한 크게 그려서 원형이 유지가 안될것이다. 그러므로 Center을 이용한다.
              //Center을 이용하면 원형을 유지하면서 원하는 위치에 배치할 수 있다.
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: ()async
                    {
                      if(isSignupScreen)
                        {
                          _tryValidation(); //유효성검사를 하고, 문제가 없다면 save를 할 것이다.

                          try{
                            //createUserWithEmailAndPassword는 이메일과 비밀번호를 만들어준다!
                            final UserCredential newUser=await _authentication.createUserWithEmailAndPassword(
                                email: email!,
                                password: pwd!
                            );//email과 pwd가 null이 아님을 !으로 명시해주자.

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return ChatScreen();
                                }),
                                (route)=>false,
                            );

                            //아이디를 파이어스토어에 기록하는 방법.
                            await FirebaseFirestore.instance.collection("user").doc(newUser.user!.uid)
                                .set({
                                    "userName" : name,
                                    "userEmail" : email
                                   });


                            // if(newUser.user!=null) {
                            //           //인증을 하면! 으로 바꾸자 이메일을 보내고 인증을 해야한다.
                            //           await newUser.user!.sendEmailVerification(); //이메일 보내기
                            //           // 스낵바로 안내 메시지 표시
                            //           ScaffoldMessenger.of(context).showSnackBar(
                            //               SnackBar(
                            //                 content: Text('인증 이메일이 발송되었습니다. 이메일을 확인해주세요.'),
                            //                 backgroundColor: Colors.blue,
                            //               )
                            //           );
                            //           timer = Timer.periodic(
                            //               Duration(seconds: 3), (_) async {
                            //
                            //             attempts++;
                            //             await checkEmailVerified(newUser.user!);
                            //             if (verification) {
                            //               timer!.cancel(); //타이머종료
                            //               Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(builder: (context) {
                            //                     return ChatScreen();
                            //                   }));
                            //             }
                            //           });
                            //
                            //           if(attempts>maxAttempts)
                            //             {
                            //               timer!.cancel();
                            //               newUser.user!.delete();
                            //               ScaffoldMessenger.of(context).showSnackBar(
                            //                   SnackBar(
                            //                     content: Text('인증 시간이 초과되었습니다. 다시 회원가입해주세요.'),
                            //                     backgroundColor: Colors.red,
                            //                   )
                            //               );
                            //             }
                            // }

                          }catch(e)
                          {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("please check your email and password"),
                                backgroundColor: Colors.blue,
                              )
                            );
                          }
                        }
                      else{
                        _tryValidation();
                        try{
                          final newUser=await _authentication.signInWithEmailAndPassword(
                              email: email!,
                              password: pwd!);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context){
                                return ChatScreen();
                              }),
                              (route)=>false,
                          );

                        }catch(e)
                      {
                        print(e);
                      }

                      }


                     

                    },
                    child: Container(//현재 Container안에 Container을 준다. 즉, 원형 안에 원형을 준다.
                    decoration: BoxDecoration(
                      gradient: LinearGradient( //그라데이션 효과를 준다.
                          colors:[Colors.red,Colors.orange],
                          begin: Alignment.topLeft,//그라데이션 방향주기
                          end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                      child:Icon(Icons.arrow_forward,color: Colors.white,) ,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen?MediaQuery.of(context).size.height-125 : MediaQuery.of(context).size.height-165,
              left: 0,
              right: 0,//아까도 말했듯이 이렇게 left,right 을 0으로 하면 가로를 처음부터 끝까지 세팅한다는것이다.
              child:Column(
                children: [
                  Text("or Singup with"),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                      onPressed: (){},
                      style:TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(155,40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Paltette.googleColor,
                      ),
                     icon: Icon(Icons.add),
                     label: Text("Google"),
                    )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
