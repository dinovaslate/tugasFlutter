from django.contrib.auth.models import User
from django.db import models


class ProductCategory(models.TextChoices):
    JERSEY = 'jersey', 'Jersey'
    BOOTS = 'boots', 'Boots'
    BALL = 'ball', 'Ball'
    ACCESSORY = 'accessory', 'Accessory'
    OTHER = 'other', 'Other'


class Product(models.Model):
    owner = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='products',
    )
    name = models.CharField(max_length=120)
    price = models.DecimalField(max_digits=12, decimal_places=2)
    description = models.TextField()
    category = models.CharField(
        max_length=32,
        choices=ProductCategory.choices,
        default=ProductCategory.OTHER,
    )
    thumbnail = models.URLField()
    is_featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return f'{self.name} ({self.owner.username})'

    def as_dict(self) -> dict:
        return {
            'id': self.pk,
            'owner_username': self.owner.username,
            'name': self.name,
            'price': float(self.price),
            'description': self.description,
            'category': self.category,
            'category_label': self.get_category_display(),
            'thumbnail': self.thumbnail,
            'is_featured': self.is_featured,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat(),
        }
