# Generated by Django 4.2.3 on 2023-08-28 14:51

from django.conf import settings
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('appExoticShoes', '0010_alter_productos_categoria'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Categorias',
            new_name='Categoria',
        ),
        migrations.RenameModel(
            old_name='Productos',
            new_name='Producto',
        ),
        migrations.RenameModel(
            old_name='Usuarios',
            new_name='Usuario',
        ),
    ]