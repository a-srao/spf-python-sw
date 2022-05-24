"""Test case for the HELLO IFX"""
import sys, os.path
from unittest import TestCase

from unittest.mock import Mock, call, patch, MagicMock

dut_path = os.path.realpath("{}/../../src/module".format(os.path.dirname(__file__)))
if dut_path not in sys.path:
    sys.path.insert(0, dut_path)


import hello_ifx

class test_2(TestCase):
    """Test case for the HELLO IFX"""

    def setup_method(self, method):
        return True

    def teardown_method(self, method):
        return True

    @patch('hello_ifx.print')
    def test_main_calls_all_steps_with_correct_params(self, mock_print):
        hello_ifx.main()
        mock_print.assert_called_once_with("Hello IFX!")
