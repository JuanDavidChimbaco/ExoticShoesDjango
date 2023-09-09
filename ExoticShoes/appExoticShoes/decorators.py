from django.shortcuts import redirect, render
from rest_framework import status


def admin_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if (
                request.user.groups.filter(name="admin").exists()
                or request.user.is_staff
            ):
                return view_func(request, *args, **kwargs)
            else:
                mensaje = "No tienes permisos para acceder a esta página."
                return render(
                    request,
                    "error_page/unauthorized.html",
                    {"auth_messaje": mensaje},
                    status=status.HTTP_403_FORBIDDEN,
                )
        return redirect("login")

    return _wrapped_view


def client_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.groups.filter(name="cliente").exists():
                return view_func(request, *args, **kwargs)
            else:
                return view_func(request, *args, **kwargs)
        return request({"auth_messaje": "No estas Autenticado"})

    return _wrapped_view
