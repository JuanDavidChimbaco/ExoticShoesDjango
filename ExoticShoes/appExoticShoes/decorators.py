from django.shortcuts import redirect, render


def admin_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.groups.filter(name='admin').exists():
                return view_func(request, *args, **kwargs)
            else:
                mensaje = "No tienes permisos para acceder a esta página."
                return render(request, "pageError/ErrorPage.html", {'mensaje':mensaje})
        return redirect("login")
    return _wrapped_view

def client_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.groups.filter(name='cliente''admin').exists():
                return view_func(request, *args, **kwargs)
            else:
                mensaje = "No tienes permisos para acceder a esta página."
                return render(request, "pageError/ErrorPage.html", {'mensaje':mensaje})
        return request({'mensaje': "No estas autenticado"})
    return _wrapped_view