using Oxygen
using HTTP

# ----------- include files ----------
include("htmx.jl")

# mount all files inside the "content" folder under the "/static" path
staticfiles("content", "static")

# ------------ ROUTING ------------
@get "/" function(req::HTTP.Request)
    html(htmx_start)
end
@get "/story" function(req::HTTP.Request)
    html(htmx_page1)
end


@post "/clicked" function(req::HTTP.Request)
    html("<h1>You clicked.</h1>")
end



@get "/greet" function(req::HTTP.Request)
    return "hello world!"
end

@get "/html" function(req::HTTP.Request)
    html("<h1>Hello World</h1>")
end

# Routing Function syntax
@get("/add/{x}/{y}") do request::HTTP.Request, x::Int, y::Int
    x + y
end

@get "/query" function(req::HTTP.Request)
    return queryparams(req) # returns json by default
end

@get "/query2" function(req::HTTP.Request, a::Int, message::String="hello world")
    return (a, message) 
    #needs ?a=5&message=aString or will return message="Server encountered an error "
end

# start the web server
serve()