from django.urls import path

from . import views

app_name = 'main'

urlpatterns = [
    path('auth/login/', views.login_user, name='login'),
    path('auth/logout/', views.logout_user, name='logout'),
    path('auth/register/', views.register_user, name='register'),
    path('products/json/', views.products_json, name='products_json'),
    path('products/create/', views.create_product, name='create_product'),
    path('products/<int:pk>/update/', views.update_product, name='update_product'),
    path('products/<int:pk>/delete/', views.delete_product, name='delete_product'),
    path('products/<int:pk>/json/', views.product_detail_json, name='product_detail_json'),
    path('utils/image-proxy/', views.proxy_image, name='proxy_image'),
]
