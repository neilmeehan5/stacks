# Generated by Django 5.0.1 on 2024-01-31 17:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('engine_api', '0002_alter_books_isbn13'),
    ]

    operations = [
        migrations.AlterField(
            model_name='books',
            name='isbn',
            field=models.BigIntegerField(null=True),
        ),
    ]