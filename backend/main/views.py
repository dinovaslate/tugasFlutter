import json

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from .models import Product


def _get_payload(request):
    if request.content_type == 'application/json':
        try:
            return json.loads(request.body.decode('utf-8'))
        except json.JSONDecodeError:
            return {}
    return request.POST


@csrf_exempt
@require_http_methods(['POST'])
def register_user(request):
    payload = _get_payload(request)
    form = UserCreationForm(payload)
    if form.is_valid():
        user = form.save()
        return JsonResponse(
            {
                'status': 'success',
                'message': 'User registered successfully.',
                'username': user.username,
            },
            status=201,
        )
    return JsonResponse(
        {
            'status': 'error',
            'message': 'Registration failed.',
            'errors': form.errors,
        },
        status=400,
    )


@csrf_exempt
@require_http_methods(['POST'])
def login_user(request):
    payload = _get_payload(request)
    username = payload.get('username')
    password = payload.get('password')

    user = authenticate(request, username=username, password=password)
    if user is None:
        return JsonResponse(
            {'status': 'error', 'message': 'Invalid credentials.'},
            status=401,
        )

    login(request, user)
    return JsonResponse(
        {
            'status': 'success',
            'message': 'Login successful.',
            'username': user.username,
        }
    )


@csrf_exempt
@login_required
@require_http_methods(['POST'])
def logout_user(request):
    logout(request)
    return JsonResponse({'status': 'success', 'message': 'Logged out.'})


@login_required
@require_http_methods(['GET'])
def products_json(request):
    owner_param = request.GET.get('owner')
    products = Product.objects.select_related('owner').all()
    if owner_param == 'me':
        products = products.filter(owner=request.user)

    data = [product.as_dict() for product in products]
    return JsonResponse(data, safe=False)


@login_required
@require_http_methods(['GET'])
def product_detail_json(request, pk: int):
    product = get_object_or_404(Product, pk=pk)
    if product.owner != request.user:
        return JsonResponse({'detail': 'Not found.'}, status=404)
    return JsonResponse(product.as_dict())
