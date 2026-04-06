import 'package:flutter/material.dart';

class RegisterInput extends StatefulWidget {
  final Function(String) onSubmit;
  final bool isLoading;

  const RegisterInput({
    Key? key,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<RegisterInput> createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Register Number',
            hintText: 'e.g. 21UR001',
            prefixIcon: Icon(Icons.person_outline),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: widget.isLoading
              ? null
              : () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    widget.onSubmit(text);
                  }
                },
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Check Attendance'),
        ),
      ],
    );
  }
}
