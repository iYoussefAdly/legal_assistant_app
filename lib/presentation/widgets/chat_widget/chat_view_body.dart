import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/bubble_chat.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/bubble_chat_ai.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/container_chat.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/container_chat_bottom.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/attachment_bottom_sheet.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: media.height * .06, // قللت المسافة العلوية قليلاً لتناسب معظم الشاشات
        bottom: media.height * .02,
        left: media.width * .03,
        right: media.width * .03,
      ),
      child: Column(
        children: [
          // --- Header Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContainerChat(icon: CupertinoIcons.back),
              Container(
                width: media.width * .3,
                height: media.height * .05,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(231, 214, 248, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New Chat', style: AppStyles.styleSemitBold14),
                    SizedBox(width: media.width * .02),
                    const Icon(Icons.keyboard_arrow_down_outlined, size: 30),
                  ],
                ),
              ),
              ContainerChat(icon: Icons.menu),
            ],
          ),

          SizedBox(height: media.height * .03), // بديل الـ spacing

          // --- Date Divider Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  thickness: 2,
                  color: Color.fromRGBO(153, 44, 230, 0.3),
                ),
              ),
              Text('   Dec 15th   ', style: AppStyles.styleSemitBold16),
              Expanded(
                child: Divider(
                  thickness: 2,
                  color: Color.fromRGBO(153, 44, 230, 0.3),
                ),
              ),
            ],
          ),

          SizedBox(height: media.height * .02), // مسافة قبل الشات

          // --- Chat Messages Area (Expanded) ---
          // استخدمنا Expanded هنا ليأخذ المساحة المتبقية بالكامل
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChatBubbleAi(
                    message:
                    'Hello! I’m your Smart Legal Assistant.How can I help you today?',
                    avatarImage: Image.asset('assets/images/bubble.png'),
                  ),
                  SizedBox(height: media.height * .03), // مسافة بين الرسائل
                  ChatBubble(
                    message: ' Can my employer fire me without notice?',
                  ),
                  SizedBox(height: media.height * .03),
                  ChatBubbleAi(
                    message:
                    'In most cases, an employer must provide a notice period unless there is a serious violation stated in the contract.',
                    avatarImage: Image.asset('assets/images/bubble.png'),
                  ),
                  SizedBox(height: media.height * .03),
                  ChatBubble(message: 'Can you give me reference?'),
                  SizedBox(height: media.height * .03),
                  ChatBubbleAi(
                    message: 'Reference:\nLabor Law – Article 75',
                    avatarImage: Image.asset('assets/images/bubble.png'),
                  ),
                  // مسافة صغيرة في نهاية الشات لعدم الالتصاق بصندوق الكتابة
                  SizedBox(height: media.height * .02),
                ],
              ),
            ),
          ),

          // --- Bottom Input Section ---
          ContainerChatBottom(
            height: media.height * .15,
            width: media.width,
            borderRadius: 10,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Message Qanunay Ai....',
                    hintStyle: AppStyles.styleRegular16,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: media.height * .02,
                      horizontal: media.width * .04,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                // مسافة داخل الـ Bottom Container
                SizedBox(height: media.height * .01),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return  AttachmentBottomSheet();
                          },
                        );
                      },
                      child: ContainerChatBottom(
                        height: media.height * .04,
                        width: media.width * .12,
                        borderRadius: 30,
                        child: Icon(Icons.add, size: 25),
                      ),
                    ),
                    GestureDetector(
                      child: ContainerChatBottom(
                        height: media.height * .04,
                        width: media.width * .4,
                        borderRadius: 30,
                        child: Row(
                          children: [
                            Icon(Icons.travel_explore, size: 22),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Type your question',
                                style: AppStyles.styleRegular14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: ContainerChatBottom(
                        height: media.height * .04,
                        width: media.width * .12,
                        borderRadius: 30,
                        child: Icon(Icons.mic, size: 25),
                      ),
                    ),
                    GestureDetector(
                      child: ContainerChatBottom(
                        height: media.height * .05,
                        width: media.width * .1,
                        borderRadius: 30,
                        child: Icon(Icons.arrow_outward_sharp, size: 25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}