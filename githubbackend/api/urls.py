from django.urls import path
from . import views
urlpatterns = [
    path('auth/',views.AuthView.as_view()),
    path('issues/',views.IssueGetView.as_view())
    
]
