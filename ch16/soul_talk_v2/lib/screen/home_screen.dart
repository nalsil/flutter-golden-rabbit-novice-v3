import 'package:flutter/material.dart';
import 'package:soul_talk_v2/component/logo.dart';
import 'package:soul_talk_v2/model/message_model.dart';
import 'package:soul_talk_v2/component/message.dart';
import 'package:soul_talk_v2/component/date_divider.dart';
import 'package:soul_talk_v2/component/chat_text_field.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:isar/isar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: "오늘 저녁으로 먹을 만한 메뉴 추천해줘!",
    point: 1,
    date: DateTime(2025, 11, 23),
  ),
  MessageModel(
    id: 2,
    isMine: false,
    message: "칼칼한 김치찜은 어때요!?",
    point: null,
    date: DateTime(2025, 11, 23),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  final ScrollController scrollController = ScrollController();

  bool isRunning = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: GetIt.I.get<Isar>().messageModels.where().watch(
                  fireImmediately: true,
                ),
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];

                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) async => scrollToBottom(),
                  );

                  return buildMessageList(messages);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 32.0,
              ),
              child: ChatTextField(
                error: error,
                loading: isRunning,
                onSend: handleSendMessage,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  handleSendMessage() async {
    if (controller.text.isEmpty) {
      setState(() {
        error = '메시지를 입력해주세요.';
      });
      return;
    }

    int? currentModelMessageId;
    int? currentUserMessageId;

    final isar = GetIt.I.get<Isar>();
    final currentPrompt = controller.text;

    try {
      setState(() {
        isRunning = true;
      });
      controller.clear();

      final myMessageCount = await isar.messageModels
          .filter()
          .isMineEqualTo(true)
          .count();

      currentUserMessageId = await isar.writeTxn(() async {
        return await isar.messageModels.put(
          MessageModel(
            id: myMessageCount + 1,
            isMine: true,
            message: currentPrompt,
            point: myMessageCount + 1,
            date: DateTime.now(),
          ),
        );
      });

      final contextMessages = await isar.messageModels
          .where()
          .limit(5)
          .findAll();

      final List<Content> promptContext = contextMessages
          .map(
            (e) =>
                Content(e.isMine! ? 'user' : 'model', [TextPart(e.message!)]),
          )
          .toList();

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: dotenv.env['GEMINI_API_KEY']!,
        systemInstruction: Content.system(
          '너는 이제부터 착하고 친절한 친구의 역할을 할 거야. 앞으로 채팅을 하면서 긍정적인 말만 할 수 있도록 해줘.',
        ),
      );

      String message = '';
      model
          .generateContentStream(promptContext)
          .listen(
            (event) async {
              if (event.text != null) {
                message += event.text!;
              }

              final MessageModel model = MessageModel(
                isMine: false,
                message: message,
                date: DateTime.now(),
                point: null,
              );

              if (currentModelMessageId != null) {
                model.id = currentModelMessageId!;
              }

              currentModelMessageId = await isar.writeTxn<int>(
                () => isar.messageModels.put(model),
              );
            },

            onDone: () => setState(() {
              isRunning = false;
            }),

            onError: (e) async {
              await isar.writeTxn(() async {
                return isar.messageModels.delete(currentUserMessageId!);
              });
              setState(() {
                error = e.toString();
                isRunning = false;
              });
            },
          );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) => index == 0
          ? buildLogo()
          : buildMessageItem(
              message: messages[index - 1],
              prevMessage: index > 1 ? sampleData[index - 2] : null,
              index: index - 1,
            ),
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
      itemCount: messages.length + 1,
    );
  }

  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Logo(),
      ),
    );
  }

  Widget buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final isMine = message.isMine;
    final shouldDrawDateDivider =
        prevMessage == null || shouldDrawDate(prevMessage.date!, message.date!);

    return Column(
      children: [
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DateDivider(date: message.date),
          ),

        Padding(
          padding: EdgeInsets.only(
            left: isMine ? 64.0 : 16.0,
            right: isMine ? 16.0 : 64.0,
          ),
          child: Message(
            alignLeft: !isMine,
            message: message.message.trim(),
            point: message.point,
          ),
        ),
      ],
    );
  }

  bool shouldDrawDate(DateTime date1, DateTime date2) {
    return getString(date1) != getString(date2);
  }

  String getString(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
