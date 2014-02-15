if gtk_version == 3
@gtktype GtkCssProvider
GtkCssProvider() = GtkCssProvider(ccall((:gtk_css_provider_get_default,libgtk),Ptr{GObject},()))

function GtkCssProvider(;data=nothing,filename=nothing)
    source_count = (data!==nothing) + (filename!==nothing)
    @assert(source_count <= 1,
        "GtkCssProvider must have at most one data, filename, or path argument")
    provider = GtkCssProvider(ccall((:gtk_css_provider_get_default,libgtk),Ptr{GObject},()))
    if data !== nothing
        GError() do error_check
          ccall((:gtk_css_provider_load_from_data,libgtk), Bool,
            (Ptr{GObject}, Ptr{Uint8}, Clong, Ptr{GError}),
            provider, data, -1, error_check)
        end
    elseif filename !== nothing
        GError() do error_check
          ccall((:gtk_css_provider_load_from_path,libgtk), Bool,
            (Ptr{GObject}, Ptr{Uint8}, Clong, Ptr{GError}),
            provider, filename, error_check)
        end
    end
    return provider
end

typealias GtkStyleProviderI Union(GtkCssProvider)

@gtktype GtkStyleContext
GtkStyleContext() = GtkStyleContext(ccall((:gtk_style_context_new,libgtk),Ptr{GObject},()))

push!(context::GtkStyleContext, provider::GtkStyleProviderI, priority::Integer) =
  ccall((:gtk_style_context_add_provider,libgtk),Void,(Ptr{GObject},Ptr{GObject},Cuint), 
         context,provider,priority)
else
    GtkCssProvider(x...) = error("GtkStyleContext is not available until Gtk3.0")
    GtkStyleContext(x...) = error("GtkStyleContext is not available until Gtk3.0")
end