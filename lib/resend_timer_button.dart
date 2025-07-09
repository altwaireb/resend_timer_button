library resend_timer_button;

// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';

/// Enum to control the format of the countdown.
///
/// - `ResendTimeFormat.time`: Displays the countdown in `minutes:seconds` format (e.g. `01:00`).
///   This format is more user-friendly for longer durations.
///
/// - `ResendTimeFormat.number`: Displays the remaining time as a plain number of seconds (e.g. `60`).
///   Useful when you want to show raw values.
///
/// Default is `ResendTimeFormat.time`.
///
/// ### Example:
/// ```dart
/// ResendTimerButton(
///   onPressed: () => print('Resend tapped'),
///   text: Text('Resend in'),
///   duration: 60,
///   format: ResendTimeFormat.time,
/// )
/// ```
enum ResendTimeFormat { time, number }

/// Defines the type of button to use in [ResendTimerButton].
///
/// The default value is [ButtonType.elevated_button].
///
/// - [ButtonType.elevated_button]: Uses [ElevatedButton] — a Material-style filled button with elevation.
///   Commonly used for primary actions.
///
/// - [ButtonType.text_button]: Uses [TextButton] — a flat button with transparent background and no elevation.
///   Suitable for low-priority or inline actions.
///
/// - [ButtonType.outlined_button]: Uses [OutlinedButton] — a button with a border outline and no fill.
///   Typically used for secondary actions.
enum ButtonType { elevated_button, text_button, outlined_button }

/// A customizable button with a built-in countdown timer, typically used
/// in OTP verification or resend email/password flows.
///
/// The button is disabled while the timer runs and reactivates after the countdown.
/// Supports optional loading state and controller-based control.
///
/// ### Example:
/// ```dart
/// ResendTimerButton(
///   onPressed: () => print("Resend tapped"),
///   text: Text("Resend in"),
///   duration: 60,
///   format: ResendTimeFormat.time,
/// )
/// ```
class ResendTimerButton extends StatefulWidget {
  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The button text.
  final Text text;

  /// The loading indicator widget.
  final ProgressIndicator? loadingIndicator;

  /// Duration of the countdown in seconds.
  final int duration;

  /// Optional controller for manually controlling the button state.
  final ResendTimerButtonController? controller;

  /// Height of the button.
  final double? height;

  /// Background color of the button.
  final Color? backgroundColor;

  /// Text color.
  final Color? textColor;

  /// Loading indicator color.
  final Color? loadingIndicatorColor;

  /// The type of button to render.
  ///
  /// Determines whether the button appears as an elevated, text, or outlined button.
  /// Defaults to [ButtonType.elevated_button].
  final ButtonType buttonType;

  /// Border radius for the button.
  final double? radius;

  /// The format in which to show the countdown.
  /// Defaults to [ResendTimeFormat.time].
  final ResendTimeFormat format;

  const ResendTimerButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.duration,
    this.loadingIndicator,
    this.controller,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.loadingIndicatorColor,
    this.buttonType = ButtonType.elevated_button,
    this.radius,
    this.format = ResendTimeFormat.time,
  });

  @override
  State<ResendTimerButton> createState() => _ResendTimerButtonState();
}

enum ButtonState { enable_button, loading, timer }

class _ResendTimerButtonState extends State<ResendTimerButton> {
  Timer? _timer;
  int _counter = 0;
  ButtonState _state = ButtonState.timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    widget.controller?._addListeners(_startTimer, _setLoading, _enableButton);
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration <= 0) {
      setState(() => _state = ButtonState.enable_button);
      return;
    }

    setState(() {
      _state = ButtonState.timer;
      _counter = widget.duration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        timer.cancel();
        setState(() => _state = ButtonState.enable_button);
      } else {
        setState(() => _counter--);
      }
    });
  }

  void _setLoading() => setState(() => _state = ButtonState.loading);

  void _enableButton() => setState(() => _state = ButtonState.enable_button);

  String _formatTime(int seconds) {
    if (widget.format == ResendTimeFormat.number) {
      return seconds.toString();
    }
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Widget _buildChild() {
    switch (_state) {
      case ButtonState.enable_button:
        return widget.text;

      case ButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.text,
            const SizedBox(width: 10),
            SizedBox(
              width: 20,
              height: 20,
              child: widget.loadingIndicator ??
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.loadingIndicatorColor,
                  ),
            ),
          ],
        );

      case ButtonState.timer:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.text,
            const SizedBox(width: 10),
            Text(
              _formatTime(_counter),
              style: widget.text.style,
            ),
          ],
        );
    }
  }

  RoundedRectangleBorder? _roundedBorder() {
    return widget.radius != null
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius!),
          )
        : null;
  }

  void _handlePressed() {
    widget.onPressed?.call();
    if (widget.controller == null) {
      _startTimer();
    }
  }

  ButtonStyleButton _buildButton() {
    final onPressed =
        _state == ButtonState.enable_button ? _handlePressed : null;

    switch (widget.buttonType) {
      case ButtonType.elevated_button:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: widget.textColor,
            backgroundColor: widget.backgroundColor,
            shape: _roundedBorder(),
          ),
          child: _buildChild(),
        );

      case ButtonType.text_button:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: widget.textColor,
            shape: _roundedBorder(),
          ),
          child: _buildChild(),
        );

      case ButtonType.outlined_button:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.textColor,
            shape: _roundedBorder(),
            side: _borderSide(),
          ),
          child: _buildChild(),
        );
    }
  }

  _borderSide() {
    if (widget.textColor != null && _state == ButtonState.enable_button) {
      return const BorderSide().copyWith(color: widget.textColor);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: _buildButton(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Controller to manually manage the [ResendTimerButton]'s internal state.
class ResendTimerButtonController {
  late VoidCallback _startTimerListener;
  late VoidCallback _loadingListener;
  late VoidCallback _enableButtonListener;

  void _addListeners(
    VoidCallback startTimer,
    VoidCallback loading,
    VoidCallback enable,
  ) {
    _startTimerListener = startTimer;
    _loadingListener = loading;
    _enableButtonListener = enable;
  }

  void startTimer() => _startTimerListener();

  void loading() => _loadingListener();

  void enableButton() => _enableButtonListener();
}
