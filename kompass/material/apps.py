from django.apps import AppConfig
from django.utils.translation import gettext_lazy as _


class MaterialConfig(AppConfig):
    name = "kompass.material"
    verbose_name = _("material")
