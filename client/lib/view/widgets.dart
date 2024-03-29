/// Description: File containing some building-block widgets to be adapted
/// throughout the program.
/// Author: Jordan Bourdeau
/// Date: 11/15/23

import 'package:flutter/material.dart';

class PaddedText extends StatelessWidget {
  final String text;
  final bool bold;

  PaddedText({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

/// Widget for common pattern of <Text> <Dollar amount>
class LeftRightJustifyTextWidget extends StatelessWidget {
  final String left;
  final String right;

  LeftRightJustifyTextWidget({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, textAlign: TextAlign.left),
          Text(right, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}

/// Widget for common pattern of <Left justified text> <Right justified text>
class TextAmountWidget extends StatelessWidget {
  final String text;
  final int amount;

  TextAmountWidget({required this.text, required this.amount});

  @override
  Widget build(BuildContext context) {
    return LeftRightJustifyTextWidget(left: text, right: '\$$amount');
  }
}

class SpacerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.black, // You can customize the color as needed
      margin:
          EdgeInsets.symmetric(vertical: 8), // Adjust vertical margin as needed
    );
  }
}

/// Widget which provides a "tooltray" to house many other widgets/buttons.
///
/// [children] are the list of widgets which are contained in the tooltray.
class ExpandableTooltray extends StatefulWidget {
  final CrossAxisAlignment crossAlignment;
  final MainAxisAlignment mainAlignment;
  final List<Widget> children;

  ExpandableTooltray(
      {required this.children,
      this.crossAlignment = CrossAxisAlignment.end,
      this.mainAlignment = MainAxisAlignment.end});

  @override
  _ExpandableTooltrayState createState() => _ExpandableTooltrayState();
}

class _ExpandableTooltrayState extends State<ExpandableTooltray> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
              ),
            ],
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? null : 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.children
                .map((child) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: child,
                    ))
                .toList(),
          ),
        ),
        IconButton(
          icon: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
      ],
    );
  }
}

/// Widget for getting text value inputs.
///
/// Given [buttonText] and [onPressed] the widget will display the submit
/// button text and execute some closure when pressed.
class TextInputWidget extends StatefulWidget {
  final double width;
  final String labelText;
  final String buttonText;
  final Color labelTextColor;
  final bool center;
  final Function(String) onPressed;

  TextInputWidget(
      {required this.width,
      required this.labelText,
      required this.buttonText,
      required this.onPressed,
      required this.labelTextColor,
      this.center = true});

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController _textController = TextEditingController();

  void _onPressed() {
    // Call the provided onPressed closure with the current text value
    widget.onPressed(_textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(color: widget.labelTextColor)),
             style: TextStyle(color: widget.labelTextColor),   
          ),
          const SizedBox(height: 20),
          widget.center
              ? Center(
                  child: ElevatedButton(
                    onPressed: _onPressed,
                    child: Text(widget.buttonText),
                  ),
                )
              : ElevatedButton(
                  onPressed: _onPressed,
                  child: Text(widget.buttonText),
                )
        ],
      ),
    );
  }
}

/// Widget for getting integer value inputs.
///
/// Given [buttonText] and [onPressed] the widget will display the submit
/// button text and execute some closure when pressed.
class NumberInputWidget extends StatefulWidget {
  final String buttonText;
  final Function(int) onPressed;

  NumberInputWidget({required this.buttonText, required this.onPressed});

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  int inputValue = 0;

  void _increment() {
    setState(() {
      inputValue++;
    });
  }

  void _decrement() {
    setState(() {
      inputValue--;
    });
  }

  void _onPressed() {
    // Call the provided onPressed closure with the current integer value (inputValue)
    widget.onPressed(inputValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decrement,
            ),
            Text(
              '$inputValue',
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increment,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onPressed,
          child: Text(widget.buttonText),
        ),
      ],
    );
  }
}

/// Widget for providing multiple options in a dropdown menu.
///
/// Given [defaultText] for the default dropdown option,
/// [options] for the list of key/value pairs,
/// and [onPressed] for the closure to execute when pressed,
/// the widget passes along the value associated with a label to the closure.
class MultiOptionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final Function(dynamic) onPressed;
  final String defaultText;

  MultiOptionWidget({
    required this.options,
    required this.onPressed,
    this.defaultText = 'Select Option',
  });

  @override
  _MultiOptionWidgetState createState() => _MultiOptionWidgetState();
}

class _MultiOptionWidgetState extends State<MultiOptionWidget> {
  dynamic selectedOption;

  @override
  Widget build(BuildContext context) {
    // Adding a default option with text "Select Option" and value null
    List<DropdownMenuItem<dynamic>> dropdownItems = [
      DropdownMenuItem<dynamic>(
        value: null,
        child: Text(widget.defaultText),
      ),
      ...widget.options.map((option) {
        return DropdownMenuItem<dynamic>(
          value: option['value'],
          child: Text(option['text'].toString()),
        );
      }),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<dynamic>(
          value: selectedOption,
          onChanged: (dynamic value) {
            setState(() {
              selectedOption = value;
            });
          },
          items: dropdownItems,
        ),
        ElevatedButton(
          onPressed: () {
            // Call the provided onPressed closure with the selected option
            widget.onPressed(selectedOption);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
