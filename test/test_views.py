# -*- coding: utf-8 -*-

import unittest
from hello_world import app
from hello_world.formater import SUPPORTED


class FlaskrTestCase(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        self.app = app.test_client()

    def test_outputs(self):
        rv = self.app.get('/outputs')
        ','.join(SUPPORTED) in rv.data

    def test_msg_with_output(self):
        rv = self.app.get('/?output=json')
        expected = '{ "imie":"Wojtek", "mgs":"jesteś zajebisty! :)"}'
        self.assertEquals(expected, rv.data)
