import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/model/feedback.dart';
import 'package:wwjd_chat/screens/feedback/feedback_detail.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:wwjd_chat/components/user_avatar.dart';

class FeedbackListView extends StatelessWidget {
  final List<FeedbackModel> feedbackList;

  const FeedbackListView({super.key, required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5))),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FeedBackDetail(
                        feedbackModel: feedbackList[index]),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UserAvatar(userName: feedbackList[index].user),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        feedbackList[index].user,
                                        maxLines: 1,
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      "${feedbackList[index].datetime}",
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  feedbackList[index].comment,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  GoogleFonts.roboto(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Container(color: Colors.grey.shade200,height: 1,),
                    ],
                  ),
                ),
              );
            },
          ),
          );
  }

//generate data row
// DataRow _getDataRow(FeedbackModel feedback, int index) {
//   return DataRow(cells: <DataCell>[
//     DataCell(Text(index.toString())),
//     DataCell(Text(feedback.user)),
//     DataCell(Text(feedback.comment)),
//     DataCell(Text(feedback.datetime)),
//   ]);
// }
}
