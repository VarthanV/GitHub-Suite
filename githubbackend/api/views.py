from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from . models import *
from django.core.exceptions import SuspiciousOperation
from django.shortcuts import get_object_or_404


class AuthView(APIView):
    permission_classes = (AllowAny,)
    def post(self, request):

        user, create = GitHubUser.objects.get_or_create(
            name=request.POST.get('username'),
            token=request.POST.get('token'),
            profile_pic_url=request.POST.get('url')
        )
        user.save()
        return Response({'registered': True})


class IssueGetView(APIView):
    def get(self, request):
        token = request.META.get('token')
        user = get_object_or_404(GitHubUser, token=token)
        return Response([

            {
            
            }


            for issue in user.issues.all()])
