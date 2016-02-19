# test_debug.py - Unit tests for swift_build_support.debug -*- python -*-
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import platform
import unittest

# StringIO import path differs across Python 2 and 3.
try:
    from io import StringIO
except ImportError:
    from cStringIO import StringIO

from swift_build_support import debug


class PrintXcodebuildVersionsTestCase(unittest.TestCase):
    def setUp(self):
        if platform.system() != 'Darwin':
            self.skipTest('print_xcodebuild_version() tests should only be '
                          'run on OS X')
        self._out = StringIO()

    def test_outputs_xcode_version(self):
        debug.print_xcodebuild_versions([], file=self._out)
        actual = self._out.getvalue().splitlines()
        self.assertEqual(actual[0], '--- SDK versions ---')
        self.assertTrue(actual[1].startswith('Xcode '))
        self.assertTrue(actual[2].startswith('Build version '))

    def test_outputs_all_sdks(self):
        debug.print_xcodebuild_versions(
            ['iphonesimulator', 'watchsimulator'], file=self._out)
        actual = self._out.getvalue()
        self.assertNotEqual(actual.find('iPhoneSimulator'), -1)
        self.assertNotEqual(actual.find('WatchSimulator'), -1)


if __name__ == '__main__':
    unittest.main()
