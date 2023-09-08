from django.shortcuts import redirect, render


def admin_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.groups.filter(name='admin').exists():
                return view_func(request, *args, **kwargs)
            else:
                mensaje = "No tienes permisos para acceder a esta página."
                return render(request, "pageError/ErrorPage.html", {'auth_messaje':mensaje})
        return redirect("login")
    return _wrapped_view

def client_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.groups.filter(name='cliente').exists():
                return view_func(request, *args, **kwargs)
            else:
                return view_func(request, *args, **kwargs)
        return render(request,'login_cliente.html',{'auth_messaje': "No estas autenticado"})
    return _wrapped_view