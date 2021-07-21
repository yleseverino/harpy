import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/misc/misc.dart';

void main() {
  test('prettyPrintDurationDifference pretty prints a duration difference', () {
    const timestamp = 1557836948;

    final now = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );

    final rateLimitReset1 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 330) * 1000,
    );

    final rateLimitReset2 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 25) * 1000,
    );

    final rateLimitReset3 = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + 304) * 1000,
    );

    final difference1 = rateLimitReset1.difference(now);
    final difference2 = rateLimitReset2.difference(now);
    final difference3 = rateLimitReset3.difference(now);

    expect(prettyPrintDurationDifference(difference1), '5:30 minutes');

    expect(prettyPrintDurationDifference(difference2), '25 seconds');

    expect(prettyPrintDurationDifference(difference3), '5:04 minutes');
  });

  test('prettyPrintDuration pretty prints a duration', () {
    const duration1 = Duration(minutes: 1, seconds: 9);

    const duration2 = Duration(minutes: 4, seconds: 20);

    const duration3 = Duration(hours: 1, minutes: 6, seconds: 9);

    expect(prettyPrintDuration(duration1), '1:09');
    expect(prettyPrintDuration(duration2), '4:20');
    expect(prettyPrintDuration(duration3), '66:09');
  });

  group('parseHtmlEntities', () {
    test('parses entities as they appear in twitter text responses', () {
      const source = '&lt;body&gt;Hello world &amp;&lt;/body&gt;';

      expect(parseHtmlEntities(source), '<body>Hello world &</body>');
    });

    test('does nothing when the source does not contain any entities', () {
      const source = 'This is just a regular string';

      expect(parseHtmlEntities(source), 'This is just a regular string');
    });
  });

  group('trimOne', () {
    test('trims the first and last whitespace of a string', () {
      const source = '  Hello World   \n';

      expect(trimOne(source), ' Hello World   ');
    });

    test('trims the first whitespace of a string', () {
      const source = '  Hello World   \n';

      expect(trimOne(source, end: false), ' Hello World   \n');
    });

    test('trims the last whitespace of a string', () {
      const source = '  Hello World   \n';

      expect(trimOne(source, start: false), '  Hello World   ');
    });

    test('returns the string if it has no starting or ending whitespace', () {
      const source = 'Hello World';

      expect(trimOne(source), 'Hello World');
    });

    test('returns null if the source is null', () {
      String? source;

      expect(trimOne(source), null);
    });
  });

  group('fileNameFromUrl', () {
    test('returns the file name from a url', () {
      const url =
          'https://video.twimg.com/ext_tw_video/1322182514157346818/pu/vid/1280x720/VoCc7t0UyB_R-KvW.mp4';

      expect(fileNameFromUrl(url), equals('VoCc7t0UyB_R-KvW.mp4'));
    });

    test('removes query params', () {
      const url =
          'https://video.twimg.com/ext_tw_video/1322182514157346818/pu/vid/1280x720/VoCc7t0UyB_R-KvW.mp4?tag=10';

      expect(fileNameFromUrl(url), equals('VoCc7t0UyB_R-KvW.mp4'));
    });

    test('returns the url if its just the file name', () {
      const url = 'VoCc7t0UyB_R-KvW.mp4';

      expect(fileNameFromUrl(url), equals('VoCc7t0UyB_R-KvW.mp4'));
    });

    test('returns null when the url is null', () {
      expect(fileNameFromUrl(null), isNull);
    });
  });

  group('prependIfMissing', () {
    test('prepends the symbol if the value does not start with it', () {
      expect(
        prependIfMissing('hashtag', '#', <String>['#', '＃']),
        equals('#hashtag'),
      );
    });

    test('does nothing if the value starts with one of the symbols', () {
      expect(
        prependIfMissing('#hashtag', '#', <String>['#', '＃']),
        equals('#hashtag'),
      );
      expect(
        prependIfMissing('＃hashtag', '#', <String>['#', '＃']),
        equals('＃hashtag'),
      );
    });

    test('returns null if value is null', () {
      expect(prependIfMissing(null, '@', <String>['@']), isNull);
    });

    test('returns empty string if value is empty', () {
      expect(prependIfMissing('', '@', <String>['@']), equals(''));
    });

    test('returns null if value only starts with one of the symbols', () {
      expect(prependIfMissing('@', '@', <String>['@']), isNull);

      expect(prependIfMissing('＃', '#', <String>['#', '＃']), isNull);
    });
  });

  group('removePrependedSymbol', () {
    test('removes the prepended symbol if value starts with it', () {
      expect(
        removePrependedSymbol('#hashtag', <String>['#', '＃']),
        equals('hashtag'),
      );

      expect(
        removePrependedSymbol('_longSymbol_value', <String>['_longSymbol_']),
        equals('value'),
      );
    });

    test('returns null if value is null', () {
      expect(removePrependedSymbol(null, <String>['#', '＃']), isNull);
    });
  });

  group('colorValueToHex', () {
    test('displays the color value without transparency', () {
      expect(
        colorValueToHex(0xffff0000, displayOpacity: false),
        equals('#ff0000'),
      );
      expect(
        colorValueToHex(0xff000000, displayOpacity: false),
        equals('#000000'),
      );
      expect(
        colorValueToHex(0x00c0ffee, displayOpacity: false),
        equals('#c0ffee'),
      );
      expect(
        colorValueToHex(0xffc0ffee, displayOpacity: false),
        equals('#c0ffee'),
      );
    });

    test('displays the color value with transparency', () {
      expect(colorValueToHex(0xffff0000), equals('#ff0000 \u00b7 100%'));
      expect(colorValueToHex(0xaaff00ff), equals('#ff00ff \u00b7 66%'));
      expect(colorValueToHex(0xff000000), equals('#000000 \u00b7 100%'));
      expect(colorValueToHex(0x00c0ffee), equals('transparent'));
      expect(colorValueToHex(0xffc0ffee), equals('#c0ffee \u00b7 100%'));
    });

    test('displays an invalid color value', () {
      expect(
        colorValueToHex(0xaabbccddeeff, displayOpacity: false),
        equals('#ddeeff'),
      );
      expect(
        colorValueToHex(0, displayOpacity: false),
        equals('#000000'),
      );
      expect(
        colorValueToHex(0xa, displayOpacity: false),
        equals('#00000a'),
      );
    });
  });
}
