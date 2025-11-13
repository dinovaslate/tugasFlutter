import json

from decimal import Decimal, InvalidOperation
from urllib.parse import unquote, urlparse

import requests
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_http_methods

from .models import Product, ProductCategory


def _get_payload(request):
    if request.content_type == 'application/json':
        try:
            return json.loads(request.body.decode('utf-8'))
        except json.JSONDecodeError:
            return {}
    return request.POST


def _to_bool(value):
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        return value.strip().lower() in {'1', 'true', 'yes', 'on'}
    return False


def _normalize_category(value):
    if not value:
        return ProductCategory.OTHER
    normalized = str(value).strip().lower()
    return normalized if normalized in ProductCategory.values else ProductCategory.OTHER


def _parse_product_payload(payload):
    name = (payload.get('name') or '').strip()
    description = (payload.get('description') or '').strip()
    thumbnail = (payload.get('thumbnail') or '').strip()
    category = _normalize_category(payload.get('category'))

    if not name:
        return None, 'Name is required.'
    if not description:
        return None, 'Description is required.'
    if not thumbnail:
        return None, 'Thumbnail URL is required.'

    try:
        price = Decimal(str(payload.get('price')))
    except (InvalidOperation, TypeError):
        return None, 'Price must be a valid number.'

    if price <= 0:
        return None, 'Price must be greater than zero.'

    return (
        {
            'name': name,
            'price': price,
            'description': description,
            'category': category,
            'thumbnail': thumbnail,
            'is_featured': _to_bool(payload.get('is_featured')),
        },
        None,
    )


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
    elif owner_param:
        products = products.filter(owner__username__iexact=owner_param)

    data = [product.as_dict() for product in products]
    return JsonResponse(data, safe=False)


@login_required
@require_http_methods(['GET'])
def product_detail_json(request, pk: int):
    product = get_object_or_404(Product, pk=pk)
    if product.owner != request.user:
        return JsonResponse({'detail': 'Not found.'}, status=404)
    return JsonResponse(product.as_dict())


@csrf_exempt
@login_required
@require_http_methods(['POST'])
def create_product(request):
    payload = _get_payload(request)
    cleaned, error = _parse_product_payload(payload)
    if error:
        return JsonResponse({'status': 'error', 'message': error}, status=400)

    product = Product.objects.create(owner=request.user, **cleaned)

    return JsonResponse(
        {
            'status': 'success',
            'message': 'Product created.',
            'product': product.as_dict(),
        },
        status=201,
    )


@csrf_exempt
@login_required
@require_http_methods(['POST'])
def update_product(request, pk: int):
    product = get_object_or_404(Product, pk=pk, owner=request.user)
    payload = _get_payload(request)
    cleaned, error = _parse_product_payload(payload)

    if error:
        return JsonResponse({'status': 'error', 'message': error}, status=400)

    for field, value in cleaned.items():
        setattr(product, field, value)
    product.save()

    return JsonResponse(
        {
            'status': 'success',
            'message': 'Product updated.',
            'product': product.as_dict(),
        }
    )


@csrf_exempt
@login_required
@require_http_methods(['POST'])
def delete_product(request, pk: int):
    product = get_object_or_404(Product, pk=pk, owner=request.user)
    product.delete()
    return JsonResponse({'status': 'success', 'message': 'Product deleted.'})


@require_GET
def proxy_image(request):
    raw_url = request.GET.get('url')
    if not raw_url:
        return JsonResponse({'detail': 'Missing url parameter.'}, status=400)

    decoded_url = unquote(raw_url)
    parsed = urlparse(decoded_url)
    if parsed.scheme not in {'http', 'https'}:
        return JsonResponse({'detail': 'Unsupported URL scheme.'}, status=400)

    try:
        response = requests.get(decoded_url, timeout=10)
    except requests.RequestException:
        return JsonResponse({'detail': 'Failed to fetch remote image.'}, status=502)

    content_type = response.headers.get('Content-Type', 'application/octet-stream')
    return HttpResponse(response.content, content_type=content_type)
