import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Function()? onTap;

  const MyButton({super.key,required this.onTap, required bool isLoading, required String text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin:const  EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color:  Color.fromARGB(255, 236, 70, 20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Sing In",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
            
            ),
            ),
      
      ),
    );
  }
}





// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   final VoidCallback? onTap;
//   final bool isLoading;
//   final String text;

//   const MyButton({
//     super.key,
//     required this.onTap,
//     required this.isLoading,
//     required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         padding: const EdgeInsets.all(25),
//         margin: const EdgeInsets.symmetric(horizontal: 25),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : Text(
//                   text,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }