from django.http import JsonResponse

def home(request):
    message = {"message": "Hello world!"}
    return JsonResponse(message)
