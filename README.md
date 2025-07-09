# resend_timer_button

[![Pub Version](https://img.shields.io/pub/v/resend_timer_button.svg)](https://pub.dev/packages/resend_timer_button)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Flutter](https://img.shields.io/badge/flutter-ready-blue)](https://flutter.dev)
[![Likes](https://badges.bar/resend_timer_button/likes)](https://pub.dev/packages/resend_timer_button/score)
[![Pub Points](https://badges.bar/resend_timer_button/pub%20points)](https://pub.dev/packages/resend_timer_button/score)
[![Popularity](https://badges.bar/resend_timer_button/popularity)](https://pub.dev/packages/resend_timer_button/score)

A customizable Flutter button widget with a built-in countdown timer. Commonly used in OTP, verification, or password reset flows where users need to wait before resending a code or performing an action again.

---

## ✨ Features

- Countdown timer with two formats: `mm:ss` or raw seconds
- Three button styles: Elevated, Text, Outlined
- Custom loading state with optional controller
- Easy integration with GetX, BLoC, or plain Flutter

---

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  resend_timer_button: ^1.0.0
```

Install it You can install packages from the command line:
   with Flutter:

```
  flutter pub get
```

---

## 🔧 Usage
**Basic Example**

```dart
import 'package:resend_timer_button/resend_timer_button.dart';

ResendTimerButton(
onPressed: () {
// trigger resend logic here
},
text: const Text("Resend in"),
duration: 60, // in seconds
)
```

**With Countdown Format**

```dart
ResendTimerButton(
  onPressed: () => print("Tapped"),
  text: const Text("Resend in"),
  duration: 60,
  format: ResendTimeFormat.time, // or ResendTimeFormat.number
)
```

**With Controller**

```dart
final controller = ResendTimerButtonController();

ResendTimerButton(
  controller: controller,
  onPressed: () async {
    controller.loading();
    await Future.delayed(Duration(seconds: 2));
    controller.startTimer();
  },
  text: Text("Resend"),
  duration: 120,
)

```

## 📱 Demo

![Demo](https://raw.githubusercontent.com/altwaireb/resend_timer_button/main/example/demo.gif)

---

## 🎨 Parameters
| Property                | Type                           | Description                              |
| ----------------------- | ------------------------------ | ---------------------------------------- |
| `onPressed`             | `VoidCallback?`                | Called when the button is tapped         |
| `text`                  | `Text`                         | Text widget to show                      |
| `duration`              | `int`                          | Countdown duration in seconds            |
| `format`                | `ResendTimeFormat`             | `time` (`mm:ss`) or `number` (seconds)   |
| `buttonType`            | `ButtonType`                   | Elevated, Text, or Outlined button style |
| `controller`            | `ResendTimerButtonController?` | Optional external controller             |
| `loadingIndicator`      | `ProgressIndicator?`           | Custom loading indicator                 |
| `textColor`             | `Color?`                       | Color of the text                        |
| `backgroundColor`       | `Color?`                       | Button background color                  |
| `loadingIndicatorColor` | `Color?`                       | Color of loading spinner                 |
| `radius`                | `double?`                      | Border radius                            |
| `height`                | `double?`                      | Height of the button                     |


---

## 🛠 Maintainer

Maintained by **[Abdulmajeed Altwaireb](https://github.com/altwaireb)**  
Feel free to [open an issue](https://github.com/altwaireb/resend_timer_button/issues) or [submit a pull request](https://github.com/altwaireb/resend_timer_button/pulls).

---

## 🤝 Contributing

Contributions are welcome and appreciated!  
Please open issues for bugs, suggestions, or enhancements.  
Pull requests should follow [Flutter's style guide](https://dart.dev/guides/language/effective-dart/style).

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).







