import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/exercise.dart';
import '../game/save.dart';
import '../theme.dart';

void openExercise(BuildContext context, Exercise e) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext ctx) => WorkoutScreen(exercise: e),
    ),
  );
}

void openChallenge(BuildContext context, Challenge c) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext ctx) => WorkoutScreen(
        exercise: c.exercise,
        goal: c.goal,
        timeLimit: c.timeLimit,
        challengeId: c.id,
        title: c.title,
      ),
    ),
  );
}

/// شاشة التمرين: عدّاد تكرارات أو مؤقت (البلانك) مع إيقاف مؤقت وحدّ زمني اختياري.
class WorkoutScreen extends StatefulWidget {
  WorkoutScreen({
    super.key,
    required this.exercise,
    int? goal,
    this.timeLimit,
    this.challengeId,
    String? title,
  })  : goal = goal ?? exercise.goal,
        title = title ?? exercise.title;

  final Exercise exercise;
  final int goal;
  final int? timeLimit;
  final String? challengeId;
  final String title;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Timer? _timer;
  int _reps = 0;
  int _seconds = 0;
  bool _started = false;
  bool _running = false;
  bool _finished = false;
  bool _success = false;
  bool _committed = false;

  bool get _isTime => widget.exercise.type == ExerciseType.time;

  String _fmt(int s) {
    final String m = (s ~/ 60).toString().padLeft(2, '0');
    final String r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  // ---------- التحكم ----------

  void _start() {
    setState(() {
      _started = true;
      _running = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted || !_running || _finished) {
        return;
      }
      setState(() {
        _seconds++;
      });
      _checkEnd();
    });
  }

  void _togglePause() {
    if (!_started || _finished) {
      return;
    }
    setState(() {
      _running = !_running;
    });
  }

  void _tap() {
    if (!_running || _finished || _isTime) {
      return;
    }
    setState(() {
      _reps++;
    });
    HapticFeedback.lightImpact();
    if (_reps >= widget.goal) {
      _finish(true);
    }
  }

  void _checkEnd() {
    if (_finished) {
      return;
    }
    if (_isTime && _seconds >= widget.goal) {
      _finish(true);
    } else if (widget.timeLimit != null && _seconds >= widget.timeLimit!) {
      _finish(false);
    }
  }

  void _finish(bool success) {
    if (_finished) {
      return;
    }
    _timer?.cancel();
    _commit(success);
    HapticFeedback.heavyImpact();
    setState(() {
      _running = false;
      _finished = true;
      _success = success;
    });
  }

  /// يحفظ الجلسة مرة واحدة فقط (حتى لو أُكملت ثم خرج المستخدم).
  void _commit(bool completed) {
    if (_committed) {
      return;
    }
    _committed = true;
    Save.instance.addSession(
      reps: _isTime ? 0 : _reps,
      seconds: _seconds,
      challengeId: widget.challengeId,
      completed: completed,
    );
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _reps = 0;
      _seconds = 0;
      _started = false;
      _running = false;
      _finished = false;
      _success = false;
      _committed = false;
    });
  }

  void _exit() {
    _timer?.cancel();
    _commit(false);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // الخروج بزر الرجوع: نحفظ ما أُنجز دون تحديث الواجهة أثناء الإغلاق.
    if (!_committed) {
      _committed = true;
      final int reps = _isTime ? 0 : _reps;
      final int seconds = _seconds;
      final String? id = widget.challengeId;
      Future<void>.microtask(() {
        Save.instance.addSession(reps: reps, seconds: seconds, challengeId: id);
      });
    }
    super.dispose();
  }

  // ---------- الواجهة ----------

  Widget _bigButton() {
    IconData icon;
    String label;
    VoidCallback? onTap;
    Color c1 = kPrimary;
    Color c2 = const Color(0xFFCC5500);

    if (_finished) {
      icon = Icons.check;
      label = '';
      onTap = null;
      c1 = kSuccess;
      c2 = const Color(0xFF1E8449);
    } else if (!_started) {
      icon = Icons.play_arrow;
      label = 'ابدأ';
      onTap = _start;
    } else if (!_running) {
      icon = Icons.play_arrow;
      label = 'متابعة';
      onTap = _togglePause;
    } else if (_isTime) {
      icon = Icons.pause;
      label = 'إيقاف مؤقت';
      onTap = _togglePause;
    } else {
      icon = Icons.add;
      label = 'تكرار';
      onTap = _tap;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[c1, c2]),
          border: Border.all(color: const Color(0x1AFFFFFF), width: 8),
          boxShadow: <BoxShadow>[
            BoxShadow(color: c1.withOpacity(0.4), blurRadius: 30),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 56, color: Colors.white),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _finishedPanel() {
    final String summary = _isTime
        ? 'الوقت: ${_fmt(_seconds)}'
        : 'التكرارات: $_reps  •  الوقت: ${_fmt(_seconds)}';
    return Column(
      children: <Widget>[
        Text(
          _success ? '🎉 أحسنت! أكملت الهدف' : '⏱️ انتهى الوقت',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(summary, style: kSub),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(onPressed: _reset, child: const Text('إعادة')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: _exit, child: const Text('تم')),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int done = _isTime ? _seconds : _reps;
    final double progress = (done / widget.goal).clamp(0.0, 1.0).toDouble();

    String timerText;
    if (widget.timeLimit != null) {
      final int left = (widget.timeLimit! - _seconds).clamp(0, widget.timeLimit!).toInt();
      timerText = _fmt(left);
    } else {
      timerText = _fmt(_seconds);
    }

    String helper = '';
    if (!_finished) {
      if (!_started) {
        helper = 'اضغط للبدء';
      } else if (!_running) {
        helper = 'متوقف مؤقتاً';
      } else {
        helper = _isTime ? 'حافظ على وضعيتك' : 'اضغط عند كل تكرار';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _exit,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('خروج'),
                  ),
                  Text(
                    widget.timeLimit != null ? '⏳ $timerText' : timerText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kSecondary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(widget.exercise.hint, textAlign: TextAlign.center, style: kSub),
                        const SizedBox(height: 8),
                        Text(
                          '$done',
                          style: const TextStyle(
                            fontSize: 84,
                            fontWeight: FontWeight.w900,
                            color: kPrimary,
                            shadows: <Shadow>[Shadow(color: Color(0x80FF6B00), blurRadius: 20)],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            color: kSecondary,
                            backgroundColor: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'الهدف: ${widget.goal} ${_isTime ? 'ثانية' : 'تكرار'}',
                          style: kSub,
                        ),
                        const SizedBox(height: 24),
                        _bigButton(),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 20,
                          child: Text(helper, style: kSub),
                        ),
                        if (_started && _running && !_isTime && !_finished)
                          TextButton.icon(
                            onPressed: _togglePause,
                            icon: const Icon(Icons.pause, size: 18),
                            label: const Text('إيقاف مؤقت'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_finished) _finishedPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
