from django.test import TestCase
from kompass.finance.models import Statement
from kompass.members.models import Freizeit
from kompass.members.models import Member

from .populate import populate_test_data


class TestDataTestCase(TestCase):
    def test_populate_test_data(self):
        populate_test_data()
        self.assertGreater(Member.objects.all().count(), 10)
        self.assertGreater(Freizeit.objects.all().count(), 1)
        self.assertGreater(Statement.objects.all().count(), 1)
