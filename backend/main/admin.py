from django.contrib import admin

from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'owner', 'category', 'price', 'is_featured')
    list_filter = ('category', 'is_featured')
    search_fields = ('name', 'owner__username')
