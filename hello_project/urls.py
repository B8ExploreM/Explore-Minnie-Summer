from django.urls import path
from . import views

urlpatterns = [
    path('deploy/', views.index, name='deploy'),
]
